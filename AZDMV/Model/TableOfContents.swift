//
//  TableOfContents.swift
//  AZDMV
//
//  Created by Apollo Zhu on 2/13/18.
//  Copyright © 2016-2019 DMV A-Z. MIT License.
//

import Foundation

struct TableOfContents: Codable, Persistent {
    let manuals: [Manual]
    enum CodingKeys: String, CodingKey {
        case manuals = "manualData"
    }
}
