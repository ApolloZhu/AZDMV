//
//  Quiz.swift
//  AZDMV
//
//  Created by Apollo Zhu on 2/12/18.
//  Copyright © 2016-2020 DMV A-Z. MIT License.
//

import Foundation

public struct Quiz: Codable, Persistent {
    private let rawSection: String
    private let rawSubsection: String
    private let rawQuestionID: String
    public let question: String
    /// Normally use .first
    public let images: [String]
    public let feedback: String
    private let rawCorrectAnswer: String
    private let rawAnswers: [Answer]
    public var answers: [Answer] {
        return rawAnswers.filter { !$0.text.isEmpty }
    }
    public struct Answer: Codable, Equatable {
        /// index, 1-4
        let value: String
        public let text: String
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
    public var section: Int {
        return Int(rawSection)!
    }
    
    public var subsection: Int {
        return Int(rawSubsection)!
    }
    
    public var questionID: Int {
        return Int(rawQuestionID)!
    }

    /// 5->1,6->2,7->all
    private var valueOfCorrectAnswer: Int {
        let correctAnswer = Int(rawCorrectAnswer)!
        switch correctAnswer {
        case 1...4: return correctAnswer
        case 5...6: return correctAnswer - 4
        case 7: return 4
        default: fatalError("New Kind of Correct Answers")
        }
    }

    public var correctAnswer: Answer {
        return answers[valueOfCorrectAnswer - 1]
    }

    /// For performance reason, answer is assumed to be in `answers`.
    public func isCorrectAnswer(_ answer: Answer) -> Bool {
        return Int(answer.value)! == valueOfCorrectAnswer
    }

    public var imageURL: URL? {
        guard let name = images.first else { return nil }
        return URL(string: "https://www.dmv.virginia.gov/dmv-manuals/manuals/images/1/\(name)")
    }
}

public typealias Quizzes = [Quiz]
