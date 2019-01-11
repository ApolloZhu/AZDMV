//
//  Quiz.swift
//  AZDMV
//
//  Created by Apollo Zhu on 2/12/18.
//  Copyright © 2016-2019 DMV A-Z. MIT License.
//

import Foundation

struct Quiz: Codable, Persistent {
    let rawSection: String
    let rawSubsection: String
    let rawQuestionID: String
    let question: String
    /// Normally use .first
    let images: [String]
    let feedback: String
    let rawCorrectAnswer: String
    let rawAnswers: [Answer]
    var answers: [Answer] {
        return rawAnswers.filter { !$0.text.isEmpty }
    }
    struct Answer: Codable, Equatable {
        /// index, 1-4
        let value: String
        let text: String
    }
    /// Tue Sep 06 2016 13:15:00 GMT+0000 (Coordinated Universal Time)
    let update: String?
    let category: Category?
    struct Category: Codable {
        /// SN, SF
        let code: String
        /// Signs, Safety
        let description: String
    }
    enum CodingKeys: String, CodingKey {
        case rawSection = "section"
        case rawSubsection = "subsection"
        case rawQuestionID = "questionID"
        case question, images, feedback
        case rawCorrectAnswer = "correctAnswer"
        case rawAnswers = "answers"
        case update, category
    }
}

extension Quiz {
    var section: Int {
        return Int(rawSection)!
    }
    
    var subsection: Int {
        return Int(rawSubsection)!
    }
    
    var questionID: Int {
        return Int(rawQuestionID)!
    }

    /// 5->1,6->2,7->all
    var correctAnswer: Int {
        let correctAnswer = Int(rawCorrectAnswer)!
        switch correctAnswer {
        case 1...4: return correctAnswer
        case 5...6: return correctAnswer - 4
        case 7: return 4
        default: fatalError("New Kind of Correct Answers")
        }
    }

    /// For performance reason, answer is assumed to be in `answers`.
    func isCorrectAnswer(_ answer: Answer) -> Bool {
        return Int(answer.value)! == correctAnswer
    }

    var imageURL: URL? {
        guard let name = images.first else { return nil }
        return URL(string: "https://dmvstore.blob.core.windows.net/manuals/images/1/\(name)")
    }
}

typealias Quizzes = [Quiz]
