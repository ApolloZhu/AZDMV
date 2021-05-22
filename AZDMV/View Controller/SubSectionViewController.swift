//
//  SubSectionViewController.swift
//  AZDMV
//
//  Created by Apollo Zhu on 9/15/18.
//  Copyright © 2016-2020 DMV A-Z. MIT License.
//

import UIKit
import WebKit
import AZDMVShared

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
                value:  "Section %1$d.%2$d",
                comment: "Manual section number, including subsection."),
            subSection.section, subSection.subSectionID
        )
        let css = """
        :root {
            color-scheme: light dark;
        }

        body {
            padding: 10pt;
        }
        img {
            width: 100%;
            height: auto !important;
        }
        table {
            width: 100% !important;
        }

        a {
            color: #006666;
        }
        @media (prefers-color-scheme: dark) {
            a {
                color: #66ccff;
            }
        }
        """
        let content = subSection.content.dropFirst(10) // drop <h2>x.x
        let firstH2Slash = content.firstIndex(of: "/")!
        let h2EndStart = content.index(before: firstH2Slash)
        let firstTitle = content[..<h2EndStart]
        // skip /h2>
        let mainStart = content.index(firstH2Slash, offsetBy: 4)
        let main = content[mainStart...]
            .replacingOccurrences(of: "src=\"",
                                  with: "src=\"https://www.dmv.virginia.gov")

        let html = """
        <!DOCTYPE html>
        <html>
        <head>
            <meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no'>
            <style>
                \(css)
            </style>
        </head>
        <body id="body">
            <h1>\(subSection.title)</h1>
            <hr role="presentation">
            \(firstTitle == subSection.title ? "" : "<h2>\(firstTitle)</h2>")
            \(main)
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
            UIApplication.shared.open(url)
        } else {
            loaded = true
            decisionHandler(.allow)
        }
    }
    
    override func loadView() {
        let configuration = WKWebViewConfiguration()
        configuration.dataDetectorTypes = .all
        view = WKWebView(frame: .zero, configuration: configuration)
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        if #available(iOS 13.0, *) {
            // Prevents initial white flash when loading web view
            // https://forums.developer.apple.com/thread/121139
            webView.isOpaque = false
            webView.backgroundColor = UIColor.systemBackground
        }
    }
}
