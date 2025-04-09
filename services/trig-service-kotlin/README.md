# Trig Service (Kotlin)

This service provides trigonometric operations for the scientific calculator microservices application.

## Features

- Sine, cosine, tangent calculations
- Inverse sine, cosine, and tangent (arc functions)
- RESTful API with JSON input/output
- Health check endpoint
- JUnit 5 tests with parameterized tests

## Tech Stack

- Kotlin 2.0.0
- Spring Boot 3.2.5
- JDK 23
- JUnit 5 / Mockk for testing
- Gradle for build automation
- Docker for containerization

## API Endpoints

- `GET /health` - Health check endpoint
- `POST /sin` - Calculate sine of an angle (in radians)
- `POST /cos` - Calculate cosine of an angle (in radians)
- `POST /tan` - Calculate tangent of an angle (in radians)
- `POST /asin` - Calculate arc sine (inverse sine)
- `POST /acos` - Calculate arc cosine (inverse cosine)
- `POST /atan` - Calculate arc tangent (inverse tangent)

### Request Format

```json
{
  "a": 1.5707963267949
}
```

### Response Format

```json
{
  "result": 1.0
}
```

## Running the Service

### Prerequisites

- JDK 21 (recommended) or JDK 17+
- Gradle (included via wrapper)

If you don't have Java installed or it's not working correctly, visit:
https://www.oracle.com/java/technologies/downloads/#java21

### Using the run.sh Script

The service includes a convenient script to build, test, and run:

```bash
# Show help
./run.sh help

# Run tests
./run.sh test

# Run tests with coverage report
./run.sh test-coverage

# Build the application
./run.sh build

# Run the service
./run.sh run
```

### Manual Build and Run

```bash
# Build
./gradlew clean build

# Run
./gradlew bootRun
```

## Docker

```bash
# Build the image
docker build -t trig-service .

# Run the container
docker run -p 8008:8008 trig-service
```

## Test Examples

- sin(0) = 0
- sin(π/2) = 1
- cos(0) = 1
- cos(π) = -1
- tan(π/4) = 1