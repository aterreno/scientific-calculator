# Subtraction Service (Go)

This microservice handles subtraction operations for the scientific calculator project.

## Features

- Performs subtraction of two numbers
- Health check endpoint
- Comprehensive unit tests

## Endpoints

- `GET /health` - Health check endpoint
- `POST /subtract` - Subtraction operation with JSON body: `{"a": number, "b": number}`

## How to Run

This service includes a convenience script to run the application and tests:

```bash
# Make the script executable (first time only)
chmod +x run.sh

# Run the application
./run.sh app

# Run the tests
./run.sh test

# Run tests and then the application
./run.sh both
```

### Manual Commands

If you prefer to run commands directly:

```bash
# Run the application
go build -o subtraction-service
./subtraction-service

# Run the tests
go test ./handlers -v
```

## Development

This service is built with:

- Go
- Gin web framework
- Go's built-in testing package with testify assertions

### Project Structure

- `src/main.go` - Application entry point
- `src/handlers/handlers.go` - Request handlers
- `src/handlers/handlers_test.go` - Test files