//
//  Extension.swift
//  DMV
//
//  Created by Apollo Zhu on 12/21/16.
//  Copyright © 2016 WWITDC. All rights reserved.
//

import UIKit

// MARK: Convenient Global Variables
let quizSet = QuizSet.shared
let manual = Manual.shared

extension UIImage {
    static let dmvLogo = UIImage(named: "dmvLogo.png")
}

// MARK: Extensions
extension UIStoryboardSegue {
    var terminus: UIViewController {
        return (destination as? UINavigationController)?.visibleViewController ?? destination
    }
}

extension URL {
    init?(dmvImageName name: String?) {
        guard let imageName = name, !imageName.isEmpty else { return nil }
        self.init(string: "https://dmvstore.blob.core.windows.net/manuals/images/1/\(imageName)")
    }
}

extension UIColor {
    static let positive = UIColor(red: 0, green: 0.5, blue: 0.5, alpha: 1)
    static let negative = UIColor(red: 0.4, green: 0, blue: 0, alpha: 1)
}

extension CGSize {
    var area: CGFloat {
        return width * height
    }
    func adding(insects: UIEdgeInsets) -> CGSize {
        return CGSize(width: width + insects.left + insects.right,
                      height: height + insects.top + insects.bottom)
    }
}

extension UILabel {
    func fit(in view: UIView) {
        guard let text = text as NSString? else { return }
        let area = text.size(withAttributes: [.font: font])
            .adding(insects: UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4))
            .area
        let ratio = sqrt(view.bounds.size.area / area)
        if ratio < 1 {
            font = font.withSize(font.pointSize * ratio)
        }
    }
}

extension String {
    static let placeholder = "╮(￣▽￣)╭"
}
