//
//  Error+Extensions.swift
//  AZDMV
//
//  Created by Apollo Zhu on 9/14/18.
//  Copyright © 2016-2019 DMV A-Z. MIT License.
//

import Foundation

struct AnyError: Error {
    var localizedDescription: String
    static let errored: Error = AnyError(localizedDescription: NSLocalizedString(
        "AnyError.errored",
        value: "Oops, something went wrong",
        comment: "Generic error description"
    ))
}
