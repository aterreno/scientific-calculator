using HTTP
using JSON
using LinearAlgebra
using Logging

logger = SimpleLogger(stdout, Logging.Info)
global_logger(logger)

# Define the port
port = 8014

# Define matrix operations and handlers directly in this file if include fails
try
    include("src/matrix_operations.jl")
    @info "Successfully loaded matrix_operations.jl"
catch e
    @warn "Could not load matrix_operations.jl, defining functions directly: $e"
    
    # Matrix operations implementations
    function matrix_add(matrix_a::Matrix, matrix_b::Matrix)
        if size(matrix_a) != size(matrix_b)
            throw(DimensionMismatch("Matrix dimensions must match for addition"))
        end
        return matrix_a + matrix_b
    end

    function matrix_multiply(matrix_a::Matrix, matrix_b::Matrix)
        if size(matrix_a, 2) != size(matrix_b, 1)
            throw(DimensionMismatch("Invalid matrix dimensions for multiplication"))
        end
        return matrix_a * matrix_b
    end

    function matrix_determinant(matrix_a::Matrix)
        if size(matrix_a, 1) != size(matrix_a, 2)
            throw(DimensionMismatch("Matrix must be square to compute determinant"))
        end
        return det(matrix_a)
    end

    function matrix_inverse(matrix_a::Matrix)
        if size(matrix_a, 1) != size(matrix_a, 2)
            throw(DimensionMismatch("Matrix must be square to compute inverse"))
        end
        if abs(det(matrix_a)) < 1e-10
            throw(SingularException(size(matrix_a, 1)))
        end
        return inv(matrix_a)
    end
    
    # HTTP handler functions
    function handle_matrix_add(request::HTTP.Request)
        try
            body = JSON.parse(String(request.body))
            
            if !haskey(body, "a") || !haskey(body, "b")
                return HTTP.Response(400, JSON.json(Dict("error" => "Missing required parameters: a, b")))
            end
            
            a = body["a"]
            b = body["b"]
            
            # Check matrix dimensions
            if length(a) != length(b) || length(a[1]) != length(b[1])
                return HTTP.Response(400, JSON.json(Dict("error" => "Matrix dimensions must match")))
            end
            
            # Convert to Julia matrices
            matrix_a = [a[i][j] for i in 1:length(a), j in 1:length(a[1])]
            matrix_b = [b[i][j] for i in 1:length(b), j in 1:length(b[1])]
            
            # Perform addition
            result = matrix_add(matrix_a, matrix_b)
            
            # Convert back to JSON-friendly format
            result_list = [[result[i, j] for j in 1:size(result, 2)] for i in 1:size(result, 1)]
            
            @info "Matrix Addition: $(size(matrix_a)) + $(size(matrix_b)) = $(size(result))"
            
            return HTTP.Response(200, JSON.json(Dict("result" => result_list)))
        catch e
            @error "Error in matrix_add: $e"
            return HTTP.Response(500, JSON.json(Dict("error" => "Internal server error: $(e)")))
        end
    end

    function handle_matrix_multiply(request::HTTP.Request)
        try
            body = JSON.parse(String(request.body))
            
            if !haskey(body, "a") || !haskey(body, "b")
                return HTTP.Response(400, JSON.json(Dict("error" => "Missing required parameters: a, b")))
            end
            
            a = body["a"]
            b = body["b"]
            
            # Check matrix dimensions for multiplication
            if length(a[1]) != length(b)
                return HTTP.Response(400, JSON.json(Dict("error" => "Invalid matrix dimensions for multiplication")))
            end
            
            # Convert to Julia matrices
            matrix_a = [a[i][j] for i in 1:length(a), j in 1:length(a[1])]
            matrix_b = [b[i][j] for i in 1:length(b), j in 1:length(b[1])]
            
            # Perform multiplication
            result = matrix_multiply(matrix_a, matrix_b)
            
            # Convert back to JSON-friendly format
            result_list = [[result[i, j] for j in 1:size(result, 2)] for i in 1:size(result, 1)]
            
            @info "Matrix Multiplication: $(size(matrix_a)) * $(size(matrix_b)) = $(size(result))"
            
            return HTTP.Response(200, JSON.json(Dict("result" => result_list)))
        catch e
            @error "Error in matrix_multiply: $e"
            return HTTP.Response(500, JSON.json(Dict("error" => "Internal server error: $(e)")))
        end
    end

    function handle_matrix_determinant(request::HTTP.Request)
        try
            body = JSON.parse(String(request.body))
            
            if !haskey(body, "a")
                return HTTP.Response(400, JSON.json(Dict("error" => "Missing required parameter: a")))
            end
            
            a = body["a"]
            
            # Check if matrix is square
            if length(a) != length(a[1])
                return HTTP.Response(400, JSON.json(Dict("error" => "Matrix must be square to compute determinant")))
            end
            
            # Convert to Julia matrix
            matrix_a = [a[i][j] for i in 1:length(a), j in 1:length(a[1])]
            
            # Calculate determinant
            result = matrix_determinant(matrix_a)
            
            @info "Matrix Determinant: $(size(matrix_a)) = $result"
            
            return HTTP.Response(200, JSON.json(Dict("result" => result)))
        catch e
            @error "Error in matrix_determinant: $e"
            return HTTP.Response(500, JSON.json(Dict("error" => "Internal server error: $(e)")))
        end
    end

    function handle_matrix_inverse(request::HTTP.Request)
        try
            body = JSON.parse(String(request.body))
            
            if !haskey(body, "a")
                return HTTP.Response(400, JSON.json(Dict("error" => "Missing required parameter: a")))
            end
            
            a = body["a"]
            
            # Check if matrix is square
            if length(a) != length(a[1])
                return HTTP.Response(400, JSON.json(Dict("error" => "Matrix must be square to compute inverse")))
            end
            
            # Convert to Julia matrix
            matrix_a = [a[i][j] for i in 1:length(a), j in 1:length(a[1])]
            
            # Check if matrix is invertible
            if abs(det(matrix_a)) < 1e-10
                return HTTP.Response(400, JSON.json(Dict("error" => "Matrix is not invertible")))
            end
            
            # Calculate inverse
            result = matrix_inverse(matrix_a)
            
            # Convert back to JSON-friendly format
            result_list = [[result[i, j] for j in 1:size(result, 2)] for i in 1:size(result, 1)]
            
            @info "Matrix Inverse: $(size(matrix_a)) = $(size(result))"
            
            return HTTP.Response(200, JSON.json(Dict("result" => result_list)))
        catch e
            @error "Error in matrix_inverse: $e"
            return HTTP.Response(500, JSON.json(Dict("error" => "Internal server error: $(e)")))
        end
    end
end

function handle_health(request::HTTP.Request)
    return HTTP.Response(200, JSON.json(Dict("status" => "healthy")))
end

# Create router
router = HTTP.Router()

HTTP.register!(router, "GET", "/health", handle_health)
HTTP.register!(router, "POST", "/add", handle_matrix_add)
HTTP.register!(router, "POST", "/multiply", handle_matrix_multiply)
HTTP.register!(router, "POST", "/determinant", handle_matrix_determinant)
HTTP.register!(router, "POST", "/inverse", handle_matrix_inverse)

@info "Matrix Service starting on port $port"

# Start the server
HTTP.serve(router, "0.0.0.0", port)