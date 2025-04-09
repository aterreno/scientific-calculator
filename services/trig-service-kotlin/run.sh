#!/bin/bash

set -e

# Colors for terminal output
GREEN='\033[0;32m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}Trig Service (Kotlin)${NC}"

# Function to run tests with coverage
run_tests() {
    echo -e "${BLUE}Running tests...${NC}"
    
    if [ "$1" == "--coverage" ]; then
        ./gradlew test jacocoTestReport
        echo -e "${GREEN}Tests completed. Coverage report generated at: build/reports/jacoco/test/html/index.html${NC}"
    else
        ./gradlew test
        echo -e "${GREEN}Tests completed. Reports available at: build/reports/tests/test/index.html${NC}"
    fi
}

# Function to run the service
run_service() {
    echo -e "${BLUE}Starting Trig Service on port 8008...${NC}"
    echo -e "${BLUE}Press Ctrl+C to stop${NC}"
    ./gradlew bootRun
}

# Function to build the application
build() {
    echo -e "${BLUE}Building the application...${NC}"
    ./gradlew clean build
    echo -e "${GREEN}Build completed. JAR available at: build/libs/trig-service-0.0.1-SNAPSHOT.jar${NC}"
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