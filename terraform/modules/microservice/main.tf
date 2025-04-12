# Microservice Module for ECS Fargate Tasks

# Task Definition
resource "aws_ecs_task_definition" "service" {
  family                   = "${var.project_name}-${var.service_name}"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = var.cpu_units
  memory                   = var.memory
  execution_role_arn       = var.execution_role_arn

  container_definitions = jsonencode([{
    name      = var.service_name
    image     = "aterreno/sci-calc-${var.service_name}:${var.image_tag}"
    essential = true
    portMappings = [{
      containerPort = var.container_port
      hostPort      = var.container_port
    }]
    logConfiguration = {
      logDriver = "awslogs"
      options = {
        "awslogs-group"         = var.log_group_name
        "awslogs-region"        = var.aws_region
        "awslogs-stream-prefix" = var.service_name
      }
    }
    repositoryCredentials = {
      credentialsParameter = var.dockerhub_credentials_arn
    }
  }])
  
  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = var.cpu_architecture
  }

  tags = {
    Project     = var.project_name
    Environment = var.environment
  }
}

# ECS Service
resource "aws_ecs_service" "service" {
  name                               = "${var.project_name}-${var.service_name}"
  cluster                            = var.cluster_id
  task_definition                    = aws_ecs_task_definition.service.arn
  desired_count                      = var.desired_count
  launch_type                        = "FARGATE"

  network_configuration {
    subnets          = var.vpc_subnets
    security_groups  = [var.security_group_id]
    assign_public_ip = false
  }

  service_registries {
    registry_arn = aws_service_discovery_service.service.arn
  }

  tags = {
    Project     = var.project_name
    Environment = var.environment
  }
}

# Service Discovery Service
resource "aws_service_discovery_service" "service" {
  name = var.service_name

  dns_config {
    namespace_id = var.service_discovery_namespace_id
    
    dns_records {
      ttl  = 10
      type = "A"
    }

    routing_policy = "MULTIVALUE"
  }

  health_check_custom_config {
    failure_threshold = 1
  }
}