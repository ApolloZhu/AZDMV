//
//  Extension.swift
//  DMV
//
//  Created by Apollo Zhu on 12/21/16.
//  Copyright © 2016 WWITDC. All rights reserved.
//

import UIKit
import TTGSnackbar

extension UIStoryboardSegue {
    var terminus: UIViewController {
        return (destination as? UINavigationController)?.visibleViewController ?? destination
    }
}

extension URL {
    init?(dmvImageName name: String?) {
        if let imageName = name, !imageName.isEmpty {
            self.init(string: "https://dmvstore.blob.core.windows.net/manuals/images/1/\(imageName)")
        } else {
            return nil
        }
    }
}

extension UIControlState {
    public static var all: UIControlState {
        return UIControlState()
    }
}

let dmvLogo = UIImage(named: "dmvLogo.png")

public protocol TTGSnackbarPresenter: class {
    var snackBar: TTGSnackbar { get set }
}

extension TTGSnackbarPresenter {
    public func showSnackBar(message: String?, in view: UIView? = nil) {
        let duration = snackBar.animationDuration
        snackBar.animationDuration = 0
        snackBar.dismiss()
        snackBar = TTGSnackbar(message: message ?? Identifier.Nothing, duration: .long)
        snackBar.animationType = .slideFromTopBackToTop
        snackBar.animationDuration = duration
        snackBar.contentInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        if let view = view {
            snackBar.containerView = view
        }
        snackBar.show()
    }
}
