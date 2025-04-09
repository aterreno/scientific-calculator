# Log Service (PHP)

This microservice handles logarithm operations for the scientific calculator project.

## Features

- Performs natural logarithm (ln) and base-10 logarithm (log10) operations
- Health check endpoint
- Comprehensive unit tests

## Endpoints

- `GET /health` - Health check endpoint
- `POST /ln` - Natural logarithm operation with JSON body: `{"a": number}`
- `POST /log10` - Base-10 logarithm operation with JSON body: `{"a": number}`

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

### Prerequisites

- PHP 8.0 or higher
- Composer (for dependency management)
- Xdebug (optional, for code coverage reports)

### Manual Commands

If you prefer to run commands directly:

```bash
# Install dependencies
composer install

# Run the application
php -S 0.0.0.0:8007 index.php

# Run the tests
vendor/bin/phpunit
```

## Development

This service is built with:

- PHP 8.0+
- PHPUnit for testing
- Composer for dependency management

### Project Structure

- `index.php` - Application entry point
- `src/LogController.php` - Main controller with log computation logic
- `tests/` - Test files