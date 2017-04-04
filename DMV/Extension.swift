//
//  Extension.swift
//  DMV
//
//  Created by Apollo Zhu on 12/21/16.
//  Copyright © 2016 WWITDC. All rights reserved.
//

import UIKit
import TTGSnackbar

// MARK: Convenient Global Variables
let dmvLogo = UIImage(named: "dmvLogo.png")
let quizSet = QuizSet.shared
let manual = Manual.shared

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

extension UIFont {
    static let system = UIFont.systemFont(ofSize: systemFontSize)
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
        return CGSize(width: width + insects.left + insects.right, height: height + insects.top + insects.bottom)
    }
}

extension UILabel {
    func fit(in view: UIView) {
        guard let text = text else { return }
        let area = (text as NSString)
            .size(attributes: [NSFontAttributeName: font])
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

public protocol TTGSnackbarPresenter: class {
    var snackBar: TTGSnackbar { get set }
}

extension TTGSnackbarPresenter {
    public func showSnackBar(message: String?, in view: UIView? = nil) {
        let duration = snackBar.animationDuration
        snackBar.animationDuration = 0
        snackBar.dismiss()
        snackBar = TTGSnackbar(message: message ?? .placeholder, duration: .long)
        snackBar.animationType = .slideFromTopBackToTop
        snackBar.animationDuration = duration
        snackBar.contentInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        if let view = view {
            snackBar.containerView = view
        }
        snackBar.show()
    }
}
