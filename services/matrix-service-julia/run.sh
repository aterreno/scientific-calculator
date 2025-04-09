#!/bin/bash

set -e

# Define colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Function to check if Julia is installed
check_julia() {
  if ! command -v julia &> /dev/null; then
    echo -e "${RED}Julia is not installed.${NC}"
    echo "Please install Julia from https://julialang.org/downloads/"
    exit 1
  fi
}

# Function to check if project dependencies are installed
check_deps() {
  echo -e "${YELLOW}Installing dependencies...${NC}"
  julia --project=. -e 'using Pkg; Pkg.instantiate()'
}

# Function to display usage information
print_usage() {
  echo -e "${YELLOW}Usage:${NC} ./run.sh [command]"
  echo ""
  echo "Available commands:"
  echo -e "  ${GREEN}app${NC}       - Run the matrix service application"
  echo -e "  ${GREEN}test${NC}      - Run tests"
  echo -e "  ${GREEN}help${NC}      - Show this help message"
}

# Make sure script is executable
if [ ! -x "$0" ]; then
  chmod +x "$0"
fi

# Check if julia is installed
check_julia

# Main command handler
case "$1" in
  app)
    check_deps
    echo -e "${GREEN}Starting Matrix Service...${NC}"
    julia --project=. app.jl
    ;;
  test)
    check_deps
    echo -e "${GREEN}Running tests...${NC}"
    julia --project=. test/runtests.jl
    ;;
  help|"")
    print_usage
    ;;
  *)
    echo -e "${RED}Unknown command: $1${NC}"
    print_usage
    exit 1
    ;;
esac