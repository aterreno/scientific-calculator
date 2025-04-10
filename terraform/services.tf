# Define API Gateway service
resource "aws_ecs_task_definition" "api_gateway" {
  family                   = "${var.project_name}-api-gateway"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = var.cpu_units["api-gateway"]
  memory                   = var.memory["api-gateway"]
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  
  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture       = var.cpu_architecture
  }

  container_definitions = jsonencode([{
    name      = "api-gateway"
    image     = "aterreno/sci-calc-api-gateway:${var.image_tag}"
    essential = true
    portMappings = [{
      containerPort = var.container_port["api-gateway"]
      hostPort      = var.container_port["api-gateway"]
    }]
    environment = [
      { name = "PORT", value = tostring(var.container_port["api-gateway"]) },
      { name = "ADDITION_SERVICE_URL", value = "http://addition-service:${var.container_port["addition-service"]}" },
      { name = "SUBTRACTION_SERVICE_URL", value = "http://subtraction-service:${var.container_port["subtraction-service"]}" },
      { name = "MULTIPLICATION_SERVICE_URL", value = "http://multiplication-service:${var.container_port["multiplication-service"]}" },
      { name = "DIVISION_SERVICE_URL", value = "http://division-service:${var.container_port["division-service"]}" },
      { name = "POWER_SERVICE_URL", value = "http://power-service:${var.container_port["power-service"]}" },
      { name = "SQUARE_ROOT_SERVICE_URL", value = "http://square-root-service:${var.container_port["square-root-service"]}" },
      { name = "LOG_SERVICE_URL", value = "http://log-service:${var.container_port["log-service"]}" },
      { name = "TRIG_SERVICE_URL", value = "http://trig-service:${var.container_port["trig-service"]}" },
      { name = "MEMORY_SERVICE_URL", value = "http://memory-service:${var.container_port["memory-service"]}" },
      { name = "FACTORIAL_SERVICE_URL", value = "http://factorial-service:${var.container_port["factorial-service"]}" },
      { name = "CONVERSION_SERVICE_URL", value = "http://conversion-service:${var.container_port["conversion-service"]}" },
      { name = "MATRIX_SERVICE_URL", value = "http://matrix-service:${var.container_port["matrix-service"]}" }
    ]
    logConfiguration = {
      logDriver = "awslogs"
      options = {
        "awslogs-group"         = aws_cloudwatch_log_group.calculator_logs.name
        "awslogs-region"        = var.aws_region
        "awslogs-stream-prefix" = "api-gateway"
      }
    }
    repositoryCredentials = {
      credentialsParameter = aws_secretsmanager_secret.dockerhub_credentials.arn
    }
  }])

  tags = {
    Project     = var.project_name
    Environment = var.environment
  }
}

resource "aws_ecs_service" "api_gateway" {
  name                               = "${var.project_name}-api-gateway"
  cluster                            = aws_ecs_cluster.calculator_cluster.id
  task_definition                    = aws_ecs_task_definition.api_gateway.arn
  desired_count                      = var.desired_count
  launch_type                        = "FARGATE"
  health_check_grace_period_seconds  = 60

  network_configuration {
    subnets          = module.vpc.private_subnets
    security_groups  = [aws_security_group.ecs_sg.id]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.api_gateway.arn
    container_name   = "api-gateway"
    container_port   = var.container_port["api-gateway"]
  }

  depends_on = [
    aws_lb_listener.api_gateway
  ]

  tags = {
    Project     = var.project_name
    Environment = var.environment
  }
}

# Define Frontend service
resource "aws_ecs_task_definition" "frontend" {
  family                   = "${var.project_name}-frontend"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = var.cpu_units["frontend"]
  memory                   = var.memory["frontend"]
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  
  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture       = var.cpu_architecture
  }

  container_definitions = jsonencode([{
    name      = "frontend"
    image     = "aterreno/sci-calc-frontend:${var.image_tag}"
    essential = true
    portMappings = [{
      containerPort = var.container_port["frontend"]
      hostPort      = var.container_port["frontend"]
    }]
    environment = [
      { name = "REACT_APP_API_URL", value = "http://${aws_lb.calculator_lb.dns_name}:8000" }
    ]
    logConfiguration = {
      logDriver = "awslogs"
      options = {
        "awslogs-group"         = aws_cloudwatch_log_group.calculator_logs.name
        "awslogs-region"        = var.aws_region
        "awslogs-stream-prefix" = "frontend"
      }
    }
    repositoryCredentials = {
      credentialsParameter = aws_secretsmanager_secret.dockerhub_credentials.arn
    }
  }])

  tags = {
    Project     = var.project_name
    Environment = var.environment
  }
}

resource "aws_ecs_service" "frontend" {
  name                               = "${var.project_name}-frontend"
  cluster                            = aws_ecs_cluster.calculator_cluster.id
  task_definition                    = aws_ecs_task_definition.frontend.arn
  desired_count                      = var.desired_count
  launch_type                        = "FARGATE"
  health_check_grace_period_seconds  = 60

  network_configuration {
    subnets          = module.vpc.private_subnets
    security_groups  = [aws_security_group.ecs_sg.id]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.frontend.arn
    container_name   = "frontend"
    container_port   = var.container_port["frontend"]
  }

  depends_on = [
    aws_lb_listener.frontend
  ]

  tags = {
    Project     = var.project_name
    Environment = var.environment
  }
}