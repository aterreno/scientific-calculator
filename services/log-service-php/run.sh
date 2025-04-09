#!/bin/bash

# Script for running the log-service-php application and tests
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

# Check if PHP and Composer are installed
function check_environment() {
  # Check PHP
  if ! command -v php &> /dev/null; then
    echo -e "${RED}PHP is not installed. Please install it before continuing.${NC}"
    exit 1
  fi

  # Check PHP version
  php_version=$(php -r "echo PHP_VERSION;")
  if [[ $(echo "$php_version" | cut -d. -f1) -lt 8 ]]; then
    echo -e "${RED}PHP 8.0 or higher is required. Current version: $php_version${NC}"
    exit 1
  fi
  echo -e "${GREEN}Using PHP version: $php_version${NC}"

  # Check Composer
  if ! command -v composer &> /dev/null; then
    echo -e "${RED}Composer is not installed. Please install it before continuing.${NC}"
    exit 1
  fi
  
  # Install dependencies if they're not already installed
  if [ ! -d "vendor" ]; then
    echo -e "${GREEN}Installing dependencies...${NC}"
    composer install
  fi
}

# Run the application
function run_app() {
  print_header "Running Logarithm Service"
  
  check_environment
  
  echo -e "${GREEN}Starting PHP built-in server on port 8007...${NC}"
  echo -e "${GREEN}Press Ctrl+C to stop${NC}"
  php -S 0.0.0.0:8007 index.php
}

# Run the tests
function run_tests() {
  print_header "Running Logarithm Service Tests"
  
  check_environment
  
  echo -e "${GREEN}Running PHPUnit tests...${NC}"
  
  # Check if xdebug is available for code coverage
  if php -m | grep -q xdebug; then
    vendor/bin/phpunit --coverage-text
  else
    echo -e "${BLUE}Xdebug is not available. Running tests without code coverage...${NC}"
    vendor/bin/phpunit
  fi
  
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