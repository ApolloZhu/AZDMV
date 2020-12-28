//
//  Conformance.swift
//  AZDMV
//
//  Created by Apollo Zhu on 9/15/18.
//  Copyright © 2016-2020 DMV A-Z. MIT License.
//

import Foundation

/// Swift generics can do better
extension Array: Fetchable where Element: Codable {
    static var localURL: URL? {
        switch Element.self {
        case is OptionalCodable<Subsection>.Type:
            return Bundle.main.url(forResource: "sections", withExtension: "json")
        case is Quiz.Type:
            return Bundle.main.url(forResource: "quiz", withExtension: "json")
        default: fatalError("\(Element.self) is not fetchable")
        }
    }

    static var updateURL: URL {
        switch Element.self {
        case is OptionalCodable<Subsection>.Type:
            return "https://www.dmv.virginia.gov/dmvapimanuals/api/manual/sections?manualID=1"
        case is Quiz.Type:
            return "https://www.dmv.virginia.gov/dmvapimanuals/api/manual/quiz?manualID=1"
        default: fatalError("\(Element.self) is not fetchable")
        }
    }
}

extension TableOfContents: Fetchable {
    static let localURL = Bundle.main.url(forResource: "tboc", withExtension: "json")
    static let updateURL: URL = "https://www.dmv.virginia.gov/dmvapimanuals/api/manual/tboc?manualID=1"
}

func fetchAllSubsections(from source: Source, in manual: Manual? = nil) -> [[Subsection]]? {
    guard let subsections = Subsections.fetch(from: source)
        , let manual = manual ?? TableOfContents.fetch(from: source)?.manuals.first
        else { return nil }
    var sorted = [[Subsection]](repeating: [], count: manual.totalSections)
    subsections.compactMap({ $0.some }).forEach { sorted[$0.section-1].append($0) }
    return sorted.map { $0.sorted { $0.subSectionID < $1.subSectionID } }
}
