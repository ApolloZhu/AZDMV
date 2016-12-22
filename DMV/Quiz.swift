//
//  Quiz.swift
//  DMV
//
//  Created by Apollo Zhu on 12/21/16.
//  Copyright © 2016 WWITDC. All rights reserved.
//

import SwiftyJSON

let quizSet = QuizSet.shared
open class QuizSet {
    public static let shared = QuizSet()
    private var quizzes: JSON

    private init(){
        quizzes = JSON(data: try! Data(contentsOf: Bundle.main.url(forResource: "quiz", withExtension: "json")!))
    }

    public func allQuizIDsIn(section: Int, subSection: Int) -> [Int] {
        var ids = [Int]()
        for (_, question) in quizzes {
            if question["section"].intValue == section && question["subsection"].intValue == subSection {
                ids.append(question["questionID"].intValue)
            }
        }
        return ids
    }

    public func quiz(withID id: Int) -> Quiz? {
        for (_, question) in quizzes {
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
                    reason: question["feedback"].stringValue,
                    correctID: question["correctAnswer"].intValue,
                    answers: answers,
                    image: question["images"][0].stringValue
                )
            }
        }
        return nil
    }
}

extension QuizSet {
    open class Quiz {
        open let question: String
        open let image: String?
        open let reason: String
        open let correctAnswerID: Int
        open let answers: [String]
        public init(question: String, reason: String, correctID: Int, answers: [String], image: String? = nil) {
            self.question = question
            self.image = image
            self.reason = reason
            self.correctAnswerID = correctID
            self.answers = answers
        }
    }
}
