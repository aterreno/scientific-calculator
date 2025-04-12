# ECS Microservice Module

This Terraform module creates standardized ECS Fargate services for the Scientific Calculator microservices architecture.

## Features

- Creates an ECS task definition with configurable CPU/memory
- Sets up an ECS service
- Configures service discovery for inter-service communication
- Supports CloudWatch logs
- Handles Docker Hub authentication

## Usage

```hcl
module "example_service" {
  source = "./modules/microservice"

  service_name                 = "example-service"
  project_name                 = var.project_name
  image_tag                    = var.image_tag
  container_port               = var.container_port["example-service"]
  cpu_units                    = var.cpu_units["example-service"]
  memory                       = var.memory["example-service"]
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
| service_name | Name of the microservice (e.g., addition-service) | string | yes |
| project_name | Name of the project | string | yes |
| image_tag | Docker image tag to deploy | string | yes |
| container_port | Port for the container | number | yes |
| cpu_units | CPU units for the ECS task | number | yes |
| memory | Memory for the ECS task in MB | number | yes |
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
| task_definition_arn | ARN of the task definition |
| service_arn | ARN of the ECS service |
| service_discovery_arn | ARN of the service discovery service |
| service_name | Name of the service |