#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &> /dev/null && pwd)"
cd "$SCRIPT_DIR"

function print_usage() {
  echo "Usage: ./run.sh [command]"
  echo "Commands:"
  echo "  app   - Run the complex number service application"
  echo "  test  - Run the test suite"
  echo "  help  - Display this help message"
}

case "$1" in
  app)
    echo "Starting complex number service..."
    clojure -M:run
    ;;
  test)
    echo "Running tests..."
    clojure -M:test
    ;;
  help)
    print_usage
    ;;
  *)
    print_usage
    exit 1
    ;;
esac