#!/bin/sh
set -e

# Check if running in AWS (determined by setting DEPLOYMENT_ENV=aws)
if [ "$DEPLOYMENT_ENV" = "aws" ]; then
  echo "Running in AWS environment, using templated config"
  
  # Ensure API_GATEWAY_ENDPOINT is set
  if [ -z "$API_GATEWAY_ENDPOINT" ]; then
    echo "ERROR: API_GATEWAY_ENDPOINT environment variable must be set in AWS mode"
    exit 1
  fi
  
  # Copy the templated config in place
  envsubst '${API_GATEWAY_ENDPOINT}' < /etc/nginx/templates/default.conf.template > /etc/nginx/conf.d/default.conf
  
  echo "Configured nginx to use API Gateway at: $API_GATEWAY_ENDPOINT"
else
  echo "Running in local environment, using standard config"
  # The standard nginx.conf is already copied, no action needed
fi

# Execute the main command
exec "$@"