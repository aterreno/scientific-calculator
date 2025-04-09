#!/bin/bash

set -e

# Colors for terminal output
GREEN='\033[0;32m'
RED='\033[0;31m'
BLUE='\033[0;34m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

echo -e "${BLUE}Factorial Service (Elixir)${NC}"

# Check Elixir and Erlang versions
if command -v elixir >/dev/null 2>&1; then
    elixir_version=$(elixir --version | grep Elixir | awk '{print $2}')
    min_version="1.14"
    
    echo "Using Elixir version: ${elixir_version}"
    
    # Very basic version check - assumes semantic versioning
    elixir_major=$(echo $elixir_version | cut -d. -f1)
    elixir_minor=$(echo $elixir_version | cut -d. -f2)
    min_major=$(echo $min_version | cut -d. -f1)
    min_minor=$(echo $min_version | cut -d. -f2)
    
    if [[ $elixir_major -lt $min_major || ($elixir_major -eq $min_major && $elixir_minor -lt $min_minor) ]]; then
        echo -e "${RED}Error: Elixir version $elixir_version is too old. Please use Elixir $min_version or newer.${NC}"
        echo "Download from: https://elixir-lang.org/install.html"
        exit 1
    fi
else
    echo -e "${RED}Error: Elixir is not installed.${NC}"
    echo "Please install Elixir from: https://elixir-lang.org/install.html"
    exit 1
fi

# Function to ensure all dependencies are installed
ensure_deps() {
    echo -e "${BLUE}Ensuring dependencies...${NC}"
    mix deps.get
    echo -e "${GREEN}Dependencies ready.${NC}"
}

# Function to compile the application
compile() {
    echo -e "${BLUE}Compiling...${NC}"
    mix compile
    echo -e "${GREEN}Compilation complete.${NC}"
}

# Function to run tests
run_tests() {
    echo -e "${BLUE}Running tests...${NC}"
    
    if [ "$1" == "--coverage" ]; then
        # First make sure ExCoveralls is installed
        if mix help | grep -q "coveralls"; then
            MIX_ENV=test mix coveralls.html
            echo -e "${GREEN}Tests completed. Coverage report generated at cover/excoveralls.html${NC}"
            
            # Display coverage summary if available
            if [ -f "cover/excoveralls.html" ]; then
                coverage_percent=$(grep -o 'Total.*%' cover/excoveralls.html | head -1 | grep -o '[0-9.]*%')
                echo -e "${BLUE}Coverage: ${coverage_percent}${NC}"
            fi
        else
            echo -e "${YELLOW}ExCoveralls not available. Running regular tests...${NC}"
            MIX_ENV=test mix test
            echo -e "${GREEN}Tests completed.${NC}"
        fi
    else
        MIX_ENV=test mix test
        echo -e "${GREEN}Tests completed.${NC}"
    fi
}

# Function to start the application
run_app() {
    echo -e "${BLUE}Starting Factorial Service on port 8010...${NC}"
    echo -e "${BLUE}Press Ctrl+C to stop${NC}"
    mix run --no-halt
}

# Parse command line arguments
if [ $# -eq 0 ]; then
    # No arguments provided, show usage
    echo "Usage: $0 [command]"
    echo "Commands:"
    echo "  test          : Run tests"
    echo "  test-coverage : Run tests with coverage"
    echo "  compile       : Compile the application"
    echo "  app           : Start the service"
    echo "  iex           : Start interactive Elixir shell with the application loaded"
    echo "  help          : Show this help message"
    exit 0
fi

# Ensure dependencies regardless of command
ensure_deps

case "$1" in
    test)
        compile
        run_tests
        ;;
    test-coverage)
        compile
        run_tests --coverage
        ;;
    compile)
        compile
        ;;
    app)
        compile
        run_app
        ;;
    iex)
        echo -e "${BLUE}Starting IEx with Factorial Service loaded...${NC}"
        iex -S mix
        ;;
    help)
        echo "Usage: $0 [command]"
        echo "Commands:"
        echo "  test          : Run tests"
        echo "  test-coverage : Run tests with coverage"
        echo "  compile       : Compile the application"
        echo "  app           : Start the service"
        echo "  iex           : Start interactive Elixir shell with the application loaded"
        echo "  help          : Show this help message"
        ;;
    *)
        echo -e "${RED}Unknown command: $1${NC}"
        echo "Use '$0 help' for usage information"
        exit 1
        ;;
esac

exit 0