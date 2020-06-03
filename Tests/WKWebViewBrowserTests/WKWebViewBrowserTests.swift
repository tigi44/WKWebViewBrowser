import XCTest
@testable import WKWebViewBrowser
@testable import WebKit

final class WKWebViewBrowserTests: XCTestCase {
    
    class WKWebViewBrowserTestDidFinish: WKWebViewBrowser {
        
        var didFinish: ((WKWebView) -> Void)?
        override func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            if let didFinish = didFinish {
                didFinish(webView)
            }
        }
    }
    
    func testURLOnWkWebViewBrowser() {
        let expectation = XCTestExpectation(description: "Receive a response")
        expectation.expectedFulfillmentCount = 1
        expectation.assertForOverFulfill = true
        let webpageURL = "https://www.apple.com"
        let wkWebViewBrowser: WKWebViewBrowserTestDidFinish = WKWebViewBrowserTestDidFinish(with: URL(string: webpageURL)!)
        wkWebViewBrowser.didFinish = { webView in
            expectation.fulfill()
 
            XCTAssert(wkWebViewBrowser.webView.isEqual(webView))
            XCTAssertNotNil(wkWebViewBrowser.webView.url?.absoluteString.contains(webpageURL))
        }
        
        wait(for: [expectation], timeout: 10)
    }

    static var allTests = [
        ("testURLOnWkWebViewBrowser", testURLOnWkWebViewBrowser),
    ]
}
