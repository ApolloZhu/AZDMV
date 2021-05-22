//
//  Translate.swift
//  AZDMV
//
//  Created by Apollo Zhu on 9/14/18.
//  Copyright © 2016-2020 DMV A-Z. MIT License.
//

import Foundation
import Firebase
import AZDMVShared

let db = Firestore.firestore()
private let urlPrefix = "https://api.cognitive.microsofttranslator.com/translate?api-version=3.0&from=en&to="

extension Quiz {
    private func translated<S>(question: String, feedback: String, answers: S) -> Quiz
        where S: Sequence, S.Element == String {
            return Quiz(
                rawSection: rawSection,
                rawSubsection: rawSubsection,
                rawQuestionID: rawQuestionID,
                question: question,
                images: images,
                feedback: feedback,
                rawCorrectAnswer: self.rawCorrectAnswer,
                rawAnswers: zip(1..., answers).map {
                    Answer(value: "\($0.0)", text: $0.1)
                },
                update: self.update,
                category: self.category
            )
    }

    func translated(to language: Language = .preferred,
                    then process: @escaping (Quiz?, Error?) -> Void) {
        guard language != .English else { return process(self, nil) }
        let cache = db.collection(language.rawValue).document("\(questionID)")
        cache.getDocument { (snapshot, error) in
            if let data = snapshot?.data() {
                // MARK: Retrieve cached from Firestore
                process(self.translated(
                    question: data["question"] as! String,
                    feedback: data["feedback"] as! String,
                    answers: data["answers"] as! [String]
                ), nil)
            } else {
                // MARK: Ask Microsoft to translate
                let url = URL(string: urlPrefix + language.rawValue)
                var request = URLRequest(url: url!)
                request.httpMethod = "POST"
                let text = [self.question, self.feedback]
                    + self.answers.map { $0.text }
                let wrapped = text.map(RequestWrapper.init)
                request.httpBody = try! JSONEncoder().encode(wrapped)
                request.addValue("7a39e268ad224a22a3be9349fa067564",
                                 forHTTPHeaderField: "Ocp-Apim-Subscription-Key")
                request.addValue("application/json",
                                 forHTTPHeaderField: "Content-Type")
                let task = URLSession.shared.dataTask(with: request) {
                    self.map(data: $0, request: $1, error: $2,
                             saveTo: cache, then: process)
                }
                task.resume()
            }
        }
    }
    
    private func map(data: Data?, request: URLResponse?, error: Error?,
                     saveTo cache: DocumentReference,
                     then process: @escaping (Quiz?, Error?) -> Void) {
        guard let data = data else { return process(nil, error) }
        let decoder = JSONDecoder()
        if let decoded = try? decoder.decode([ResponseWrapper].self, from: data) {
            let translations = decoded.map { $0.translations[0].text }
            cache.setData([
                "question": translations[0],
                "feedback": translations[1],
                "answers": Array(translations[2...])])
            process(translated(
                question: translations[0],
                feedback: translations[1],
                answers: translations[2...]
            ), nil)
        } else if let error = try? decoder.decode(ErrorWrapper.self, from: data) {
            process(nil, AnyError(errorDescription: error.error.message))
        } else {
            process(nil, AnyError.errored)
        }
    }
    
    private struct RequestWrapper: Encodable {
        let Text: String
    }
    
    private struct ResponseWrapper: Decodable {
        let translations: [Translation]
        struct Translation: Decodable {
            let text: String
            // let to: Language
        }
    }
    
    private struct ErrorWrapper: Decodable {
        let error: MicrosoftError
        struct MicrosoftError: Decodable {
            // let code: Int
            let message: String
        }
    }
}
