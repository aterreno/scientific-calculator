# Service Discovery Namespace
resource "aws_service_discovery_private_dns_namespace" "calculator" {
  name        = "calculator.local"
  description = "Calculator services namespace"
  vpc         = module.vpc.vpc_id
}

# Deploy all calculator microservices using the collection module
module "calculator_services" {
  source = "./modules/microservices-collection"

  services = [
    "addition-service",
    "subtraction-service",
    "multiplication-service",
    "division-service",
    "power-service",
    "square-root-service",
    "log-service",
    "trig-service",
    "memory-service",
    "factorial-service",
    "conversion-service",
    "matrix-service",
    "bitwise-service",
    "complex-service"
  ]
  
  project_name                   = var.project_name
  image_tag                      = var.image_tag
  container_ports                = var.container_port
  cpu_units                      = var.cpu_units
  memory                         = var.memory
  aws_region                     = var.aws_region
  cluster_id                     = aws_ecs_cluster.calculator_cluster.id
  execution_role_arn             = aws_iam_role.ecs_task_execution_role.arn
  vpc_subnets                    = module.vpc.private_subnets
  security_group_id              = aws_security_group.ecs_sg.id
  desired_count                  = var.desired_count
  service_discovery_namespace_id = aws_service_discovery_private_dns_namespace.calculator.id
  log_group_name                 = aws_cloudwatch_log_group.calculator_logs.name
  dockerhub_credentials_arn      = aws_secretsmanager_secret.dockerhub_credentials.arn
  cpu_architecture               = var.cpu_architecture
  environment                    = var.environment
}