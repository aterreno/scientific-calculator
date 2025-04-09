# Scientific Calculator API Gateway

The API Gateway serves as the central entry point for the Scientific Calculator's microservices. It routes requests to the appropriate service based on the operation type.

## Project Structure

```
api-gateway/
├── server.js         # Express server setup
├── routes.js         # Logic for routing to different services
├── package.json      # Dependencies and scripts
├── run.sh            # Shell script to run app and tests
├── test/             # Test files
│   ├── routes.test.js  # Tests for routes logic
│   └── server.test.js  # Tests for express server
└── README.md         # This file
```

## Features

- Routes calculation requests to the appropriate microservice
- Provides a unified API endpoint for the frontend
- Handles error responses
- Comprehensive test coverage

## Available Operations

The API Gateway supports various operations through its `/calculate` endpoint:

- Basic arithmetic: add, subtract, multiply, divide
- Powers: power, square, cube
- Square root: sqrt
- Logarithmic: log, ln, log10
- Trigonometric: sin, cos, tan, asin, acos, atan
- Memory: memory-add, memory-subtract, memory-recall, memory-clear
- Factorial: factorial, permutation, combination
- Conversion: temperature, length, weight
- Matrix: matrix-add, matrix-multiply, matrix-determinant, matrix-inverse
- Bitwise: and, or, xor, not, left-shift, right-shift
- Complex numbers: complex-add, complex-subtract, complex-multiply, complex-divide, complex-magnitude, complex-conjugate

## Running the Service

### Using the Shell Script

For convenience, use the `run.sh` script:

```bash
# Run the app
./run.sh app

# Run tests
./run.sh test

# Run in development mode (with auto-reload)
./run.sh dev

# Show help
./run.sh help
```

### Manual Commands

```bash
# Install dependencies
npm install

# Start the server
npm start

# Run tests
npm test

# Run tests in watch mode
npm run test:watch

# Start with nodemon (auto-reload on changes)
npm run dev
```

## API Endpoints

### Health Check

```
GET /health
```

Response:
```json
{
  "status": "healthy"
}
```

### Calculate

```
POST /calculate
```

Request body:
```json
{
  "operation": "add",
  "a": 2,
  "b": 3
}
```

Response:
```json
{
  "result": 5
}
```

## Error Handling

The API Gateway returns appropriate status codes and error messages:

- 400 for invalid requests (missing/unsupported operations)
- 500 for service unavailability

Error response example:
```json
{
  "error": "Unsupported operation: invalid",
  "details": "Unsupported operation: invalid"
}
```