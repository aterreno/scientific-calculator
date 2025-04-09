FROM golang:1.23-alpine AS builder

WORKDIR /app

# Copy go.mod and go.sum first for better caching
COPY go.mod go.sum ./

# Download dependencies
RUN go mod download

# Copy the rest of the code
COPY . .

# Build the application
RUN go build -o subtraction-service .

FROM alpine:3.18

WORKDIR /app

COPY --from=builder /app/subtraction-service .

EXPOSE 8002

CMD ["./subtraction-service"]