variable "service_name" {
  description = "Name of the microservice (e.g., addition-service)"
  type        = string
}

variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "image_tag" {
  description = "Docker image tag to deploy"
  type        = string
}

variable "container_port" {
  description = "Port for the container"
  type        = number
}

variable "cpu_units" {
  description = "CPU units for the ECS task"
  type        = number
}

variable "memory" {
  description = "Memory for the ECS task in MB"
  type        = number
}

variable "aws_region" {
  description = "The AWS region to deploy the resources"
  type        = string
}

variable "cluster_id" {
  description = "ID of the ECS cluster"
  type        = string
}

variable "execution_role_arn" {
  description = "ARN of the IAM role for ECS task execution"
  type        = string
}

variable "vpc_subnets" {
  description = "VPC subnet IDs for the ECS service"
  type        = list(string)
}

variable "security_group_id" {
  description = "ID of the security group for the ECS service"
  type        = string
}

variable "desired_count" {
  description = "Desired count of tasks"
  type        = number
}

variable "service_discovery_namespace_id" {
  description = "ID of the Service Discovery namespace"
  type        = string
}

variable "log_group_name" {
  description = "Name of the CloudWatch log group"
  type        = string
}

variable "dockerhub_credentials_arn" {
  description = "ARN of the Docker Hub credentials in Secrets Manager"
  type        = string
}

variable "cpu_architecture" {
  description = "CPU architecture (X86_64 or ARM64)"
  type        = string
}

variable "environment" {
  description = "Deployment environment"
  type        = string
}