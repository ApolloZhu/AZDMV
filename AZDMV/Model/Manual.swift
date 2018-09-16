//
//  Manual.swift
//  AZDMV
//
//  Created by Apollo Zhu on 2/12/18.
//  Copyright © 2016-2018 DMV A-Z. MIT License.
//

import Foundation

struct Manual: Codable {
    // let manualID: String
    let title: String
    let symbol: String
    let rawTotalSections: String
    let rawSections: [Section]
    let noQuiz: [String] // x.x
    
    enum CodingKeys: String, CodingKey {
        case title, symbol
        case rawTotalSections = "totalSections"
        case rawSections = "sections"
        case noQuiz
    }
}

extension Manual {
    var totalSections: Int {
        return Int(rawTotalSections)! + 1
    }

    var sections: ArraySlice<Section> {
        return rawSections.dropLast()
    }
}

