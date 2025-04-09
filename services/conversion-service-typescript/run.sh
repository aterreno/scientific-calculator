#!/bin/bash

set -e

# Define colors for better readability
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

function print_usage() {
  echo -e "${YELLOW}Usage:${NC} ./run.sh [command]"
  echo ""
  echo "Available commands:"
  echo -e "  ${GREEN}app${NC}       - Build and run the conversion service"
  echo -e "  ${GREEN}test${NC}      - Run tests"
  echo -e "  ${GREEN}coverage${NC}  - Run tests with coverage report"
  echo -e "  ${GREEN}build${NC}     - Only build the TypeScript code"
  echo -e "  ${GREEN}help${NC}      - Show this help message"
}

# Ensure dependencies are installed
function ensure_deps() {
  if [ ! -d "node_modules" ]; then
    echo -e "${YELLOW}Dependencies not found. Installing...${NC}"
    npm install
  fi
}

# Check if the script has permission to execute
if [ ! -x "$0" ]; then
  echo -e "${YELLOW}Making script executable...${NC}"
  chmod +x "$0"
fi

# Handle commands
case "$1" in
  app)
    ensure_deps
    echo -e "${GREEN}Building and starting the conversion service...${NC}"
    npm run build && npm start
    ;;
  test)
    ensure_deps
    echo -e "${GREEN}Running tests...${NC}"
    npm test
    ;;
  coverage)
    ensure_deps
    echo -e "${GREEN}Running tests with coverage...${NC}"
    npm run test:coverage
    ;;
  build)
    ensure_deps
    echo -e "${GREEN}Building TypeScript code...${NC}"
    npm run build
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