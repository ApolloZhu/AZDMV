//
//  ErrorPresenter.swift
//  DMV
//
//  Created by Apollo Zhu on 6/10/17.
//  Copyright © 2017 WWITDC. All rights reserved.
//

import UIKit

#if os(iOS)
    import TTGSnackbar
#endif

class ErrorPresenter {

    public static let shared = ErrorPresenter()

    #if os(iOS)
    private var snackBar = TTGSnackbar()

    private func showSnackBar(message: String, in view: UIView?) {
        let duration = snackBar.animationDuration
        snackBar.animationDuration = 0
        snackBar.dismiss()
        snackBar = TTGSnackbar(message: message, duration: .long)
        snackBar.animationType = .slideFromTopBackToTop
        snackBar.animationDuration = duration
        snackBar.contentInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        if let view = view {
            snackBar.containerView = view
        }
        snackBar.show()
    }
    #endif

    public func presentError(message: String?, in view: UIView? = nil) {
        let message = message ?? .placeholder
        #if os(iOS)
            showSnackBar(message: message, in: view)
        #else
            print(message)
        #endif
    }

    public func dismiss() {
        #if os(iOS)
            snackBar.dismiss()
        #else
            print("dismiss")
        #endif
    }
}
