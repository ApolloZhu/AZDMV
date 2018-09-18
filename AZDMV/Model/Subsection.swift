//
//  Subsection.swift
//  AZDMV
//
//  Created by Apollo Zhu on 2/13/18.
//  Copyright © 2016-2018 DMV A-Z. MIT License.
//

import Foundation

struct Subsection: Codable, Hashable {
    let rawSection: String
    let rawSubSectionID: String
    let title: String
    let content: String
    let update: String? // Wed Sep 07 2016 15:07:58 GMT+0000 (Coordinated Universal Time)
    enum CodingKeys: String, CodingKey {
        case rawSection = "section"
        case rawSubSectionID = "subSectionID"
        case title = "subSectionTitle"
        case content = "copy"
        case update
    }
}

extension Subsection {
    var section: Int {
        return Int(rawSection)!
    }
    
    var subSectionID: Int {
        return Int(rawSubSectionID)!
    }

    var name: String {
        return String(
            format: NSLocalizedString(
                "Subsection.name",
                value: "%1$d.%2$d %3$@",
                comment: "Complete section name"),
            section, subSectionID, title
        )
    }
}

typealias Subsections = [OptionalCodable<Subsection>]
