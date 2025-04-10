variable "aws_region" {
  description = "The AWS region to deploy the resources"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Name of the project"
  type        = string
  default     = "sci-calc"
}

variable "environment" {
  description = "Environment (dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "cpu_units" {
  description = "CPU units for the ECS task"
  type        = map(number)
  default = {
    "frontend"             = 256
    "api-gateway"          = 256
    "addition-service"     = 256
    "subtraction-service"  = 256
    "multiplication-service" = 256
    "division-service"     = 256
    "power-service"        = 256
    "square-root-service"  = 256
    "log-service"          = 256
    "trig-service"         = 256
    "memory-service"       = 256
    "factorial-service"    = 256
    "conversion-service"   = 256
    "matrix-service"       = 256
    "bitwise-service"      = 256
    "complex-service"      = 256
  }
}

variable "memory" {
  description = "Memory for the ECS task in MB"
  type        = map(number)
  default = {
    "frontend"             = 512
    "api-gateway"          = 512
    "addition-service"     = 512
    "subtraction-service"  = 512
    "multiplication-service" = 512
    "division-service"     = 512
    "power-service"        = 512
    "square-root-service"  = 512
    "log-service"          = 512
    "trig-service"         = 512
    "memory-service"       = 512
    "factorial-service"    = 512
    "conversion-service"   = 512
    "matrix-service"       = 512
    "bitwise-service"      = 512
    "complex-service"      = 512
  }
}

variable "container_port" {
  description = "Port mapping for the containers"
  type        = map(number)
  default = {
    "frontend"             = 3000
    "api-gateway"          = 8000
    "addition-service"     = 8001
    "subtraction-service"  = 8002
    "multiplication-service" = 8003
    "division-service"     = 8004
    "power-service"        = 8005
    "square-root-service"  = 8006
    "log-service"          = 8007
    "trig-service"         = 8008
    "memory-service"       = 8009
    "factorial-service"    = 8010
    "conversion-service"   = 8012
    "matrix-service"       = 8014
    "bitwise-service"      = 8016
    "complex-service"      = 8017
  }
}

variable "image_tag" {
  description = "Docker image tag to deploy"
  type        = string
  default     = "latest"
}

variable "desired_count" {
  description = "Desired count of tasks per service"
  type        = number
  default     = 1
}

variable "dockerhub_username" {
  description = "Docker Hub username for authentication"
  type        = string
  sensitive   = true
}

variable "dockerhub_password" {
  description = "Docker Hub password or access token for authentication"
  type        = string
  sensitive   = true
}

variable "cpu_architecture" {
  description = "CPU architecture for all task definitions (X86_64 or ARM64)"
  type        = string
  default     = "ARM64"
  validation {
    condition     = contains(["X86_64", "ARM64"], var.cpu_architecture)
    error_message = "The cpu_architecture must be either X86_64 or ARM64."
  }
}