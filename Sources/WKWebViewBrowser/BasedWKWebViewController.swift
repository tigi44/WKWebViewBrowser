//
//  BasedWKWebViewController.swift
//  WKWebViewBrowser
//
//  Created by tigi on 2020/05/28.
//

import WebKit


// MARK: - WKProcessPoolHandler


internal struct WKProcessPoolHandler {
    static let shared = WKProcessPoolHandler()
    let pool: WKProcessPool = WKProcessPool()
    private init() {}
}


// MARK: - BasedWKWebView


public protocol BasedWKWebView {
    var webView: WKWebView { get }
    var request: URLRequest { get }
    var configuration: WKWebViewConfiguration { get }
    
    init(with url: URL, configuration: WKWebViewConfiguration?)
    init(with request: URLRequest, configuration: WKWebViewConfiguration?)
    
    func loadRequest(with request: URLRequest)
}

extension BasedWKWebView {
    public func loadRequest(with request: URLRequest) {
        webView.load(request)
    }
}


// MARK: - BasedWKWebViewController


open class BasedWKWebViewController: UIViewController, BasedWKWebView {
    public private(set) lazy var webView: WKWebView = {
        let webView = WKWebView(frame: .zero, configuration: configuration)
        webView.backgroundColor = .white
        webView.allowsBackForwardNavigationGestures = true
        webView.uiDelegate = self
        webView.navigationDelegate = self
        webView.translatesAutoresizingMaskIntoConstraints = false

        return webView
    }()
    public private(set) var request: URLRequest
    public private(set) lazy var configuration: WKWebViewConfiguration = {
        if let config = self._configuration {
            return config
        } else {
            let config = WKWebViewConfiguration()
            config.processPool = WKProcessPoolHandler.shared.pool
            return config
        }
    }()

    private var _configuration: WKWebViewConfiguration?
    
    
    public required init(with url: URL, configuration: WKWebViewConfiguration? = nil) {
        self.request = URLRequest(url: url)
        self._configuration = configuration
        
        super.init(nibName: nil, bundle: nil)
    }
    
    public required init(with request: URLRequest, configuration: WKWebViewConfiguration? = nil) {
        self.request = request
        self._configuration = configuration
        
        super.init(nibName: nil, bundle: nil)
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        loadRequest(with: request)
    }
}

private extension BasedWKWebViewController {
    func setupUI() {
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
            PrintDebugLog("BasedWKWebViewController URL : \(url)")
        }
        
        decisionHandler(.allow)
    }
    
    public func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
    }
    public func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        PrintDebugLog("didFailProvisionalNavigation error : \(error.localizedDescription)")
    }
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        setupTitleByWebViewDocument()
    }
    public func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        PrintDebugLog("didFail error : \(error.localizedDescription)")
    }
    
    
    // MARK: private
    

    private func setupTitleByWebViewDocument() {
        webView.evaluateJavaScript("document.title") { [weak self] (result, error) in
            if let error = error {
                PrintDebugLog("didFinish evaluateJavaScript(document.title) error : \(error.localizedDescription)")
            }
            
            if let result = result as? String {
                PrintDebugLog("didFinish setTitle : \(result)")
                self?.title = result
            }
        }
    }
}
