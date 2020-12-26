//
//  Error+Extensions.swift
//  AZDMV
//
//  Created by Apollo Zhu on 9/14/18.
//  Copyright © 2016-2019 DMV A-Z. MIT License.
//

import Foundation

struct AnyError: LocalizedError {
    var errorDescription: String?

    static let errored: Error = AnyError(errorDescription: NSLocalizedString(
        "AnyError.errored",
        value: "Oops, something went wrong",
        comment: "Generic error description"
    ))
}

import StatusAlert

func showAlert(title: String, message: String? = nil) {
    let statusAlert = StatusAlert()
    if #available(iOS 10.0, *) {
        statusAlert.appearance.blurStyle = .prominent
    }
    statusAlert.title = title
    statusAlert.message = message
    statusAlert.showInKeyWindow()
}
