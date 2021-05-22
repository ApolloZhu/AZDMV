//
//  Manual.swift
//  AZDMV
//
//  Created by Apollo Zhu on 2/12/18.
//  Copyright © 2016-2020 DMV A-Z. MIT License.
//

import Foundation

public struct Manual: Codable {
    // let manualID: String
    public let title: String
    public let symbol: String
    private let rawTotalSections: String
    private let rawSections: [Section]
    /// x.x
    public let noQuiz: [String]
    
    enum CodingKeys: String, CodingKey {
        case title, symbol
        case rawTotalSections = "totalSections"
        case rawSections = "sections"
        case noQuiz
    }
}

extension Manual {
    public var totalSections: Int {
        return Int(rawTotalSections)! + 1
    }

    public var sections: ArraySlice<Section> {
        return rawSections.dropLast()
    }
}

