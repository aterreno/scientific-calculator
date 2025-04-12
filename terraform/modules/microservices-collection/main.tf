# Microservices Collection Module
# This module creates multiple microservices from a list

module "microservices" {
  source   = "../microservice"
  for_each = toset(var.services)

  service_name                 = each.key
  project_name                 = var.project_name
  image_tag                    = var.image_tag
  container_port               = var.container_ports[each.key]
  cpu_units                    = var.cpu_units[each.key]
  memory                       = var.memory[each.key]
  aws_region                   = var.aws_region
  cluster_id                   = var.cluster_id
  execution_role_arn           = var.execution_role_arn
  vpc_subnets                  = var.vpc_subnets
  security_group_id            = var.security_group_id
  desired_count                = var.desired_count
  service_discovery_namespace_id = var.service_discovery_namespace_id
  log_group_name               = var.log_group_name
  dockerhub_credentials_arn    = var.dockerhub_credentials_arn
  cpu_architecture             = var.cpu_architecture
  environment                  = var.environment
}