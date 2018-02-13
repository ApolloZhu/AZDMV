//
//  Quiz.swift
//  AZDMV
//
//  Created by Apollo Zhu on 2/12/18.
//  Copyright © 2016-2018 DMV A-Z. MIT License.
//

import Foundation

struct Quiz: Codable, Persistent {
    let section: Int
    let subsection: Int
    let questionID: Int
    let question: String
    let images: [String] // .first
    let feedback: String
    let correctAnswer: Int // 5->1,6->2,7->all
    let answers: [Answer]
    struct Answer: Codable {
        let value: Int // index, 1-4
        let text: String
    }
    let update: String? // Tue Sep 06 2016 13:15:00 GMT+0000 (Coordinated Universal Time)
    let category: Category?
    struct Category: Codable {
        let code: String // SN, SF
        let description: String // Signs, Safety
    }
}

extension Quiz {
    var imageURL: URL? {
        guard let name = images.first else { return nil }
        return URL(string: "https://dmvstore.blob.core.windows.net/manuals/images/1/\(name)")
    }
}

typealias Quizzes = [Quiz]

extension Array/*: Fetchable*/ where Element == Quiz {
    static let localURL = Bundle.main.url(forResource: "quiz", withExtension: "json")
    static let updateURL: URL = "https://dmv-node-api-2.azurewebsites.net/api/manual/quiz?manualID=1"
}
