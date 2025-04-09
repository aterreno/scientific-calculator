# Power Service (Java)

This microservice handles power operations for the scientific calculator project.

## Features

- Performs power calculations (a^b)
- Square and cube operations
- Health check endpoint
- Comprehensive unit tests

## Endpoints

- `GET /health` - Health check endpoint
- `POST /power` - Power operation with JSON body: `{"a": number, "b": number}`
- `POST /square` - Square operation with JSON body: `{"a": number}`
- `POST /cube` - Cube operation with JSON body: `{"a": number}`

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
# Build the application
MAVEN_OPTS="--add-opens=java.base/java.lang=ALL-UNNAMED" mvn clean package

# Run the tests
MAVEN_OPTS="--add-opens=java.base/java.lang=ALL-UNNAMED" mvn test

# Run the application
MAVEN_OPTS="--add-opens=java.base/java.lang=ALL-UNNAMED" mvn spring-boot:run
```

## Development

This service is built with:

- Java 23.0.2
- Spring Boot 3.2.5
- Maven 3.9.9 for dependency management and building
- JUnit 5 for testing

### Project Structure

- `src/main/java/` - Application code
  - `controller/` - REST controllers
  - `model/` - Data models for requests and responses
- `src/test/java/` - Test files
- `pom.xml` - Maven project configuration