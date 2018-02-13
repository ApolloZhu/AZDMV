//
//  Quiz.swift
//  AZDMV
//
//  Created by Apollo Zhu on 2/12/18.
//  Copyright © 2016-2018 DMV A-Z. MIT License.
//

import Foundation

struct Quiz: Codable, Persistent { }

extension Quiz: Fetchable {
    static let localURL = Bundle.main.url(forResource: "quiz", withExtension: "json")
    static let updateURL: URL = "https://dmv-node-api-2.azurewebsites.net/api/manual/quiz?manualID=1"
}

extension URL {
    static func forImage(named name: String) -> URL! {
        return URL(string: "https://dmvstore.blob.core.windows.net/manuals/images/1/\(name)")
    }
}
