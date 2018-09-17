//
//  SubSectionViewController.swift
//  AZDMV
//
//  Created by Apollo Zhu on 9/15/18.
//  Copyright © 2018 DMV A-Z. All rights reserved.
//

import UIKit
import WebKit

class SubSectionViewController: UIViewController, WKNavigationDelegate {
    var subSection: Subsection!
    private var webView: WKWebView {
        return view as! WKWebView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let subSection = subSection else { return }
        title = String(
            format: NSLocalizedString(
                "SubSection.title",
                value:  "%1$d.%2$d %3$@",
                comment: "Manual section number and title."),
            subSection.section, subSection.subSectionID, subSection.title
        )
        webView.loadHTMLString(subSection.content, baseURL: nil)

        // MARK: - Open Links in Safari

        webView.navigationDelegate = self
    }
    private var loaded = false
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if loaded, let url = navigationAction.request.url {
            decisionHandler(.cancel)
            UIApplication.shared.openURL(url)
        } else {
            loaded = true
            decisionHandler(.allow)
        }
    }
    override func loadView() {
        let configuration = WKWebViewConfiguration()
        if #available(iOS 10.0, *) {
            configuration.dataDetectorTypes = .all
        }
        view = WKWebView(frame: .zero, configuration: configuration)
    }
}
