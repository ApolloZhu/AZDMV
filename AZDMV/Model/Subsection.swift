//
//  Subsection.swift
//  AZDMV
//
//  Created by Apollo Zhu on 2/13/18.
//  Copyright © 2016-2018 DMV A-Z. MIT License.
//

import Foundation

struct Subsection: Codable {
    let section: Int
    let subSectionID: Int
    let title: String
    let content: String
    let update: String? // Wed Sep 07 2016 15:07:58 GMT+0000 (Coordinated Universal Time)
    enum CodingKeys: String, CodingKey {
        case section, subSectionID, update
        case title = "subSectionTitle"
        case content = "copy"
    }
}

typealias Subsections = [Subsection?]

extension Array: Fetchable where Element == Subsection? {
    static let localURL = Bundle.main.url(forResource: "sections", withExtension: "json")
    static let updateURL: URL = "https://dmv-node-api-2.azurewebsites.net/api/manual/sections?manualID=1"
}
