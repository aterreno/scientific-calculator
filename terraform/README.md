# Scientific Calculator - AWS Terraform Infrastructure

This directory contains Terraform code to deploy the scientific calculator microservices to AWS using ECS (Elastic Container Service) with Fargate.

## Architecture Overview

The deployment creates the following AWS resources:

- VPC with public and private subnets
- ECS Cluster
- Application Load Balancer (ALB)
- ECS Services and Task Definitions for all microservices (with ARM64 architecture)
- Service Discovery using AWS Cloud Map
- CloudWatch Log Groups for monitoring
- Security Groups and IAM roles
- AWS Secrets Manager for Docker Hub credentials

## Prerequisites

- AWS CLI configured with appropriate credentials
- Terraform >= 1.0.0
- Docker images pushed to Docker Hub (aterreno/<service-name>:latest)
- Docker Hub account credentials for authentication

## Configuration

The main configuration is done through variables in `variables.tf`:

- `aws_region`: AWS region to deploy resources
- `project_name`: Prefix for resource names
- `environment`: Environment name (dev, staging, prod)
- `cpu_units` and `memory`: Resource allocation for each service
- `container_port`: Port mappings for each service
- `image_tag`: Docker image tag to use
- `desired_count`: Number of tasks per service
- `dockerhub_username`: Your Docker Hub username
- `dockerhub_password`: Your Docker Hub password or access token
- `cpu_architecture`: CPU architecture for all services - X86_64 or ARM64

## Deployment Instructions

1. Initialize Terraform:

```bash
terraform init
```

2. Review the deployment plan:

```bash
terraform plan
```

3. Apply the infrastructure:

```bash
terraform apply
```

4. Access the application:

After deployment completes, Terraform will output:
- `load_balancer_dns`: The DNS name of the load balancer
- `frontend_url`: URL for the calculator frontend
- `api_gateway_url`: URL for the API Gateway

## Cleanup

To destroy all resources:

```bash
terraform destroy
```

## Additional Information

- The microservices communicate within the VPC using service discovery
- The API Gateway and Frontend are exposed to the public internet via the load balancer
- All containers run in private subnets for security
- Configurable CPU architecture for all task definitions (ARM64 or X86_64)
- Docker Hub authentication is implemented to avoid rate limiting
- For production, consider adding:
  - HTTPS support with AWS Certificate Manager
  - Auto-scaling policies
  - Enhanced monitoring
  - CI/CD pipeline for automated deployments

## Troubleshooting

- **Docker Hub Rate Limiting**: If you encounter `CannotPullContainerError` with "too many requests" messages, verify your Docker Hub credentials are correct.
- **Architecture Compatibility**: Ensure your container images are built for the same architecture as specified in the `cpu_architecture` variable (X86_64 or ARM64). If you encounter "image Manifest does not contain descriptor matching platform" errors, adjust the variable to match your Docker images.
- **Network Connectivity**: If tasks fail to start, check that the VPC, subnets, and security groups are correctly configured for outbound internet access.