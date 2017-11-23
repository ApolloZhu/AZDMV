//
//  Quiz.swift
//  DMV
//
//  Created by Apollo Zhu on 12/21/16.
//  Copyright © 2016 WWITDC. All rights reserved.
//

import SwiftyJSON

open class QuizSet {
    public static let shared = QuizSet()
    private init(){}

    private lazy var _quizzes: JSON = {
        return JSON(data: try! Data(contentsOf: Bundle.main.url(forResource: "quiz", withExtension: "json")!))
    }()

    public func allQuizIDsIn(section: Int, subSection: Int) -> [Int] {
        var ids = [Int]()
        for (_, question) in _quizzes.lazy {
            if question["section"].intValue == section && question["subsection"].intValue == subSection {
                ids.append(question["questionID"].intValue)
            }
        }
        return ids
    }

    public func quizQuestion(withID id: Int) -> String? {
        if let question = quizJSON(withID: id) {
            return question["question"].stringValue
        }
        return nil
    }

    public func quiz(withID id: Int) -> Quiz? {
        if let quiz = quizJSON(withID: id) {
            let answers =
                quiz["answers"]
                    .map {
                        $0.1["text"]
                            .stringValue
                            .trimmingCharacters(in: .whitespaces)
                    }.filter { !$0.isEmpty }

            return Quiz(
                question: quiz["question"].stringValue,
                imageURL: quiz["images"][0].stringValue,
                reason: quiz["feedback"].stringValue,
                correctAnswerID: quiz["correctAnswer"].intValue,
                answers: answers
            )
        }
        return nil

    }

    private func quizJSON(withID id: Int) -> JSON? {
        for (_, question) in _quizzes.lazy {
            if question["questionID"].intValue == id {
                return question
            }
        }
        return nil
    }
}

extension QuizSet {
    public struct Quiz {
        public let question: String
        public let imageURL: String?
        public let reason: String
        public let correctAnswerID: Int
        public let answers: [String]
    }
}
