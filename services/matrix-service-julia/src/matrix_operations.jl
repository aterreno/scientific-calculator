using LinearAlgebra
using HTTP
using JSON

"""
Add two matrices together
"""
function matrix_add(matrix_a::Matrix, matrix_b::Matrix)
    # Check dimensions match
    if size(matrix_a) != size(matrix_b)
        throw(DimensionMismatch("Matrix dimensions must match for addition"))
    end
    
    # Perform addition and return result
    return matrix_a + matrix_b
end

"""
Multiply two matrices
"""
function matrix_multiply(matrix_a::Matrix, matrix_b::Matrix)
    # Check dimensions compatible for multiplication
    if size(matrix_a, 2) != size(matrix_b, 1)
        throw(DimensionMismatch("Invalid matrix dimensions for multiplication"))
    end
    
    # Perform multiplication and return result
    return matrix_a * matrix_b
end

"""
Calculate the determinant of a matrix
"""
function matrix_determinant(matrix_a::Matrix)
    # Check if matrix is square
    if size(matrix_a, 1) != size(matrix_a, 2)
        throw(DimensionMismatch("Matrix must be square to compute determinant"))
    end
    
    # Calculate determinant and return result
    return det(matrix_a)
end

"""
Calculate the inverse of a matrix
"""
function matrix_inverse(matrix_a::Matrix)
    # Check if matrix is square
    if size(matrix_a, 1) != size(matrix_a, 2)
        throw(DimensionMismatch("Matrix must be square to compute inverse"))
    end
    
    # Check if matrix is invertible
    if abs(det(matrix_a)) < 1e-10
        throw(SingularException(size(matrix_a, 1)))
    end
    
    # Calculate inverse and return result
    return inv(matrix_a)
end

# HTTP handler functions including from app.jl for testing
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
        
        return HTTP.Response(200, JSON.json(Dict("result" => result_list)))
    catch e
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
        
        return HTTP.Response(200, JSON.json(Dict("result" => result_list)))
    catch e
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
        
        return HTTP.Response(200, JSON.json(Dict("result" => result)))
    catch e
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
        
        return HTTP.Response(200, JSON.json(Dict("result" => result_list)))
    catch e
        return HTTP.Response(500, JSON.json(Dict("error" => "Internal server error: $(e)")))
    end
end