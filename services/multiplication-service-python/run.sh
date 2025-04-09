#!/bin/bash

# Script for running the multiplication-service-python application and tests
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

# Check if Python environment is set up
function check_environment() {
  # Check if virtual environment exists
  if [ ! -d "venv" ]; then
    echo -e "${GREEN}Creating virtual environment...${NC}"
    python3 -m venv venv
  fi

  # Activate virtual environment
  source venv/bin/activate

  # Install dependencies
  echo -e "${GREEN}Installing dependencies...${NC}"
  pip install -q -r requirements.txt

  # Install test dependencies
  pip install -q pytest
}

# Run the application
function run_app() {
  print_header "Running Multiplication Service"
  
  check_environment
  
  echo -e "${GREEN}Starting server on port 8003...${NC}"
  echo -e "${GREEN}Press Ctrl+C to stop${NC}"
  python app.py
}

# Run the tests
function run_tests() {
  print_header "Running Multiplication Service Tests"
  
  check_environment
  
  echo -e "${GREEN}Running tests...${NC}"
  python -m pytest tests/ -v
  
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

# Deactivate the virtual environment if it was activated
if [ -n "$VIRTUAL_ENV" ]; then
  deactivate
fi

exit 0