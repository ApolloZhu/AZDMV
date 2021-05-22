//
//  Subsection.swift
//  AZDMV
//
//  Created by Apollo Zhu on 2/13/18.
//  Copyright © 2016-2020 DMV A-Z. MIT License.
//

import Foundation

public struct Subsection: Codable, Hashable {
    private let rawSection: String
    private let rawSubSectionID: String
    public let title: String
    public let content: String
    /// Wed Sep 07 2016 15:07:58 GMT+0000 (Coordinated Universal Time)
    let update: String?
    enum CodingKeys: String, CodingKey {
        case rawSection = "section"
        case rawSubSectionID = "subSectionID"
        case title = "subSectionTitle"
        case content = "copy"
        case update
    }
}

extension Subsection {
    public var section: Int {
        return Int(rawSection)!
    }
    
    public var subSectionID: Int {
        return Int(rawSubSectionID)!
    }

    public var name: String {
        return String(
            format: NSLocalizedString(
                "Subsection.name",
                value: "%1$d.%2$d %3$@",
                comment: "Complete section name"),
            section, subSectionID, title
        )
    }
}

public typealias Subsections = [OptionalCodable<Subsection>]
