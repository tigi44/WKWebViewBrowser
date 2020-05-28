import XCTest
@testable import WKWebViewBrowser

final class WKWebViewBrowserTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(WKWebViewBrowser().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
