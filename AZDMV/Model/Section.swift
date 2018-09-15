//
//  Section.swift
//  AZDMV
//
//  Created by Apollo Zhu on 2/12/18.
//  Copyright © 2016-2018 DMV A-Z. MIT License.
//

import Foundation

struct Section: Codable {
    let symbolID: String
    let title: String
    let rawSectionID: String
    enum CodingKeys: String, CodingKey {
        case symbolID = "symbol"
        case rawSectionID = "sectionID"
        case title = "sectionTitle"
    }
}

extension Section {
    var sectionID: Int {
        return Int(rawSectionID)!
    }

    var symbol: String! {
        switch symbolID {
        case "edit": return "\u{f044}"
        case "signIcon": return "\u{e606}"
        case "steeringWheel": return "\u{e603}"
        case "seatBelt": return "\u{e607}"
        case "exclamation-circle": return "\u{f06a}"
        case "license": return "\u{e611}"
        case "info": return "\u{f129}"
        default: fatalError(symbolID)
        }
    }
}
