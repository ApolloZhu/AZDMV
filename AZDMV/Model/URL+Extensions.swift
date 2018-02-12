//
//  URL+Extensions.swift
//  AZDMV
//
//  Created by Apollo Zhu on 2/11/18.
//  Copyright © 2016-2018 DMV A-Z. MIT License.
//

import Foundation

extension URL {
    static let quizzes: URL = "https://dmv-node-api-2.azurewebsites.net/api/manual/quiz?manualID=1"
    static let sections: URL = "https://dmv-node-api-2.azurewebsites.net/api/manual/sections?manualID=1"
    static let tableOfContents: URL = "https://dmv-node-api-2.azurewebsites.net/api/manual/tboc?manualID=1"
    static func forImage(named name: String) -> URL! {
        return URL(string: "https://dmvstore.blob.core.windows.net/manuals/images/1/\(name)")
    }
}

extension URL: ExpressibleByStringLiteral {
    public init(stringLiteral value: StringLiteralType) {
        self.init(string: value)!
    }
}
