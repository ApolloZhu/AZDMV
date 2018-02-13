//
//  Manual.swift
//  AZDMV
//
//  Created by Apollo Zhu on 2/12/18.
//  Copyright © 2016-2018 DMV A-Z. MIT License.
//

import Foundation

struct Manual: Codable {
    let manualID: Int
    let title: String
    let symbol: String
    let totalSections: Int
    let sections: [Section]
    let noQuiz: [String] // x.x
}
