# Multiplication Service (Python)

This microservice handles multiplication operations for the scientific calculator project.

## Features

- Performs multiplication of two numbers
- Health check endpoint
- Comprehensive unit tests

## Endpoints

- `GET /health` - Health check endpoint
- `POST /multiply` - Multiplication operation with JSON body: `{"a": number, "b": number}`

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
# Set up Python virtual environment
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
pip install pytest

# Run the application
python app.py

# Run the tests
python -m pytest tests/ -v

# Deactivate virtual environment when done
deactivate
```

## Development

This service is built with:

- Python
- Flask web framework
- Flask-CORS for cross-origin requests
- pytest for testing

### Project Structure

- `app.py` - Application entry point and API endpoints
- `tests/` - Test files
- `requirements.txt` - Python dependencies