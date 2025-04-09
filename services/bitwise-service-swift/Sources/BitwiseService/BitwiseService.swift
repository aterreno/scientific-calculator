import Foundation

public struct BitwiseService {
    
    public init() {}
    
    public func and(_ a: Int, _ b: Int) -> Int {
        print("Bitwise AND: \(a) & \(b) = \(a & b)")
        return a & b
    }
    
    public func or(_ a: Int, _ b: Int) -> Int {
        print("Bitwise OR: \(a) | \(b) = \(a | b)")
        return a | b
    }
    
    public func xor(_ a: Int, _ b: Int) -> Int {
        print("Bitwise XOR: \(a) ^ \(b) = \(a ^ b)")
        return a ^ b
    }
    
    public func not(_ a: Int) -> Int {
        print("Bitwise NOT: ~\(a) = \(~a)")
        return ~a
    }
    
    public func leftShift(_ a: Int, _ bits: Int) -> Int {
        print("Left Shift: \(a) << \(bits) = \(a << bits)")
        return a << bits
    }
    
    public func rightShift(_ a: Int, _ bits: Int) -> Int {
        print("Right Shift: \(a) >> \(bits) = \(a >> bits)")
        return a >> bits
    }
}