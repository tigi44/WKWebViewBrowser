//
//  BasedWKWebViewController.swift
//  WKWebViewBrowser
//
//  Created by tigi on 2020/05/28.
//

import WebKit

internal struct WKProcessPoolHandler {
    static let shared = WKProcessPoolHandler()
    let pool: WKProcessPool = WKProcessPool()
    private init() {}
}

internal protocol BasedWKWebView {
    var webView: WKWebView { get }
    func loadWKWebView(with url: URL)
    init(with url: URL)
}

extension BasedWKWebView {
    func loadWKWebView(with url: URL) {
        let request: URLRequest = URLRequest(url: url)
        webView.load(request)
    }
}

open class BasedWKWebViewController: UIViewController, BasedWKWebView {

    lazy var webView: WKWebView = {
        let webConfiguration = WKWebViewConfiguration()
        webConfiguration.processPool = WKProcessPoolHandler.shared.pool

        let webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        webView.navigationDelegate = self
        webView.translatesAutoresizingMaskIntoConstraints = false

        return webView
    }()
    
    public required init(with url: URL) {
        super.init(nibName: nil, bundle: nil)
        
        setupUI()
        loadWKWebView(with: url)
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension BasedWKWebViewController {
    
    private func setupUI() {

        view.addSubview(webView)
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.topAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            webView.rightAnchor.constraint(equalTo: view.rightAnchor),
        ])
    }
}

extension BasedWKWebViewController: WKUIDelegate {
    public func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        let alert       = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let otherAction = UIAlertAction(title: "OK", style: .default, handler: {action in completionHandler()})
        alert.addAction(otherAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    public func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Swift.Void){
        let alert        = UIAlertController(title: "", message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "CANCEL", style: .cancel, handler: {(action) in completionHandler(false)})
        let okAction     = UIAlertAction(title: "OK", style: .default, handler: {(action) in completionHandler(true)})
        alert.addAction(cancelAction)
        alert.addAction(okAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    public func webView(_ webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (String?) -> Void) {
        let alert        = UIAlertController(title: "", message: prompt, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "CANCEL", style: .cancel, handler: {(action) in completionHandler(nil)})
        let okAction     = UIAlertAction(title: "OK", style: .default, handler: {(action) in completionHandler(alert.textFields?.first?.text)})
        alert.addAction(cancelAction)
        alert.addAction(okAction)
        alert.addTextField { (textField) in
            textField.text = defaultText
        }
        
        self.present(alert, animated: true, completion: nil)
    }
}

extension BasedWKWebViewController: WKNavigationDelegate {
    public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let url: URL = navigationAction.request.url {
            print("BasedWKWebViewController URL : \(url)")
        }
        
        decisionHandler(.allow)
    }
    
    public func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        
    }
    public func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        
    }
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
    }
    public func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        
    }
}

 
