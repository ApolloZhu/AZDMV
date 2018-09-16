//
//  SubSectionViewController.swift
//  AZDMV
//
//  Created by Apollo Zhu on 9/15/18.
//  Copyright © 2018 DMV A-Z. All rights reserved.
//

import UIKit

class SubSectionViewController: UIViewController {
    var subSection: Subsection!
    @IBOutlet weak var textView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        guard let subSection = subSection else { return }
        title = "\(subSection.section).\(subSection.subSectionID) \(subSection.title)"
        textView.isScrollEnabled = false
        textView.attributedText = try? NSAttributedString(
            data: subSection.content.data(using: .utf8)!,
            options: [.documentType: NSAttributedString.DocumentType.html],
            documentAttributes: nil
        )
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        textView.isScrollEnabled = true
    }
}
