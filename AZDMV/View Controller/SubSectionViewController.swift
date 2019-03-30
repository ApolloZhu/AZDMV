//
//  SubSectionViewController.swift
//  AZDMV
//
//  Created by Apollo Zhu on 9/15/18.
//  Copyright © 2016-2019 DMV A-Z. MIT License.
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
        let html = """
        <!DOCTYPE html>
        <html>
        <head>
            <style>
                body {
                    padding: 10pt;
                }
                img {
                    width: 100%;
                    height: auto !important;
                }
            </style>
        </head>
        <body id="body">
            \(subSection.content)
        </body>
        </html>
        """
        webView.loadHTMLString(html, baseURL: nil)

        // MARK: - Open Links in Safari

        webView.navigationDelegate = self
    }

    private var loaded = false
    func webView(_ webView: WKWebView,
                 decidePolicyFor navigationAction: WKNavigationAction,
                 decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
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

        // MARK: - Dynamic Type

        let controller = WKUserContentController()

        controller.addUserScript(WKUserScript(source: js, injectionTime: .atDocumentEnd, forMainFrameOnly: true))
        configuration.userContentController = controller
        view = WKWebView(frame: .zero, configuration: configuration)
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        var token: NSObjectProtocol!
        token = NotificationCenter.default.addObserver(
            forName: UIContentSizeCategory.didChangeNotification,
            object: nil, queue: nil
        ) { [weak self] _ in
            guard let self = self else {
                return NotificationCenter.default.removeObserver(token!)
            }
            self.webView.evaluateJavaScript(self.js) { [weak self] (_, error) in
                if let error = error {
                    showAlert(title: error.localizedDescription)
                } else {
                    self?.webView.reload()
                }
            }
        }
    }
    var js: String {
        return """
        HTMLCollection.prototype.forEach = Array.prototype.forEach;
        document.getElementById("body").style.fontSize = "\(pointSize(ofTextStyle: .body))px";
        document.getElementsByTagName("h2").forEach(h2 => {
            h2.style.fontSize = "\(pointSize(ofTextStyle: .title2))px";
        });
        document.getElementsByTagName("h3").forEach(h3 => {
            h3.style.fontSize = "\(pointSize(ofTextStyle: .title3))px";
        });
        """
    }
    private func pointSize(ofTextStyle style: UIFont.TextStyle) -> CGFloat {
        return UIFont.preferredFont(forTextStyle: style).pointSize * UIScreen.main.scale
    }
}
