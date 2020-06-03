//
//  ViewController.swift
//  WKWebViewBrowserExample
//
//  Created by tigi on 2020/06/03.
//  Copyright © 2020 tigi44. All rights reserved.
//

import UIKit
import WKWebViewBrowser

class ViewController: UIViewController {

    let webViewController: UIViewController = WKWebViewBrowser(with: URL(string: "https://www.apple.com")!)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.present(webViewController, animated: true, completion: nil)
    }
}

