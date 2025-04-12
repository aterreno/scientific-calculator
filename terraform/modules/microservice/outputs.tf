output "task_definition_arn" {
  description = "ARN of the task definition"
  value       = aws_ecs_task_definition.service.arn
}

output "service_arn" {
  description = "ARN of the ECS service"
  value       = aws_ecs_service.service.id
}

output "service_discovery_arn" {
  description = "ARN of the service discovery service"
  value       = aws_service_discovery_service.service.arn
}

output "service_name" {
  description = "Name of the service"
  value       = var.service_name
}