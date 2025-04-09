using Test
using HTTP
using JSON
using LinearAlgebra

# Include the necessary functions to test from the src directory
include("../src/matrix_operations.jl")

@testset "Matrix Service Tests" begin
    @testset "Matrix Addition" begin
        # Test case 1: 2x2 matrices
        matrix_a = [1 2; 3 4]
        matrix_b = [5 6; 7 8]
        result = matrix_add(matrix_a, matrix_b)
        @test result == [6 8; 10 12]
        
        # Test case 2: 1x3 matrices
        matrix_a = [1 2 3]
        matrix_b = [4 5 6]
        result = matrix_add(matrix_a, matrix_b)
        @test result == [5 7 9]
    end
    
    @testset "Matrix Multiplication" begin
        # Test case 1: 2x2 * 2x2
        matrix_a = [1 2; 3 4]
        matrix_b = [5 6; 7 8]
        result = matrix_multiply(matrix_a, matrix_b)
        @test result == [19 22; 43 50]
        
        # Test case 2: 2x3 * 3x2
        matrix_a = [1 2 3; 4 5 6]
        matrix_b = [7 8; 9 10; 11 12]
        result = matrix_multiply(matrix_a, matrix_b)
        @test result == [58 64; 139 154]
    end
    
    @testset "Matrix Determinant" begin
        # Test case 1: 2x2 matrix
        matrix_a = [1 2; 3 4]
        result = matrix_determinant(matrix_a)
        @test result == -2
        
        # Test case 2: 3x3 matrix
        matrix_a = [1 2 3; 4 5 6; 7 8 9]
        result = matrix_determinant(matrix_a)
        @test isapprox(result, 0, atol=1e-10)  # Singular matrix
        
        # Test case 3: 3x3 invertible matrix
        matrix_a = [2 1 3; 4 5 6; 7 8 10]
        result = matrix_determinant(matrix_a)
        @test isapprox(result, -3, atol=1e-10)
    end
    
    @testset "Matrix Inverse" begin
        # Test case 1: 2x2 matrix
        matrix_a = [1 2; 3 4]
        result = matrix_inverse(matrix_a)
        expected = [-2.0 1.0; 1.5 -0.5]
        for i in 1:2, j in 1:2
            @test isapprox(result[i, j], expected[i, j])
        end
        
        # Test case 2: 3x3 invertible matrix
        matrix_a = [2 1 3; 4 5 6; 7 8 10]
        result = matrix_inverse(matrix_a)
        # Multiply by original to get identity matrix
        identity_check = matrix_a * result
        for i in 1:3, j in 1:3
            if i == j
                @test isapprox(identity_check[i, j], 1.0, atol=1e-10)
            else
                @test isapprox(identity_check[i, j], 0.0, atol=1e-10)
            end
        end
    end
    
    @testset "Error Handling" begin
        # Test case 1: Non-matching dimensions for addition
        matrix_a = [1 2; 3 4]
        matrix_b = [5 6 7; 8 9 10]
        @test_throws DimensionMismatch matrix_add(matrix_a, matrix_b)
        
        # Test case 2: Invalid dimensions for multiplication
        matrix_a = [1 2; 3 4]
        matrix_b = [5 6 7; 8 9 10; 11 12 13]
        @test_throws DimensionMismatch matrix_multiply(matrix_a, matrix_b)
        
        # Test case 3: Non-square matrix for determinant
        matrix_a = [1 2 3; 4 5 6]
        @test_throws DimensionMismatch matrix_determinant(matrix_a)
        
        # Test case 4: Non-invertible matrix for inverse
        matrix_a = [1 2 3; 4 5 6; 7 8 9]
        @test_throws SingularException matrix_inverse(matrix_a)
    end
end

# HTTP API Tests - these test the HTTP endpoints and response parsing
@testset "HTTP API Tests" begin
    @testset "Matrix Addition API" begin
        request_body = Dict(
            "a" => [[1, 2], [3, 4]],
            "b" => [[5, 6], [7, 8]]
        )
        request = HTTP.Request("POST", "/add", [], JSON.json(request_body))
        response = handle_matrix_add(request)
        
        @test response.status == 200
        result = JSON.parse(String(response.body))["result"]
        @test result == [[6, 8], [10, 12]]
    end
    
    @testset "Matrix Multiplication API" begin
        request_body = Dict(
            "a" => [[1, 2], [3, 4]],
            "b" => [[5, 6], [7, 8]]
        )
        request = HTTP.Request("POST", "/multiply", [], JSON.json(request_body))
        response = handle_matrix_multiply(request)
        
        @test response.status == 200
        result = JSON.parse(String(response.body))["result"]
        @test result == [[19, 22], [43, 50]]
    end
    
    @testset "Matrix Determinant API" begin
        request_body = Dict(
            "a" => [[1, 2], [3, 4]]
        )
        request = HTTP.Request("POST", "/determinant", [], JSON.json(request_body))
        response = handle_matrix_determinant(request)
        
        @test response.status == 200
        result = JSON.parse(String(response.body))["result"]
        @test result == -2
    end
    
    @testset "Matrix Inverse API" begin
        request_body = Dict(
            "a" => [[1, 2], [3, 4]]
        )
        request = HTTP.Request("POST", "/inverse", [], JSON.json(request_body))
        response = handle_matrix_inverse(request)
        
        @test response.status == 200
        result = JSON.parse(String(response.body))["result"]
        @test isapprox(result[1][1], -2.0, atol=1e-10)
        @test isapprox(result[1][2], 1.0, atol=1e-10)
        @test isapprox(result[2][1], 1.5, atol=1e-10)
        @test isapprox(result[2][2], -0.5, atol=1e-10)
    end
    
    @testset "Error Handling API" begin
        # Test missing parameters
        request_body = Dict("a" => [[1, 2], [3, 4]])
        request = HTTP.Request("POST", "/add", [], JSON.json(request_body))
        response = handle_matrix_add(request)
        @test response.status == 400
        
        # Test invalid dimensions
        request_body = Dict(
            "a" => [[1, 2], [3, 4]],
            "b" => [[5, 6, 7], [8, 9, 10]]
        )
        request = HTTP.Request("POST", "/add", [], JSON.json(request_body))
        response = handle_matrix_add(request)
        @test response.status == 400
        
        # Test non-invertible matrix
        request_body = Dict(
            "a" => [[1, 2, 3], [4, 5, 6], [7, 8, 9]]
        )
        request = HTTP.Request("POST", "/inverse", [], JSON.json(request_body))
        response = handle_matrix_inverse(request)
        @test response.status == 400
    end
end