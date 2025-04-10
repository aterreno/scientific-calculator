# Addition Service
resource "aws_ecs_task_definition" "addition_service" {
  family                   = "${var.project_name}-addition-service"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = var.cpu_units["addition-service"]
  memory                   = var.memory["addition-service"]
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([{
    name      = "addition-service"
    image     = "aterreno/sci-calc-addition-service:${var.image_tag}"
    essential = true
    portMappings = [{
      containerPort = var.container_port["addition-service"]
      hostPort      = var.container_port["addition-service"]
    }]
    logConfiguration = {
      logDriver = "awslogs"
      options = {
        "awslogs-group"         = aws_cloudwatch_log_group.calculator_logs.name
        "awslogs-region"        = var.aws_region
        "awslogs-stream-prefix" = "addition-service"
      }
    }
    repositoryCredentials = {
      credentialsParameter = aws_secretsmanager_secret.dockerhub_credentials.arn
    }
  }])
  
  # CPU architecture is configurable via variable
  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture       = var.cpu_architecture
  }

  tags = {
    Project     = var.project_name
    Environment = var.environment
  }
}

resource "aws_ecs_service" "addition_service" {
  name                               = "${var.project_name}-addition-service"
  cluster                            = aws_ecs_cluster.calculator_cluster.id
  task_definition                    = aws_ecs_task_definition.addition_service.arn
  desired_count                      = var.desired_count
  launch_type                        = "FARGATE"

  network_configuration {
    subnets          = module.vpc.private_subnets
    security_groups  = [aws_security_group.ecs_sg.id]
    assign_public_ip = false
  }

  service_registries {
    registry_arn = aws_service_discovery_service.addition_service.arn
  }

  tags = {
    Project     = var.project_name
    Environment = var.environment
  }
}

resource "aws_service_discovery_service" "addition_service" {
  name = "addition-service"

  dns_config {
    namespace_id = aws_service_discovery_private_dns_namespace.calculator.id
    
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

# Subtraction Service
resource "aws_ecs_task_definition" "subtraction_service" {
  family                   = "${var.project_name}-subtraction-service"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = var.cpu_units["subtraction-service"]
  memory                   = var.memory["subtraction-service"]
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([{
    name      = "subtraction-service"
    image     = "aterreno/sci-calc-subtraction-service:${var.image_tag}"
    essential = true
    portMappings = [{
      containerPort = var.container_port["subtraction-service"]
      hostPort      = var.container_port["subtraction-service"]
    }]
    logConfiguration = {
      logDriver = "awslogs"
      options = {
        "awslogs-group"         = aws_cloudwatch_log_group.calculator_logs.name
        "awslogs-region"        = var.aws_region
        "awslogs-stream-prefix" = "subtraction-service"
      }
    }
    repositoryCredentials = {
      credentialsParameter = aws_secretsmanager_secret.dockerhub_credentials.arn
    }
  }])
  
  # CPU architecture is configurable via variable
  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture       = var.cpu_architecture
  }

  tags = {
    Project     = var.project_name
    Environment = var.environment
  }
}

resource "aws_ecs_service" "subtraction_service" {
  name                               = "${var.project_name}-subtraction-service"
  cluster                            = aws_ecs_cluster.calculator_cluster.id
  task_definition                    = aws_ecs_task_definition.subtraction_service.arn
  desired_count                      = var.desired_count
  launch_type                        = "FARGATE"

  network_configuration {
    subnets          = module.vpc.private_subnets
    security_groups  = [aws_security_group.ecs_sg.id]
    assign_public_ip = false
  }

  service_registries {
    registry_arn = aws_service_discovery_service.subtraction_service.arn
  }

  tags = {
    Project     = var.project_name
    Environment = var.environment
  }
}

resource "aws_service_discovery_service" "subtraction_service" {
  name = "subtraction-service"

  dns_config {
    namespace_id = aws_service_discovery_private_dns_namespace.calculator.id
    
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

# Multiplication Service
resource "aws_ecs_task_definition" "multiplication_service" {
  family                   = "${var.project_name}-multiplication-service"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = var.cpu_units["multiplication-service"]
  memory                   = var.memory["multiplication-service"]
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([{
    name      = "multiplication-service"
    image     = "aterreno/sci-calc-multiplication-service:${var.image_tag}"
    essential = true
    portMappings = [{
      containerPort = var.container_port["multiplication-service"]
      hostPort      = var.container_port["multiplication-service"]
    }]
    logConfiguration = {
      logDriver = "awslogs"
      options = {
        "awslogs-group"         = aws_cloudwatch_log_group.calculator_logs.name
        "awslogs-region"        = var.aws_region
        "awslogs-stream-prefix" = "multiplication-service"
      }
    }
    repositoryCredentials = {
      credentialsParameter = aws_secretsmanager_secret.dockerhub_credentials.arn
    }
  }])
  
  # CPU architecture is configurable via variable
  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture       = var.cpu_architecture
  }

  tags = {
    Project     = var.project_name
    Environment = var.environment
  }
}

resource "aws_ecs_service" "multiplication_service" {
  name                               = "${var.project_name}-multiplication-service"
  cluster                            = aws_ecs_cluster.calculator_cluster.id
  task_definition                    = aws_ecs_task_definition.multiplication_service.arn
  desired_count                      = var.desired_count
  launch_type                        = "FARGATE"

  network_configuration {
    subnets          = module.vpc.private_subnets
    security_groups  = [aws_security_group.ecs_sg.id]
    assign_public_ip = false
  }

  service_registries {
    registry_arn = aws_service_discovery_service.multiplication_service.arn
  }

  tags = {
    Project     = var.project_name
    Environment = var.environment
  }
}

resource "aws_service_discovery_service" "multiplication_service" {
  name = "multiplication-service"

  dns_config {
    namespace_id = aws_service_discovery_private_dns_namespace.calculator.id
    
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

# Division Service
resource "aws_ecs_task_definition" "division_service" {
  family                   = "${var.project_name}-division-service"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = var.cpu_units["division-service"]
  memory                   = var.memory["division-service"]
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([{
    name      = "division-service"
    image     = "aterreno/sci-calc-division-service:${var.image_tag}"
    essential = true
    portMappings = [{
      containerPort = var.container_port["division-service"]
      hostPort      = var.container_port["division-service"]
    }]
    logConfiguration = {
      logDriver = "awslogs"
      options = {
        "awslogs-group"         = aws_cloudwatch_log_group.calculator_logs.name
        "awslogs-region"        = var.aws_region
        "awslogs-stream-prefix" = "division-service"
      }
    }
    repositoryCredentials = {
      credentialsParameter = aws_secretsmanager_secret.dockerhub_credentials.arn
    }
  }])
  
  # CPU architecture is configurable via variable
  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture       = var.cpu_architecture
  }

  tags = {
    Project     = var.project_name
    Environment = var.environment
  }
}

resource "aws_ecs_service" "division_service" {
  name                               = "${var.project_name}-division-service"
  cluster                            = aws_ecs_cluster.calculator_cluster.id
  task_definition                    = aws_ecs_task_definition.division_service.arn
  desired_count                      = var.desired_count
  launch_type                        = "FARGATE"

  network_configuration {
    subnets          = module.vpc.private_subnets
    security_groups  = [aws_security_group.ecs_sg.id]
    assign_public_ip = false
  }

  service_registries {
    registry_arn = aws_service_discovery_service.division_service.arn
  }

  tags = {
    Project     = var.project_name
    Environment = var.environment
  }
}

resource "aws_service_discovery_service" "division_service" {
  name = "division-service"

  dns_config {
    namespace_id = aws_service_discovery_private_dns_namespace.calculator.id
    
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

# Service Discovery Namespace
resource "aws_service_discovery_private_dns_namespace" "calculator" {
  name        = "calculator.local"
  description = "Calculator services namespace"
  vpc         = module.vpc.vpc_id
}

# Power Service
resource "aws_ecs_task_definition" "power_service" {
  family                   = "${var.project_name}-power-service"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = var.cpu_units["power-service"]
  memory                   = var.memory["power-service"]
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([{
    name      = "power-service"
    image     = "aterreno/sci-calc-power-service:${var.image_tag}"
    essential = true
    portMappings = [{
      containerPort = var.container_port["power-service"]
      hostPort      = var.container_port["power-service"]
    }]
    logConfiguration = {
      logDriver = "awslogs"
      options = {
        "awslogs-group"         = aws_cloudwatch_log_group.calculator_logs.name
        "awslogs-region"        = var.aws_region
        "awslogs-stream-prefix" = "power-service"
      }
    }
    repositoryCredentials = {
      credentialsParameter = aws_secretsmanager_secret.dockerhub_credentials.arn
    }
  }])
  
  # CPU architecture is configurable via variable
  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture       = var.cpu_architecture
  }

  tags = {
    Project     = var.project_name
    Environment = var.environment
  }
}

resource "aws_ecs_service" "power_service" {
  name                               = "${var.project_name}-power-service"
  cluster                            = aws_ecs_cluster.calculator_cluster.id
  task_definition                    = aws_ecs_task_definition.power_service.arn
  desired_count                      = var.desired_count
  launch_type                        = "FARGATE"

  network_configuration {
    subnets          = module.vpc.private_subnets
    security_groups  = [aws_security_group.ecs_sg.id]
    assign_public_ip = false
  }

  service_registries {
    registry_arn = aws_service_discovery_service.power_service.arn
  }

  tags = {
    Project     = var.project_name
    Environment = var.environment
  }
}

resource "aws_service_discovery_service" "power_service" {
  name = "power-service"

  dns_config {
    namespace_id = aws_service_discovery_private_dns_namespace.calculator.id
    
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

# Square Root Service
resource "aws_ecs_task_definition" "square_root_service" {
  family                   = "${var.project_name}-square-root-service"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = var.cpu_units["square-root-service"]
  memory                   = var.memory["square-root-service"]
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([{
    name      = "square-root-service"
    image     = "aterreno/sci-calc-square-root-service:${var.image_tag}"
    essential = true
    portMappings = [{
      containerPort = var.container_port["square-root-service"]
      hostPort      = var.container_port["square-root-service"]
    }]
    logConfiguration = {
      logDriver = "awslogs"
      options = {
        "awslogs-group"         = aws_cloudwatch_log_group.calculator_logs.name
        "awslogs-region"        = var.aws_region
        "awslogs-stream-prefix" = "square-root-service"
      }
    }
    repositoryCredentials = {
      credentialsParameter = aws_secretsmanager_secret.dockerhub_credentials.arn
    }
  }])
  
  # CPU architecture is configurable via variable
  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture       = var.cpu_architecture
  }

  tags = {
    Project     = var.project_name
    Environment = var.environment
  }
}

resource "aws_ecs_service" "square_root_service" {
  name                               = "${var.project_name}-square-root-service"
  cluster                            = aws_ecs_cluster.calculator_cluster.id
  task_definition                    = aws_ecs_task_definition.square_root_service.arn
  desired_count                      = var.desired_count
  launch_type                        = "FARGATE"

  network_configuration {
    subnets          = module.vpc.private_subnets
    security_groups  = [aws_security_group.ecs_sg.id]
    assign_public_ip = false
  }

  service_registries {
    registry_arn = aws_service_discovery_service.square_root_service.arn
  }

  tags = {
    Project     = var.project_name
    Environment = var.environment
  }
}

resource "aws_service_discovery_service" "square_root_service" {
  name = "square-root-service"

  dns_config {
    namespace_id = aws_service_discovery_private_dns_namespace.calculator.id
    
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

# Log Service
resource "aws_ecs_task_definition" "log_service" {
  family                   = "${var.project_name}-log-service"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = var.cpu_units["log-service"]
  memory                   = var.memory["log-service"]
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([{
    name      = "log-service"
    image     = "aterreno/sci-calc-log-service:${var.image_tag}"
    essential = true
    portMappings = [{
      containerPort = var.container_port["log-service"]
      hostPort      = var.container_port["log-service"]
    }]
    logConfiguration = {
      logDriver = "awslogs"
      options = {
        "awslogs-group"         = aws_cloudwatch_log_group.calculator_logs.name
        "awslogs-region"        = var.aws_region
        "awslogs-stream-prefix" = "log-service"
      }
    }
    repositoryCredentials = {
      credentialsParameter = aws_secretsmanager_secret.dockerhub_credentials.arn
    }
  }])
  
  # CPU architecture is configurable via variable
  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture       = var.cpu_architecture
  }

  tags = {
    Project     = var.project_name
    Environment = var.environment
  }
}

resource "aws_ecs_service" "log_service" {
  name                               = "${var.project_name}-log-service"
  cluster                            = aws_ecs_cluster.calculator_cluster.id
  task_definition                    = aws_ecs_task_definition.log_service.arn
  desired_count                      = var.desired_count
  launch_type                        = "FARGATE"

  network_configuration {
    subnets          = module.vpc.private_subnets
    security_groups  = [aws_security_group.ecs_sg.id]
    assign_public_ip = false
  }

  service_registries {
    registry_arn = aws_service_discovery_service.log_service.arn
  }

  tags = {
    Project     = var.project_name
    Environment = var.environment
  }
}

resource "aws_service_discovery_service" "log_service" {
  name = "log-service"

  dns_config {
    namespace_id = aws_service_discovery_private_dns_namespace.calculator.id
    
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

# Trig Service
resource "aws_ecs_task_definition" "trig_service" {
  family                   = "${var.project_name}-trig-service"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = var.cpu_units["trig-service"]
  memory                   = var.memory["trig-service"]
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([{
    name      = "trig-service"
    image     = "aterreno/sci-calc-trig-service:${var.image_tag}"
    essential = true
    portMappings = [{
      containerPort = var.container_port["trig-service"]
      hostPort      = var.container_port["trig-service"]
    }]
    logConfiguration = {
      logDriver = "awslogs"
      options = {
        "awslogs-group"         = aws_cloudwatch_log_group.calculator_logs.name
        "awslogs-region"        = var.aws_region
        "awslogs-stream-prefix" = "trig-service"
      }
    }
    repositoryCredentials = {
      credentialsParameter = aws_secretsmanager_secret.dockerhub_credentials.arn
    }
  }])
  
  # CPU architecture is configurable via variable
  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture       = var.cpu_architecture
  }

  tags = {
    Project     = var.project_name
    Environment = var.environment
  }
}

resource "aws_ecs_service" "trig_service" {
  name                               = "${var.project_name}-trig-service"
  cluster                            = aws_ecs_cluster.calculator_cluster.id
  task_definition                    = aws_ecs_task_definition.trig_service.arn
  desired_count                      = var.desired_count
  launch_type                        = "FARGATE"

  network_configuration {
    subnets          = module.vpc.private_subnets
    security_groups  = [aws_security_group.ecs_sg.id]
    assign_public_ip = false
  }

  service_registries {
    registry_arn = aws_service_discovery_service.trig_service.arn
  }

  tags = {
    Project     = var.project_name
    Environment = var.environment
  }
}

resource "aws_service_discovery_service" "trig_service" {
  name = "trig-service"

  dns_config {
    namespace_id = aws_service_discovery_private_dns_namespace.calculator.id
    
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

# Memory Service
resource "aws_ecs_task_definition" "memory_service" {
  family                   = "${var.project_name}-memory-service"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = var.cpu_units["memory-service"]
  memory                   = var.memory["memory-service"]
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([{
    name      = "memory-service"
    image     = "aterreno/sci-calc-memory-service:${var.image_tag}"
    essential = true
    portMappings = [{
      containerPort = var.container_port["memory-service"]
      hostPort      = var.container_port["memory-service"]
    }]
    logConfiguration = {
      logDriver = "awslogs"
      options = {
        "awslogs-group"         = aws_cloudwatch_log_group.calculator_logs.name
        "awslogs-region"        = var.aws_region
        "awslogs-stream-prefix" = "memory-service"
      }
    }
    repositoryCredentials = {
      credentialsParameter = aws_secretsmanager_secret.dockerhub_credentials.arn
    }
  }])
  
  # CPU architecture is configurable via variable
  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture       = var.cpu_architecture
  }

  tags = {
    Project     = var.project_name
    Environment = var.environment
  }
}

resource "aws_ecs_service" "memory_service" {
  name                               = "${var.project_name}-memory-service"
  cluster                            = aws_ecs_cluster.calculator_cluster.id
  task_definition                    = aws_ecs_task_definition.memory_service.arn
  desired_count                      = var.desired_count
  launch_type                        = "FARGATE"

  network_configuration {
    subnets          = module.vpc.private_subnets
    security_groups  = [aws_security_group.ecs_sg.id]
    assign_public_ip = false
  }

  service_registries {
    registry_arn = aws_service_discovery_service.memory_service.arn
  }

  tags = {
    Project     = var.project_name
    Environment = var.environment
  }
}

resource "aws_service_discovery_service" "memory_service" {
  name = "memory-service"

  dns_config {
    namespace_id = aws_service_discovery_private_dns_namespace.calculator.id
    
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

# Factorial Service
resource "aws_ecs_task_definition" "factorial_service" {
  family                   = "${var.project_name}-factorial-service"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = var.cpu_units["factorial-service"]
  memory                   = var.memory["factorial-service"]
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([{
    name      = "factorial-service"
    image     = "aterreno/sci-calc-factorial-service:${var.image_tag}"
    essential = true
    portMappings = [{
      containerPort = var.container_port["factorial-service"]
      hostPort      = var.container_port["factorial-service"]
    }]
    logConfiguration = {
      logDriver = "awslogs"
      options = {
        "awslogs-group"         = aws_cloudwatch_log_group.calculator_logs.name
        "awslogs-region"        = var.aws_region
        "awslogs-stream-prefix" = "factorial-service"
      }
    }
    repositoryCredentials = {
      credentialsParameter = aws_secretsmanager_secret.dockerhub_credentials.arn
    }
  }])
  
  # CPU architecture is configurable via variable
  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture       = var.cpu_architecture
  }

  tags = {
    Project     = var.project_name
    Environment = var.environment
  }
}

resource "aws_ecs_service" "factorial_service" {
  name                               = "${var.project_name}-factorial-service"
  cluster                            = aws_ecs_cluster.calculator_cluster.id
  task_definition                    = aws_ecs_task_definition.factorial_service.arn
  desired_count                      = var.desired_count
  launch_type                        = "FARGATE"

  network_configuration {
    subnets          = module.vpc.private_subnets
    security_groups  = [aws_security_group.ecs_sg.id]
    assign_public_ip = false
  }

  service_registries {
    registry_arn = aws_service_discovery_service.factorial_service.arn
  }

  tags = {
    Project     = var.project_name
    Environment = var.environment
  }
}

resource "aws_service_discovery_service" "factorial_service" {
  name = "factorial-service"

  dns_config {
    namespace_id = aws_service_discovery_private_dns_namespace.calculator.id
    
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

# Conversion Service
resource "aws_ecs_task_definition" "conversion_service" {
  family                   = "${var.project_name}-conversion-service"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = var.cpu_units["conversion-service"]
  memory                   = var.memory["conversion-service"]
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([{
    name      = "conversion-service"
    image     = "aterreno/sci-calc-conversion-service:${var.image_tag}"
    essential = true
    portMappings = [{
      containerPort = var.container_port["conversion-service"]
      hostPort      = var.container_port["conversion-service"]
    }]
    logConfiguration = {
      logDriver = "awslogs"
      options = {
        "awslogs-group"         = aws_cloudwatch_log_group.calculator_logs.name
        "awslogs-region"        = var.aws_region
        "awslogs-stream-prefix" = "conversion-service"
      }
    }
    repositoryCredentials = {
      credentialsParameter = aws_secretsmanager_secret.dockerhub_credentials.arn
    }
  }])
  
  # CPU architecture is configurable via variable
  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture       = var.cpu_architecture
  }

  tags = {
    Project     = var.project_name
    Environment = var.environment
  }
}

resource "aws_ecs_service" "conversion_service" {
  name                               = "${var.project_name}-conversion-service"
  cluster                            = aws_ecs_cluster.calculator_cluster.id
  task_definition                    = aws_ecs_task_definition.conversion_service.arn
  desired_count                      = var.desired_count
  launch_type                        = "FARGATE"

  network_configuration {
    subnets          = module.vpc.private_subnets
    security_groups  = [aws_security_group.ecs_sg.id]
    assign_public_ip = false
  }

  service_registries {
    registry_arn = aws_service_discovery_service.conversion_service.arn
  }

  tags = {
    Project     = var.project_name
    Environment = var.environment
  }
}

resource "aws_service_discovery_service" "conversion_service" {
  name = "conversion-service"

  dns_config {
    namespace_id = aws_service_discovery_private_dns_namespace.calculator.id
    
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

# Matrix Service
resource "aws_ecs_task_definition" "matrix_service" {
  family                   = "${var.project_name}-matrix-service"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = var.cpu_units["matrix-service"]
  memory                   = var.memory["matrix-service"]
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([{
    name      = "matrix-service"
    image     = "aterreno/sci-calc-matrix-service:${var.image_tag}"
    essential = true
    portMappings = [{
      containerPort = var.container_port["matrix-service"]
      hostPort      = var.container_port["matrix-service"]
    }]
    logConfiguration = {
      logDriver = "awslogs"
      options = {
        "awslogs-group"         = aws_cloudwatch_log_group.calculator_logs.name
        "awslogs-region"        = var.aws_region
        "awslogs-stream-prefix" = "matrix-service"
      }
    }
    repositoryCredentials = {
      credentialsParameter = aws_secretsmanager_secret.dockerhub_credentials.arn
    }
  }])
  
  # CPU architecture is configurable via variable
  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture       = var.cpu_architecture
  }

  tags = {
    Project     = var.project_name
    Environment = var.environment
  }
}

resource "aws_ecs_service" "matrix_service" {
  name                               = "${var.project_name}-matrix-service"
  cluster                            = aws_ecs_cluster.calculator_cluster.id
  task_definition                    = aws_ecs_task_definition.matrix_service.arn
  desired_count                      = var.desired_count
  launch_type                        = "FARGATE"

  network_configuration {
    subnets          = module.vpc.private_subnets
    security_groups  = [aws_security_group.ecs_sg.id]
    assign_public_ip = false
  }

  service_registries {
    registry_arn = aws_service_discovery_service.matrix_service.arn
  }

  tags = {
    Project     = var.project_name
    Environment = var.environment
  }
}

resource "aws_service_discovery_service" "matrix_service" {
  name = "matrix-service"

  dns_config {
    namespace_id = aws_service_discovery_private_dns_namespace.calculator.id
    
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

# Bitwise Service
resource "aws_ecs_task_definition" "bitwise_service" {
  family                   = "${var.project_name}-bitwise-service"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = var.cpu_units["bitwise-service"]
  memory                   = var.memory["bitwise-service"]
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([{
    name      = "bitwise-service"
    image     = "aterreno/sci-calc-bitwise-service:${var.image_tag}"
    essential = true
    portMappings = [{
      containerPort = var.container_port["bitwise-service"]
      hostPort      = var.container_port["bitwise-service"]
    }]
    logConfiguration = {
      logDriver = "awslogs"
      options = {
        "awslogs-group"         = aws_cloudwatch_log_group.calculator_logs.name
        "awslogs-region"        = var.aws_region
        "awslogs-stream-prefix" = "bitwise-service"
      }
    }
    repositoryCredentials = {
      credentialsParameter = aws_secretsmanager_secret.dockerhub_credentials.arn
    }
  }])
  
  # CPU architecture is configurable via variable
  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture       = var.cpu_architecture
  }

  tags = {
    Project     = var.project_name
    Environment = var.environment
  }
}

resource "aws_ecs_service" "bitwise_service" {
  name                               = "${var.project_name}-bitwise-service"
  cluster                            = aws_ecs_cluster.calculator_cluster.id
  task_definition                    = aws_ecs_task_definition.bitwise_service.arn
  desired_count                      = var.desired_count
  launch_type                        = "FARGATE"

  network_configuration {
    subnets          = module.vpc.private_subnets
    security_groups  = [aws_security_group.ecs_sg.id]
    assign_public_ip = false
  }

  service_registries {
    registry_arn = aws_service_discovery_service.bitwise_service.arn
  }

  tags = {
    Project     = var.project_name
    Environment = var.environment
  }
}

resource "aws_service_discovery_service" "bitwise_service" {
  name = "bitwise-service"

  dns_config {
    namespace_id = aws_service_discovery_private_dns_namespace.calculator.id
    
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

# Complex Service
resource "aws_ecs_task_definition" "complex_service" {
  family                   = "${var.project_name}-complex-service"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = var.cpu_units["complex-service"]
  memory                   = var.memory["complex-service"]
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([{
    name      = "complex-service"
    image     = "aterreno/sci-calc-complex-service:${var.image_tag}"
    essential = true
    portMappings = [{
      containerPort = var.container_port["complex-service"]
      hostPort      = var.container_port["complex-service"]
    }]
    logConfiguration = {
      logDriver = "awslogs"
      options = {
        "awslogs-group"         = aws_cloudwatch_log_group.calculator_logs.name
        "awslogs-region"        = var.aws_region
        "awslogs-stream-prefix" = "complex-service"
      }
    }
    repositoryCredentials = {
      credentialsParameter = aws_secretsmanager_secret.dockerhub_credentials.arn
    }
  }])
  
  # CPU architecture is configurable via variable
  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture       = var.cpu_architecture
  }

  tags = {
    Project     = var.project_name
    Environment = var.environment
  }
}

resource "aws_ecs_service" "complex_service" {
  name                               = "${var.project_name}-complex-service"
  cluster                            = aws_ecs_cluster.calculator_cluster.id
  task_definition                    = aws_ecs_task_definition.complex_service.arn
  desired_count                      = var.desired_count
  launch_type                        = "FARGATE"

  network_configuration {
    subnets          = module.vpc.private_subnets
    security_groups  = [aws_security_group.ecs_sg.id]
    assign_public_ip = false
  }

  service_registries {
    registry_arn = aws_service_discovery_service.complex_service.arn
  }

  tags = {
    Project     = var.project_name
    Environment = var.environment
  }
}

resource "aws_service_discovery_service" "complex_service" {
  name = "complex-service"

  dns_config {
    namespace_id = aws_service_discovery_private_dns_namespace.calculator.id
    
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