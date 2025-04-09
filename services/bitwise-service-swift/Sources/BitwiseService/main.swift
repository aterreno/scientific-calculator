import Vapor

struct HealthResponse: Content {
    let status: String
}

struct BitwiseRequest: Content {
    let a: Int
    let b: Int
}

struct BitwiseResult: Content {
    let result: Int
}

struct ShiftRequest: Content {
    let a: Int
    let bits: Int
}

struct BitwiseService {
    
    func and(_ a: Int, _ b: Int) -> Int {
        print("Bitwise AND: \(a) & \(b) = \(a & b)")
        return a & b
    }
    
    func or(_ a: Int, _ b: Int) -> Int {
        print("Bitwise OR: \(a) | \(b) = \(a | b)")
        return a | b
    }
    
    func xor(_ a: Int, _ b: Int) -> Int {
        print("Bitwise XOR: \(a) ^ \(b) = \(a ^ b)")
        return a ^ b
    }
    
    func not(_ a: Int) -> Int {
        print("Bitwise NOT: ~\(a) = \(~a)")
        return ~a
    }
    
    func leftShift(_ a: Int, _ bits: Int) -> Int {
        print("Left Shift: \(a) << \(bits) = \(a << bits)")
        return a << bits
    }
    
    func rightShift(_ a: Int, _ bits: Int) -> Int {
        print("Right Shift: \(a) >> \(bits) = \(a >> bits)")
        return a >> bits
    }
}

// Create application
let app = Application()
let bitwiseService = BitwiseService()

// Configure routes
app.get("health") { req -> HealthResponse in
    return HealthResponse(status: "healthy")
}

app.post("and") { req -> BitwiseResult in
    let bitwiseRequest = try req.content.decode(BitwiseRequest.self)
    return BitwiseResult(result: bitwiseService.and(bitwiseRequest.a, bitwiseRequest.b))
}

app.post("or") { req -> BitwiseResult in
    let bitwiseRequest = try req.content.decode(BitwiseRequest.self)
    return BitwiseResult(result: bitwiseService.or(bitwiseRequest.a, bitwiseRequest.b))
}

app.post("xor") { req -> BitwiseResult in
    let bitwiseRequest = try req.content.decode(BitwiseRequest.self)
    return BitwiseResult(result: bitwiseService.xor(bitwiseRequest.a, bitwiseRequest.b))
}

app.post("not") { req -> BitwiseResult in
    struct NotRequest: Content {
        let a: Int
    }
    let notRequest = try req.content.decode(NotRequest.self)
    return BitwiseResult(result: bitwiseService.not(notRequest.a))
}

app.post("left-shift") { req -> BitwiseResult in
    let shiftRequest = try req.content.decode(ShiftRequest.self)
    return BitwiseResult(result: bitwiseService.leftShift(shiftRequest.a, shiftRequest.bits))
}

app.post("right-shift") { req -> BitwiseResult in
    let shiftRequest = try req.content.decode(ShiftRequest.self)
    return BitwiseResult(result: bitwiseService.rightShift(shiftRequest.a, shiftRequest.bits))
}

// Start server
print("Bitwise Service starting on port 8016")
app.http.server.configuration.port = 8016
app.http.server.configuration.hostname = "0.0.0.0"

try app.run()