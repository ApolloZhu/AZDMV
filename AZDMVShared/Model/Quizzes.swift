//
//  Quizzes.swift
//  AZDMVShared
//
//  Created by Apollo Zhu on 5/22/21.
//  Copyright © 2021 DMV A-Z. All rights reserved.
//

public let manual = TableOfContents.fetch(from: .bundled)?.manuals.first
public let subsections = fetchAllSubsections(from: .bundled, in: manual) ?? []
public let quizzes = Quizzes.fetch(from: .bundled)!
extension Quiz {
    var subSection: Subsection {
        return subsections[section - 1][subsection - 1]
    }
}
public let mapped = [Subsection: [Quiz]](grouping: quizzes) { $0.subSection }
    .mapValues { $0.sorted(by: { $0.questionID < $1.questionID }) }
public let flattened = Array(subsections.lazy.flatMap { $0 }.filter { mapped.keys.contains($0) })
