provider "aws" {
  region = var.aws_region
}

# VPC and Networking
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  name = "${var.project_name}-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["${var.aws_region}a", "${var.aws_region}b"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]

  enable_nat_gateway = true
  single_nat_gateway = true

  tags = {
    Project     = var.project_name
    Environment = var.environment
  }
}

# ECS Cluster
resource "aws_ecs_cluster" "calculator_cluster" {
  name = "${var.project_name}-cluster"
  
  setting {
    name  = "containerInsights"
    value = "enabled"
  }

  tags = {
    Project     = var.project_name
    Environment = var.environment
  }
}

# ACM Certificate for HTTPS
resource "aws_acm_certificate" "cert" {
  domain_name       = "calc.terreno.dev"
  validation_method = "DNS"
  
  tags = {
    Project     = var.project_name
    Environment = var.environment
  }

  lifecycle {
    create_before_destroy = true
  }
}

# Output for certificate validation records (to add to DNS)
output "certificate_validation_records" {
  description = "CNAME records needed to validate the certificate"
  value       = aws_acm_certificate.cert.domain_validation_options
}

# Add a DNS validation record placeholder (uncomment and modify this when you have the DNS zone)
# resource "aws_route53_record" "cert_validation" {
#   for_each = {
#     for dvo in aws_acm_certificate.cert.domain_validation_options : dvo.domain_name => {
#       name   = dvo.resource_record_name
#       record = dvo.resource_record_value
#       type   = dvo.resource_record_type
#     }
#   }
#
#   allow_overwrite = true
#   name            = each.value.name
#   records         = [each.value.record]
#   ttl             = 60
#   type            = each.value.type
#   zone_id         = "YOUR_ROUTE53_ZONE_ID" # Replace with your zone ID
# }
#
# resource "aws_acm_certificate_validation" "cert" {
#   certificate_arn         = aws_acm_certificate.cert.arn
#   validation_record_fqdns = [for record in aws_route53_record.cert_validation : record.fqdn]
# }

# Load Balancer
resource "aws_lb" "calculator_lb" {
  name               = "${var.project_name}-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb_sg.id]
  subnets            = module.vpc.public_subnets

  tags = {
    Project     = var.project_name
    Environment = var.environment
  }
}

# HTTP Listener for frontend (redirects to HTTPS)
resource "aws_lb_listener" "frontend_http" {
  load_balancer_arn = aws_lb.calculator_lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"
    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
  
  # Add lifecycle to prevent recreation
  lifecycle {
    create_before_destroy = true
    # Ignore changes to default_action to prevent accidental updates
    ignore_changes = [default_action]
  }
}

# HTTP Listener for API Gateway
resource "aws_lb_listener" "api_gateway_http" {
  load_balancer_arn = aws_lb.calculator_lb.arn
  port              = "8000"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.api_gateway.arn
  }
  
  # Add lifecycle to prevent recreation
  lifecycle {
    create_before_destroy = true
    # Ignore changes to default_action to prevent accidental updates
    ignore_changes = [default_action]
  }
}

# HTTPS Listeners (now enabled since certificate is validated)

# HTTPS Listener for frontend
resource "aws_lb_listener" "frontend_https" {
  load_balancer_arn = aws_lb.calculator_lb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = aws_acm_certificate.cert.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.frontend.arn
  }
  
  lifecycle {
    create_before_destroy = true
  }
}

# HTTPS Listener for API Gateway
resource "aws_lb_listener" "api_gateway_https" {
  load_balancer_arn = aws_lb.calculator_lb.arn
  port              = "8443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = aws_acm_certificate.cert.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.api_gateway.arn
  }
  
  lifecycle {
    create_before_destroy = true
  }
}

# LB Target Group for Frontend
resource "aws_lb_target_group" "frontend" {
  name        = "${var.project_name}-frontend-tg"
  port        = 3001
  protocol    = "HTTP"
  vpc_id      = module.vpc.vpc_id
  target_type = "ip"

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    path                = "/"
    interval            = 30
  }
}

# LB Target Group for API Gateway
resource "aws_lb_target_group" "api_gateway" {
  name        = "${var.project_name}-api-gateway-tg"
  port        = 8000
  protocol    = "HTTP"
  vpc_id      = module.vpc.vpc_id
  target_type = "ip"

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    path                = "/health"
    interval            = 30
  }
}

# Security group for LB
resource "aws_security_group" "lb_sg" {
  name        = "${var.project_name}-lb-sg"
  description = "Security group for load balancer"
  vpc_id      = module.vpc.vpc_id

  # HTTP traffic
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow HTTP traffic"
  }
  
  # HTTPS traffic
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow HTTPS traffic"
  }

  # HTTP API Gateway traffic
  ingress {
    from_port   = 8000
    to_port     = 8000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow HTTP API Gateway traffic"
  }
  
  # HTTPS API Gateway traffic
  ingress {
    from_port   = 8443
    to_port     = 8443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow HTTPS API Gateway traffic"
  }

  # All outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }

  tags = {
    Project     = var.project_name
    Environment = var.environment
  }
  
  # Use lifecycle to prevent recreation
  lifecycle {
    create_before_destroy = true
  }
}

# Security group for ECS services
resource "aws_security_group" "ecs_sg" {
  name        = "${var.project_name}-ecs-sg"
  description = "Security group for ECS tasks"
  vpc_id      = module.vpc.vpc_id

  # Allow ingress traffic from the load balancer
  ingress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = [aws_security_group.lb_sg.id]
  }

  # Allow all intra-service communication within this security group
  ingress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    self            = true
    description     = "Allow all traffic between services in this security group"
  }

  # Allow egress to anywhere
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Project     = var.project_name
    Environment = var.environment
  }
}

# ECR Repositories (optional if using Docker Hub images)
# You can uncomment this if you want to create ECR repositories
/*
resource "aws_ecr_repository" "api_gateway" {
  name = "${var.project_name}-api-gateway"
}

resource "aws_ecr_repository" "frontend" {
  name = "${var.project_name}-frontend"
}

# Add more repositories for each service
*/

# IAM Role for ECS Task Execution
resource "aws_iam_role" "ecs_task_execution_role" {
  name = "${var.project_name}-task-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policy" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# Create a secrets manager secret for Docker Hub credentials
resource "aws_secretsmanager_secret" "dockerhub_credentials" {
  name = "${var.project_name}/dockerhub-credentials-new"
  
  tags = {
    Project     = var.project_name
    Environment = var.environment
  }
}

# Store Docker Hub credentials in the secret
resource "aws_secretsmanager_secret_version" "dockerhub_credentials" {
  secret_id = aws_secretsmanager_secret.dockerhub_credentials.id
  
  # Format Docker Hub credentials exactly as expected by ECS
  # See: https://docs.aws.amazon.com/AmazonECS/latest/developerguide/private-auth.html
  secret_string = jsonencode({
    username = var.dockerhub_username
    password = var.dockerhub_password
  })
}

# Allow ECS task execution role to read the Docker Hub credentials secret
resource "aws_iam_policy" "secrets_access_policy" {
  name        = "${var.project_name}-secrets-access-policy"
  description = "Policy to allow ECS task execution role to access Docker Hub credentials"
  
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "secretsmanager:GetSecretValue"
        ]
        Resource = [
          "${aws_secretsmanager_secret.dockerhub_credentials.arn}*"  # Use wildcard to match any suffix
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "secrets_access_policy" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = aws_iam_policy.secrets_access_policy.arn
}

# Common CloudWatch Log Group
resource "aws_cloudwatch_log_group" "calculator_logs" {
  name              = "/ecs/${var.project_name}"
  retention_in_days = 30

  tags = {
    Project     = var.project_name
    Environment = var.environment
  }
}