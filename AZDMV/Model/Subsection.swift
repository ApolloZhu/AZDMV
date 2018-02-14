//
//  Subsection.swift
//  AZDMV
//
//  Created by Apollo Zhu on 2/13/18.
//  Copyright © 2016-2018 DMV A-Z. MIT License.
//

import Foundation

struct Subsection: Codable {
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
}

typealias Subsections = [OptionalCodable<Subsection>]

extension Array: Fetchable where Element == OptionalCodable<Subsection> {
    static let localURL = Bundle.main.url(forResource: "sections", withExtension: "json")
    static let updateURL: URL = "https://dmv-node-api-2.azurewebsites.net/api/manual/sections?manualID=1"
}

func fetchAllSubsections(from source: Source, in manual: Manual? = nil) -> [[Subsection]]? {
    guard let subsections = Subsections.fetch(from: source)
        , let manual = manual ?? TableOfContents.fetch(from: source)?.manuals.first
        else { return nil }
    var sorted = [[Subsection]](repeating: [], count: manual.totalSections)
    subsections.compactMap({ $0.some }).forEach { sorted[$0.section-1].append($0) }
    return sorted.map { $0.sorted { $0.subSectionID < $1.subSectionID } }
}

