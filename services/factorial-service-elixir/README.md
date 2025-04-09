# Factorial Service (Elixir)

This service provides factorial, permutation, and combination operations for the scientific calculator microservices application.

## Features

- Factorial calculation (n!)
- Permutation calculation (P(n,r))
- Combination calculation (C(n,r))
- RESTful API with JSON input/output
- Health check endpoint
- Comprehensive unit tests

## Tech Stack

- Elixir 1.14+
- Erlang OTP 25+
- Plug & Cowboy for HTTP server
- Jason for JSON encoding/decoding
- ExUnit for testing
- ExCoveralls for code coverage

## API Endpoints

- `GET /health` - Health check endpoint
- `POST /factorial` - Calculate factorial (n!)
- `POST /permutation` - Calculate permutation (P(n,r))
- `POST /combination` - Calculate combination (C(n,r))

### Request Format (for factorial)

```json
{
  "a": 5
}
```

### Request Format (for permutation and combination)

```json
{
  "a": 5,
  "b": 2
}
```

### Response Format

```json
{
  "result": 120
}
```

## Running the Service

### Prerequisites

- Elixir 1.14 or newer
- Erlang OTP 25 or newer
- Bash-compatible shell (for running the script)

### Using the run.sh Script

The service includes a convenient script to build, test, and run:

```bash
# Show help
./run.sh help

# Run tests
./run.sh test

# Run tests with coverage
./run.sh test-coverage

# Compile the application
./run.sh compile

# Run the service
./run.sh run

# Start interactive Elixir shell with application loaded
./run.sh iex
```

### Manual Build and Run

```bash
# Get dependencies
mix deps.get

# Compile
mix compile

# Run tests
mix test

# Run with code coverage
mix coveralls.html

# Start the service
mix run --no-halt
```

## Docker

```bash
# Build the image
docker build -t factorial-service .

# Run the container
docker run -p 8010:8010 factorial-service
```

## Implementation Details

### Mathematical Functions

- **Factorial (n!)**: The product of all positive integers less than or equal to n
  - Example: 5! = 5 × 4 × 3 × 2 × 1 = 120

- **Permutation (P(n,r))**: The number of ways to arrange r items from a set of n distinct items
  - Formula: P(n,r) = n! / (n-r)!
  - Example: P(5,2) = 5! / (5-2)! = 120 / 6 = 20

- **Combination (C(n,r))**: The number of ways to select r items from a set of n distinct items, regardless of order
  - Formula: C(n,r) = n! / (r! × (n-r)!)
  - Example: C(5,2) = 5! / (2! × 3!) = 120 / (2 × 6) = 10