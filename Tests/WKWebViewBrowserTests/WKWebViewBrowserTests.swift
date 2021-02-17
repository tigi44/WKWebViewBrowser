import XCTest
@testable import WKWebViewBrowser
import WebKit

final class WKWebViewBrowserTests: XCTestCase {
    
    class MockWKWebViewBrowserForTestingDidFinish: WKWebViewBrowser {
        
        var didFinish: ((WKWebView) -> Void)?
        override func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            if let didFinish = didFinish {
                didFinish(webView)
            }
        }
    }
    
    func testDidFinish() {
        let expectation = XCTestExpectation(description: "Receive a response")
        expectation.expectedFulfillmentCount = 1
        expectation.assertForOverFulfill = true
        
        let webpageURL = "https://www.apple.com"
        let wkWebViewBrowser: MockWKWebViewBrowserForTestingDidFinish = MockWKWebViewBrowserForTestingDidFinish(with: URL(string: webpageURL)!)
        wkWebViewBrowser.viewDidLoad()
        wkWebViewBrowser.didFinish = { webView in
            expectation.fulfill()
 
            XCTAssert(wkWebViewBrowser.webView.isEqual(webView))
            XCTAssertNotNil(wkWebViewBrowser.webView.url?.absoluteString.contains(webpageURL))
        }
        
        wait(for: [expectation], timeout: 15)
    }

    static var allTests = [
        ("testDidFinish", testDidFinish),
    ]
}
