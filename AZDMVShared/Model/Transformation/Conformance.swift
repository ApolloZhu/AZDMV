//
//  Conformance.swift
//  AZDMV
//
//  Created by Apollo Zhu on 9/15/18.
//  Copyright © 2016-2020 DMV A-Z. MIT License.
//

import Foundation

extension Bundle {
    static let current = Bundle(identifier: "io.github.apollozhu.AZDMVShared")!
}

/// Swift generics can do better
extension Array: Fetchable where Element: Codable {
    public static var localURL: URL? {
        switch Element.self {
        case is OptionalCodable<Subsection>.Type:
            return Bundle.current.url(forResource: "sections", withExtension: "json")
        case is Quiz.Type:
            return Bundle.current.url(forResource: "quiz", withExtension: "json")
        default: fatalError("\(Element.self) is not fetchable")
        }
    }

    public static var updateURL: URL {
        switch Element.self {
        case is OptionalCodable<Subsection>.Type:
            return URL(string:  "https://www.dmv.virginia.gov/dmvapimanuals/api/manual/sections?manualID=1")!
        case is Quiz.Type:
            return URL(string: "https://www.dmv.virginia.gov/dmvapimanuals/api/manual/quiz?manualID=1")!
        default: fatalError("\(Element.self) is not fetchable")
        }
    }
}

extension TableOfContents: Fetchable {
    public static let localURL = Bundle.current.url(forResource: "tboc", withExtension: "json")
    public static let updateURL: URL = URL(string: "https://www.dmv.virginia.gov/dmvapimanuals/api/manual/tboc?manualID=1")!
}

public func fetchAllSubsections(from source: Source, in manual: Manual? = nil) -> [[Subsection]]? {
    guard let subsections = Subsections.fetch(from: source)
        , let manual = manual ?? TableOfContents.fetch(from: source)?.manuals.first
        else { return nil }
    var sorted = [[Subsection]](repeating: [], count: manual.totalSections)
    subsections.compactMap({ $0.some }).forEach { sorted[$0.section-1].append($0) }
    return sorted.map { $0.sorted { $0.subSectionID < $1.subSectionID } }
}
