//
//  ManualJSON.swift
//  AZDMV-iOS
//
//  Created by Apollo Zhu on 11/23/17.
//  Copyright © 2017 WWITDC. All rights reserved.
//

import Foundation

struct SubSectionJSON: Codable {
    // let _id: String
    // let __v: Int
    // let id: String
    public let title: String
    public let content: String
    public let sectionID: Int
    public let subSectionID: Int
    public let updateTime: String

    enum CodingKeys: String, CodingKey {
        case title = "subSectionTitle"
        case content = "copy"
        case sectionID = "section"
        case subSectionID = "subSectionID"
        case updateTime = "update"
    }
    // let sections: [String]
    // let noQuiz: [String]
    // let manual: ManualInfoJSON
}

//struct ManualInfoJSON: Codable {
//    let code: Int
//    let description: String
//}

struct ManualSummaryJSON: Codable {
    let totalSections: Int
    let title: String
    let symbol: String
    let sections: [SectionInfoJSON]
    let noQuiz: [String] // Double
    let manualID: Int
}

struct SectionInfoJSON: Codable {
    let symbol: String
    let sectionTitle: String
    let sectionID: String // Usually int
}

struct ManualJSON: Codable {
    // let _id: String
    // let id: String
    let manualData: [ManualSummaryJSON]
    // let tbocID: Int
    // let sections: [String]
    // let noQuiz: [String]
    // let manual: ManualInfoJSON
}
