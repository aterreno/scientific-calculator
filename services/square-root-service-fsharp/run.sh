#!/bin/bash

# Script for running the square-root-service-fsharp application and tests
# Usage: ./run.sh [app|test|both]

set -e

# Color codes for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Print header
function print_header() {
  echo -e "${BLUE}======================================${NC}"
  echo -e "${BLUE}$1${NC}"
  echo -e "${BLUE}======================================${NC}"
}

# Check if .NET is installed
function check_environment() {
  if ! command -v dotnet &> /dev/null; then
    echo -e "${RED}.NET SDK is not installed. Please install it before continuing.${NC}"
    exit 1
  fi

  dotnet_version=$(dotnet --version)
  if [[ "$dotnet_version" != 9.* ]]; then
    echo -e "${RED}.NET 9 preview or higher is required. Current version: $dotnet_version${NC}"
    echo -e "${GREEN}You might need to install .NET 9 preview. See: https://dotnet.microsoft.com/download/dotnet/9.0${NC}"
    exit 1
  fi
  echo -e "${GREEN}Using .NET version: $dotnet_version${NC}"
}

# Run the application
function run_app() {
  print_header "Running Square Root Service"
  
  check_environment
  
  echo -e "${GREEN}Building application...${NC}"
  dotnet build
  
  echo -e "${GREEN}Starting F# service on port 8006...${NC}"
  echo -e "${GREEN}Press Ctrl+C to stop${NC}"
  dotnet run
}

# Run the tests
function run_tests() {
  print_header "Running Square Root Service Tests"
  
  check_environment
  
  echo -e "${GREEN}Building tests...${NC}"
  dotnet build
  
  echo -e "${GREEN}Running tests...${NC}"
  dotnet test
  
  if [ $? -eq 0 ]; then
    echo -e "${GREEN}Tests passed successfully!${NC}"
  else
    echo -e "${RED}Tests failed!${NC}"
    exit 1
  fi
}

# Check command line arguments
if [ $# -eq 0 ]; then
  echo "Usage: ./run.sh [app|test|both]"
  echo "  app   - Run the application"
  echo "  test  - Run the tests"
  echo "  both  - Run tests and then the application"
  exit 1
fi

# Process command line arguments
case $1 in
  app)
    run_app
    ;;
  test)
    run_tests
    ;;
  both)
    run_tests
    run_app
    ;;
  *)
    echo -e "${RED}Invalid argument: $1${NC}"
    echo "Usage: ./run.sh [app|test|both]"
    exit 1
    ;;
esac

exit 0