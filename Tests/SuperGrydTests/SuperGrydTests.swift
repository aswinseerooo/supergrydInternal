
import XCTest
@testable import SuperGryd

final class SuperGrydTests: XCTestCase {
    func testGreet() {
        XCTAssertEqual(SuperGryd.greet(name: "World"), "Hello, World!")
    }
}
