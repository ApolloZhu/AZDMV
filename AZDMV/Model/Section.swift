//
//  Section.swift
//  AZDMV
//
//  Created by Apollo Zhu on 2/12/18.
//  Copyright © 2016-2018 DMV A-Z. MIT License.
//

import Foundation

struct Section: Codable {
    let symbol: String
    let title: String
    let sectionID: String
    enum CodingKeys: String, CodingKey {
        case symbol, sectionID
        case title = "sectionTitle"
    }
}
