# Division Service (Ruby)

This microservice handles division operations for the scientific calculator project.

## Features

- Performs division of two numbers
- Health check endpoint
- Comprehensive unit tests
- Handles division by zero errors

## Endpoints

- `GET /health` - Health check endpoint
- `POST /divide` - Division operation with JSON body: `{"a": number, "b": number}`

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
# Install dependencies
bundle install

# Run the application
bundle exec ruby app.rb

# Run the tests
bundle exec rspec spec/
```

## Development

This service is built with:

- Ruby
- Sinatra web framework
- RSpec for testing
- Rack-test for HTTP testing

### Project Structure

- `app.rb` - Application entry point and API endpoints
- `spec/` - Test files
- `Gemfile` - Ruby dependencies