output "task_definition_arns" {
  description = "Map of service names to task definition ARNs"
  value       = { for k, v in module.microservices : k => v.task_definition_arn }
}

output "service_arns" {
  description = "Map of service names to ECS service ARNs"
  value       = { for k, v in module.microservices : k => v.service_arn }
}

output "service_discovery_arns" {
  description = "Map of service names to service discovery ARNs"
  value       = { for k, v in module.microservices : k => v.service_discovery_arn }
}

output "service_names" {
  description = "List of service names created"
  value       = var.services
}