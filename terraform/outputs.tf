output "load_balancer_dns" {
  description = "Public DNS name of the load balancer"
  value       = aws_lb.calculator_lb.dns_name
}

output "api_gateway_url" {
  description = "URL for the API Gateway service"
  value       = "http://${aws_lb.calculator_lb.dns_name}:8000"
}

output "frontend_url" {
  description = "URL for the frontend application"
  value       = "http://${aws_lb.calculator_lb.dns_name}"
}

output "ecs_cluster_name" {
  description = "Name of the ECS cluster"
  value       = aws_ecs_cluster.calculator_cluster.name
}

output "cloud_watch_log_group" {
  description = "CloudWatch Log Group for service logs"
  value       = aws_cloudwatch_log_group.calculator_logs.name
}

# Output task definitions to verify architecture settings
output "frontend_task_definition" {
  description = "Frontend task definition including architecture settings"
  value = {
    family = aws_ecs_task_definition.frontend.family
    cpu_architecture = aws_ecs_task_definition.frontend.runtime_platform[0].cpu_architecture
  }
}

output "api_gateway_task_definition" {
  description = "API Gateway task definition including architecture settings"
  value = {
    family = aws_ecs_task_definition.api_gateway.family
    cpu_architecture = aws_ecs_task_definition.api_gateway.runtime_platform[0].cpu_architecture
  }
}