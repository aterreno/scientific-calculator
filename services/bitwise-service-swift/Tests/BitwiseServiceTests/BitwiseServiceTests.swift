import XCTest
@testable import BitwiseService

final class BitwiseServiceTests: XCTestCase {
    var bitwiseService: BitwiseService!
    
    override func setUp() {
        super.setUp()
        bitwiseService = BitwiseService()
    }
    
    override func tearDown() {
        bitwiseService = nil
        super.tearDown()
    }
    
    func testBitwiseAND() {
        // Test case 1: Basic AND operation
        XCTAssertEqual(bitwiseService.and(5, 3), 1, "5 & 3 should equal 1")
        
        // Test case 2: AND with zero
        XCTAssertEqual(bitwiseService.and(42, 0), 0, "Any value AND 0 should be 0")
        
        // Test case 3: AND with all bits set
        XCTAssertEqual(bitwiseService.and(12, -1), 12, "Any value AND -1 should equal the original value")
        
        // Test case 4: AND with negative numbers
        XCTAssertEqual(bitwiseService.and(-5, 3), 3, "-5 & 3 should equal 3")
    }
    
    func testBitwiseOR() {
        // Test case 1: Basic OR operation
        XCTAssertEqual(bitwiseService.or(5, 3), 7, "5 | 3 should equal 7")
        
        // Test case 2: OR with zero
        XCTAssertEqual(bitwiseService.or(42, 0), 42, "Any value OR 0 should equal the original value")
        
        // Test case 3: OR with all bits set
        XCTAssertEqual(bitwiseService.or(12, -1), -1, "Any value OR -1 should equal -1")
        
        // Test case 4: OR with negative numbers
        XCTAssertEqual(bitwiseService.or(-5, 3), -5, "-5 | 3 should equal -5")
    }
    
    func testBitwiseXOR() {
        // Test case 1: Basic XOR operation
        XCTAssertEqual(bitwiseService.xor(5, 3), 6, "5 ^ 3 should equal 6")
        
        // Test case 2: XOR with zero
        XCTAssertEqual(bitwiseService.xor(42, 0), 42, "Any value XOR 0 should equal the original value")
        
        // Test case 3: XOR with self
        XCTAssertEqual(bitwiseService.xor(15, 15), 0, "Any value XOR itself should equal 0")
        
        // Test case 4: XOR with negative numbers
        XCTAssertEqual(bitwiseService.xor(-5, 3), -8, "-5 ^ 3 should equal -8")
    }
    
    func testBitwiseNOT() {
        // Test case 1: NOT on positive number
        XCTAssertEqual(bitwiseService.not(5), -6, "~5 should equal -6")
        
        // Test case 2: NOT on zero
        XCTAssertEqual(bitwiseService.not(0), -1, "~0 should equal -1")
        
        // Test case 3: NOT on negative number
        XCTAssertEqual(bitwiseService.not(-5), 4, "~-5 should equal 4")
        
        // Test case 4: Double NOT should restore original value
        XCTAssertEqual(bitwiseService.not(bitwiseService.not(42)), 42, "~~42 should equal 42")
    }
    
    func testLeftShift() {
        // Test case 1: Basic left shift
        XCTAssertEqual(bitwiseService.leftShift(1, 2), 4, "1 << 2 should equal 4")
        
        // Test case 2: Left shift by zero
        XCTAssertEqual(bitwiseService.leftShift(42, 0), 42, "42 << 0 should equal 42")
        
        // Test case 3: Left shift with multiple bits
        XCTAssertEqual(bitwiseService.leftShift(3, 3), 24, "3 << 3 should equal 24")
        
        // Test case 4: Left shift with negative number
        XCTAssertEqual(bitwiseService.leftShift(-4, 2), -16, "-4 << 2 should equal -16")
    }
    
    func testRightShift() {
        // Test case 1: Basic right shift
        XCTAssertEqual(bitwiseService.rightShift(8, 2), 2, "8 >> 2 should equal 2")
        
        // Test case 2: Right shift by zero
        XCTAssertEqual(bitwiseService.rightShift(42, 0), 42, "42 >> 0 should equal 42")
        
        // Test case 3: Right shift with multiple bits
        XCTAssertEqual(bitwiseService.rightShift(24, 3), 3, "24 >> 3 should equal 3")
        
        // Test case 4: Right shift with negative number
        // Note: Right shift behavior with negative numbers can be platform-dependent
        // This test verifies Swift's specific behavior
        XCTAssertEqual(bitwiseService.rightShift(-8, 2), -2, "-8 >> 2 should equal -2")
    }
    
    static var allTests = [
        ("testBitwiseAND", testBitwiseAND),
        ("testBitwiseOR", testBitwiseOR),
        ("testBitwiseXOR", testBitwiseXOR),
        ("testBitwiseNOT", testBitwiseNOT),
        ("testLeftShift", testLeftShift),
        ("testRightShift", testRightShift),
    ]
}