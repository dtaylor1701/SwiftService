import XCTest
@testable import SwiftService

final class SwiftServiceTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(SwiftService().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
