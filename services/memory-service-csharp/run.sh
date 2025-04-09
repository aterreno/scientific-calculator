#!/bin/bash

set -e

# Colors for terminal output
GREEN='\033[0;32m'
RED='\033[0;31m'
BLUE='\033[0;34m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

echo -e "${BLUE}Memory Service (C#)${NC}"

# Check .NET version
if command -v dotnet >/dev/null 2>&1; then
    dotnet_version=$(dotnet --version)
    min_version="9.0"
    
    echo "Using .NET version: ${dotnet_version}"
    
    # Note that we're checking for .NET 9 which is currently in preview
    # so we may need to be more flexible with version checking
    if [[ "${dotnet_version%%.*}" -lt "${min_version%%.*}" ]]; then
        echo -e "${YELLOW}Warning: .NET version $dotnet_version detected. .NET 9 is recommended.${NC}"
        echo "This service is configured for .NET 9. You may encounter issues with an older version."
        echo "Download .NET 9 preview from: https://dotnet.microsoft.com/download/dotnet/9.0"
        echo ""
        echo -e "${BLUE}Continuing with available .NET version...${NC}"
    fi
else
    echo -e "${RED}Error: .NET is not installed.${NC}"
    echo "Please install .NET SDK from: https://dotnet.microsoft.com/download/dotnet/9.0"
    exit 1
fi

# Function to run tests
run_tests() {
    echo -e "${BLUE}Running tests...${NC}"
    
    if [ "$1" == "--coverage" ]; then
        dotnet test /p:CollectCoverage=true /p:CoverletOutputFormat=lcov /p:CoverletOutput=./lcov.info
        echo -e "${GREEN}Tests completed with coverage report.${NC}"
    else
        dotnet test
        echo -e "${GREEN}Tests completed.${NC}"
    fi
}

# Function to build the application
build() {
    echo -e "${BLUE}Building the application...${NC}"
    dotnet build
    echo -e "${GREEN}Build completed.${NC}"
}

# Function to run the service
run_service() {
    echo -e "${BLUE}Starting Memory Service on port 8009...${NC}"
    echo -e "${BLUE}Press Ctrl+C to stop${NC}"
    dotnet run
}

# Parse command line arguments
if [ $# -eq 0 ]; then
    # No arguments provided, show usage
    echo "Usage: $0 [command]"
    echo "Commands:"
    echo "  test          : Run tests"
    echo "  test-coverage : Run tests with coverage"
    echo "  build         : Build the application"
    echo "  app           : Start the service"
    echo "  help          : Show this help message"
    exit 0
fi

case "$1" in
    test)
        run_tests
        ;;
    test-coverage)
        run_tests --coverage
        ;;
    build)
        build
        ;;
    app)
        run_service
        ;;
    help)
        echo "Usage: $0 [command]"
        echo "Commands:"
        echo "  test          : Run tests"
        echo "  test-coverage : Run tests with coverage"
        echo "  build         : Build the application"
        echo "  app           : Start the service"
        echo "  help          : Show this help message"
        ;;
    *)
        echo -e "${RED}Unknown command: $1${NC}"
        echo "Use '$0 help' for usage information"
        exit 1
        ;;
esac

exit 0