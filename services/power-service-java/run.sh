#!/bin/bash

# Script for running the power-service-java application and tests
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

# Check if Maven is installed and Java version is compatible
function check_environment() {
  if ! command -v mvn &> /dev/null; then
    echo -e "${RED}Maven is not installed. Please install it before continuing.${NC}"
    exit 1
  fi

  # Check if Java 23 is available
  java_version=$(java -version 2>&1 | head -1 | cut -d'"' -f2 | sed 's/^1\.//' | cut -d'.' -f1)
  if [ -z "$java_version" ] || [ "$java_version" -lt 23 ]; then
    echo -e "${RED}Java 23 or higher is required. Current version: $java_version${NC}"
    echo -e "${GREEN}You can use JAVA_HOME to point to a Java 23 installation.${NC}"
    exit 1
  fi

  # Check Maven version
  maven_version=$(mvn --version | head -1 | cut -d' ' -f3)
  echo -e "${GREEN}Using Maven version: $maven_version${NC}"
  echo -e "${GREEN}Using Java version: $(java -version 2>&1 | head -1)${NC}"
}

# Run the application
function run_app() {
  print_header "Running Power Service"
  
  check_environment
  
  echo -e "${GREEN}Building application with Java 23 and Spring Boot 3.2.5...${NC}"
  MAVEN_OPTS="--add-opens=java.base/java.lang=ALL-UNNAMED" mvn clean package -DskipTests -q
  
  echo -e "${GREEN}Starting Spring Boot application on port 8005...${NC}"
  echo -e "${GREEN}Press Ctrl+C to stop${NC}"
  MAVEN_OPTS="--add-opens=java.base/java.lang=ALL-UNNAMED" mvn spring-boot:run
}

# Run the tests
function run_tests() {
  print_header "Running Power Service Tests"
  
  check_environment
  
  echo -e "${GREEN}Running tests with Java 23...${NC}"
  MAVEN_OPTS="--add-opens=java.base/java.lang=ALL-UNNAMED" mvn test
  
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