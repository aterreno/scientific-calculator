# Square Root Service (F#)

This microservice handles square root operations for the scientific calculator project.

## Features

- Performs square root calculations
- Health check endpoint
- Comprehensive unit tests

## Endpoints

- `GET /health` - Health check endpoint
- `POST /sqrt` - Square root operation with JSON body: `{"a": number}`

## How to Run

This service includes a convenience script to run the application and tests:

```bash
# Prerequisites
# .NET 9.0 Preview 3 SDK: https://dotnet.microsoft.com/download/dotnet/9.0

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
# Make sure you have .NET 9.0 Preview 3 SDK installed

# Build the application
dotnet build

# Run the application
dotnet run

# Run the tests with .NET 9.0
dotnet test
```

## Development

This service is built with:

- F# on .NET 9.0 Preview 3
- Giraffe web framework
- Ply for task computation expressions

### Project Structure

- `Program.fs` - Application entry point and API endpoints
- `Tests/` - Test files
- `SquareRootService.fsproj` - Project configuration