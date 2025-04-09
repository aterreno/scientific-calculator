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
  echo -e "  ${GREEN}app${NC}       - Run the API gateway service"
  echo -e "  ${GREEN}test${NC}      - Run tests"
  echo -e "  ${GREEN}dev${NC}       - Run the API gateway in development mode with nodemon (auto reload)"
  echo -e "  ${GREEN}help${NC}      - Show this help message"
}

# Ensure dependencies are installed
function ensure_deps() {
  if [ ! -d "node_modules" ] || [ ! -d "node_modules/jest" ] || [ ! -d "node_modules/supertest" ] || [ ! -d "node_modules/axios-mock-adapter" ]; then
    echo -e "${YELLOW}Dependencies not found or incomplete. Installing...${NC}"
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
    echo -e "${GREEN}Starting API Gateway...${NC}"
    npm start
    ;;
  test)
    ensure_deps
    echo -e "${GREEN}Running tests...${NC}"
    
    # Always use the local node_modules binary
    echo -e "${YELLOW}Using local Jest installation...${NC}"
    # Run with silent flag to suppress console.error output
    ./node_modules/.bin/jest --coverage --silent
    
    # Display results and exit code
    TEST_EXIT_CODE=$?
    if [ $TEST_EXIT_CODE -eq 0 ]; then
      echo -e "${GREEN}All tests passed!${NC}"
    else
      echo -e "${RED}Some tests failed. Check the report above.${NC}"
    fi
    # Don't use return in a script, use exit instead
    exit $TEST_EXIT_CODE
    ;;
  dev)
    ensure_deps
    echo -e "${GREEN}Starting API Gateway in development mode...${NC}"
    
    # Always use the local node_modules binary
    echo -e "${YELLOW}Using local Nodemon installation...${NC}"
    ./node_modules/.bin/nodemon server.js
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