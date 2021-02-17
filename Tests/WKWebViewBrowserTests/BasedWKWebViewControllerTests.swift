import XCTest
import WebKit
@testable import WKWebViewBrowser

final class BasedWKWebViewControllerTests: XCTestCase {
    
    class MockBasedWKWebViewController: BasedWKWebViewController {
        
        var didSetTitle: ((String?) -> Void)?
        
        override var title: String? {
            didSet {
                if let didSetTitle = didSetTitle {
                    didSetTitle(self.title)
                }
            }
        }
    }
    
    let testWebpageURL: URL = URL(string: "https://www.apple.com/")!
    let testRequest: URLRequest    = URLRequest(url: URL(string: "https://www.apple.com/")!)
    let testConfiguration: WKWebViewConfiguration = WKWebViewConfiguration()
    var requestBasedWKWebViewController: BasedWKWebViewController!
    var urlBasedWKWebViewController: BasedWKWebViewController!
    
    override func setUpWithError() throws {
        requestBasedWKWebViewController = BasedWKWebViewController(with: testRequest, configuration: testConfiguration)
        urlBasedWKWebViewController     = BasedWKWebViewController(with: testWebpageURL)
    }
    
    func testRequestBasedWKWebView() {
        XCTAssertNotNil(requestBasedWKWebViewController.webView)
        XCTAssertEqual(requestBasedWKWebViewController.request, testRequest)
        XCTAssertEqual(requestBasedWKWebViewController.configuration, testConfiguration)
        
        requestBasedWKWebViewController.loadRequest(with: testRequest)
        XCTAssertEqual(requestBasedWKWebViewController.webView.url, testRequest.url)
    }
    
    func testURLBasedWKWebView() {
        XCTAssertEqual(urlBasedWKWebViewController.request.url, testWebpageURL)
        XCTAssertNotNil(urlBasedWKWebViewController.configuration)
    }
    
    func testSetDocumentTitle() {
        let expectation = XCTestExpectation(description: "Receive a response")
        expectation.expectedFulfillmentCount = 1
        expectation.assertForOverFulfill = true
        
        let wkWebViewController: MockBasedWKWebViewController = MockBasedWKWebViewController(with: testRequest)
        wkWebViewController.viewDidLoad()
        wkWebViewController.didSetTitle = { title in
            expectation.fulfill()
 
            XCTAssertNotNil(title)
        }
        
        wait(for: [expectation], timeout: 15)
    }

    static var allTests = [
        ("testRequestBasedWKWebView", testRequestBasedWKWebView),
        ("testURLBasedWKWebView", testURLBasedWKWebView),
        ("testSetDocumentTitle", testSetDocumentTitle),
    ]
}
