//
//  TableOfContents.swift
//  AZDMV
//
//  Created by Apollo Zhu on 2/13/18.
//  Copyright © 2016-2018 DMV A-Z. MIT License.
//

import Foundation

struct TableOfContents: Codable, Persistent { }

extension TableOfContents: Fetchable {
    static let localURL = Bundle.main.url(forResource: "tboc", withExtension: "json")
    static let updateURL: URL = "https://dmv-node-api-2.azurewebsites.net/api/manual/tboc?manualID=1"
}
