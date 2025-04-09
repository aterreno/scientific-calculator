# Addition Service (Rust)

This microservice handles addition operations for the scientific calculator project.

## Features

- Performs addition of two numbers
- Health check endpoint
- Comprehensive unit tests

## Endpoints

- `GET /health` - Health check endpoint
- `POST /add` - Addition operation with JSON body: `{"a": number, "b": number}`

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
cargo run --release

# Run the tests
cargo test
```

## Development

This service is built with:

- Rust
- Actix Web framework
- Serde for JSON serialization/deserialization

### Project Structure

- `src/lib.rs` - Core functionality and handlers
- `src/main.rs` - Application entry point
- `tests/` - Test files