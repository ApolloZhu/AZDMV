//
//  Error+Extensions.swift
//  AZDMV
//
//  Created by Apollo Zhu on 9/14/18.
//  Copyright © 2018 DMV A-Z. All rights reserved.
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
