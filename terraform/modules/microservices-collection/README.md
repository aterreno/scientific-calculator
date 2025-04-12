# ECS Microservices Collection Module

This Terraform module creates multiple ECS Fargate services for the Scientific Calculator microservices architecture using a single module call.

## Features

- Create multiple microservices at once using a list
- Standardizes configuration across all services
- Reduces duplication in Terraform code

## Usage

```hcl
module "calculator_services" {
  source = "./modules/microservices-collection"

  services = [
    "addition-service",
    "subtraction-service",
    "multiplication-service",
    "division-service",
    "power-service",
    "square-root-service"
  ]
  
  project_name                 = var.project_name
  image_tag                    = var.image_tag
  container_ports              = var.container_port
  cpu_units                    = var.cpu_units
  memory                       = var.memory
  aws_region                   = var.aws_region
  cluster_id                   = aws_ecs_cluster.calculator_cluster.id
  execution_role_arn           = aws_iam_role.ecs_task_execution_role.arn
  vpc_subnets                  = module.vpc.private_subnets
  security_group_id            = aws_security_group.ecs_sg.id
  desired_count                = var.desired_count
  service_discovery_namespace_id = aws_service_discovery_private_dns_namespace.calculator.id
  log_group_name               = aws_cloudwatch_log_group.calculator_logs.name
  dockerhub_credentials_arn    = aws_secretsmanager_secret.dockerhub_credentials.arn
  cpu_architecture             = var.cpu_architecture
  environment                  = var.environment
}
```

## Inputs

| Name | Description | Type | Required |
|------|-------------|------|----------|
| services | List of microservice names to create | list(string) | yes |
| project_name | Name of the project | string | yes |
| image_tag | Docker image tag to deploy | string | yes |
| container_ports | Map of service names to port numbers | map(number) | yes |
| cpu_units | Map of service names to CPU units | map(number) | yes |
| memory | Map of service names to memory in MB | map(number) | yes |
| aws_region | The AWS region to deploy the resources | string | yes |
| cluster_id | ID of the ECS cluster | string | yes |
| execution_role_arn | ARN of the IAM role for ECS task execution | string | yes |
| vpc_subnets | VPC subnet IDs for the ECS service | list(string) | yes |
| security_group_id | ID of the security group for the ECS service | string | yes |
| desired_count | Desired count of tasks | number | yes |
| service_discovery_namespace_id | ID of the Service Discovery namespace | string | yes |
| log_group_name | Name of the CloudWatch log group | string | yes |
| dockerhub_credentials_arn | ARN of the Docker Hub credentials in Secrets Manager | string | yes |
| cpu_architecture | CPU architecture (X86_64 or ARM64) | string | yes |
| environment | Deployment environment | string | yes |

## Outputs

| Name | Description |
|------|-------------|
| task_definition_arns | Map of service names to task definition ARNs |
| service_arns | Map of service names to ECS service ARNs |
| service_discovery_arns | Map of service names to service discovery ARNs |
| service_names | List of service names created |