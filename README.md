# Microservice Scientific Calculator

A distributed scientific calculator where each operation is implemented as a microservice in a different programming language.

## Architecture

This project implements a scientific calculator with each operation handled by an independent microservice written in a different programming language:

- Addition: Rust
- Subtraction: Go
- Multiplication: Python
- Division: Ruby
- Power: Java
- Square Root: F#
- Logarithm: PHP
- Trigonometry: Kotlin
- Memory Operations: C#
- Combinatorics/Factorial: Elixir
- Unit Conversion: TypeScript
- Matrix Operations: Julia
- Bitwise Operations: Swift
- Complex Numbers: Clojure
- API Gateway: Node.js
- Frontend: React

## Services

### Addition Service (Rust)
- Port: 8001
- Operations: a + b

### Subtraction Service (Go)
- Port: 8002
- Operations: a - b

### Multiplication Service (Python)
- Port: 8003
- Operations: a * b

### Division Service (Ruby)
- Port: 8004
- Operations: a / b

### Power Service (Java)
- Port: 8005
- Operations: a^b, a^2, a^3

### Square Root Service (F#)
- Port: 8006
- Operations: √a

### Logarithm Service (PHP)
- Port: 8007
- Operations: log(a), ln(a), log10(a)

### Trigonometry Service (Kotlin)
- Port: 8008
- Operations: sin(a), cos(a), tan(a), etc.

### Memory Service (C#)
- Port: 8009
- Operations: M+, M-, MR, MC

### Factorial Service (Elixir)
- Port: 8010
- Operations: factorial(n), permutation(n,r), combination(n,r)

### Conversion Service (TypeScript)
- Port: 8012
- Operations: temperature(value, from, to), length(value, from, to), weight(value, from, to)

### Matrix Service (Julia)
- Port: 8014
- Operations: matrix-add, matrix-multiply, matrix-determinant, matrix-inverse

### Bitwise Service (Swift)
- Port: 8016
- Operations: and, or, xor, not, left-shift, right-shift

### Complex Numbers Service (Clojure)
- Port: 8017
- Operations: complex-add, complex-subtract, complex-multiply, complex-divide, complex-magnitude, complex-conjugate

### API Gateway
- Port: 8000
- Routes requests to appropriate service
- Combines responses

### Frontend
- Port: 3001
- User interface for calculator
- Sends requests to API Gateway

## Setup and Running

### Prerequisites
- Docker and Docker Compose

### Build and Run
```bash
# Build and start all services
docker-compose up --build

# Access the calculator web interface
open http://localhost:3001
```

## API Endpoints

Each service exposes a REST API with JSON input/output. For example:

- Addition: `POST /add` with body `{"a": 5, "b": 3}` returns `{"result": 8}`
- Subtraction: `POST /subtract` with body `{"a": 5, "b": 3}` returns `{"result": 2}`
- And so on...

The API Gateway exposes a unified API at `http://localhost:8000/calculate` that routes operations to the appropriate service.

## Development

To add a new operation:
1. Create a new service directory
2. Implement the operation in a language of your choice
3. Add the service to the docker-compose.yml file
4. Update the API Gateway to route to the new service