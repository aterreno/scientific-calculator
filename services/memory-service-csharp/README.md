# Memory Service (C#)

This service provides memory operations for the scientific calculator microservices application. It allows adding values to memory, subtracting values from memory, recalling the current memory value, and clearing the memory.

## Features

- Memory Add: Add a value to the memory
- Memory Subtract: Subtract a value from the memory
- Memory Recall: Return the current value in memory
- Memory Clear: Reset the memory to zero
- RESTful API with JSON input/output
- Health check endpoint
- Comprehensive unit tests with XUnit

## Tech Stack

- C# 12.0
- .NET 9.0 (Preview)
- ASP.NET Core 9.0
- XUnit for testing
- Moq for mocking
- Coverlet for code coverage

## API Endpoints

- `GET /health` - Health check endpoint
- `POST /memory-add` - Add value to memory
- `POST /memory-subtract` - Subtract value from memory
- `POST /memory-recall` - Get current memory value
- `POST /memory-clear` - Reset memory to zero

### Request Format (for add/subtract)

```json
{
  "a": 5.0
}
```

### Response Format

```json
{
  "result": 10.0
}
```

## Running the Service

### Prerequisites

- .NET SDK 9.0 (Preview) or newer
- Bash-compatible shell (for running the script)

To install .NET 9.0 Preview:
```bash
# Download from:
https://dotnet.microsoft.com/download/dotnet/9.0
```

### Using the run.sh Script

The service includes a convenient script to build, test, and run:

```bash
# Show help
./run.sh help

# Run tests
./run.sh test

# Run tests with coverage
./run.sh test-coverage

# Build the application
./run.sh build

# Run the service
./run.sh run
```

### Manual Build and Run

```bash
# Build
dotnet build

# Run tests
dotnet test

# Run service
dotnet run
```

## Docker

```bash
# Build the image
docker build -t memory-service .

# Run the container
docker run -p 8009:8009 memory-service
```

## Architecture

The service follows a standard layered architecture:

- **Controllers**: Handle HTTP requests/responses and API endpoints
- **Services**: Contain the business logic and maintain the memory state
- **Models**: Define the data structures for requests and responses

The memory state is maintained as a singleton service throughout the application's lifetime.