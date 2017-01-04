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
    private var _quizzes: JSON

    private init(){
        _quizzes = JSON(data: try! Data(contentsOf: Bundle.main.url(forResource: "quiz", withExtension: "json")!))
    }

    public func allQuizIDsIn(section: Int, subSection: Int) -> [Int] {
        var ids = [Int]()
        for (_, question) in _quizzes {
            if question["section"].intValue == section && question["subsection"].intValue == subSection {
                ids.append(question["questionID"].intValue)
            }
        }
        return ids
    }

    public func quiz(withID id: Int) -> Quiz? {
        for (_, question) in _quizzes {
            if question["questionID"].intValue == id {
                let answers =
                    question["answers"]
                        .map {
                            return $0.1["text"]
                                .stringValue
                                .trimmingCharacters(in: .whitespaces)
                        }.filter { return !$0.isEmpty }

                return Quiz(
                    question: question["question"].stringValue,
                    imageURL: question["images"][0].stringValue,
                    reason: question["feedback"].stringValue,
                    correctAnswerID: question["correctAnswer"].intValue,
                    answers: answers
                )
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
