#!/bin/bash

set -e

# Define colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Function to check if Swift is installed
check_swift() {
  if ! command -v swift &> /dev/null; then
    echo -e "${RED}Swift is not installed.${NC}"
    echo "Please install Swift from https://swift.org/download/"
    exit 1
  fi
}

# Function to display usage information
print_usage() {
  echo -e "${YELLOW}Usage:${NC} ./run.sh [command]"
  echo ""
  echo "Available commands:"
  echo -e "  ${GREEN}app${NC}       - Run the bitwise service application"
  echo -e "  ${GREEN}test${NC}      - Run tests"
  echo -e "  ${GREEN}build${NC}     - Build the application"
  echo -e "  ${GREEN}help${NC}      - Show this help message"
}

# Make sure script is executable
if [ ! -x "$0" ]; then
  chmod +x "$0"
fi

# Check if swift is installed
check_swift

# Main command handler
case "$1" in
  app)
    echo -e "${GREEN}Building and starting Bitwise Service...${NC}"
    swift run
    ;;
  test)
    echo -e "${GREEN}Running tests...${NC}"
    swift test
    ;;
  build)
    echo -e "${GREEN}Building application...${NC}"
    swift build
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