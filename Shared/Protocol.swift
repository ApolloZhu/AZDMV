//
//  Protocols.swift
//  AZDMV-iOS
//
//  Created by Apollo Zhu on 6/10/17.
//  Copyright © 2017 WWITDC. All rights reserved.
//

import UIKit

protocol QuizPresenter {
    func presentQuiz(withID: Int)
}

protocol AnswerSelectionPresenter { }

protocol CorrectAnswerSelectionPresenter { }

protocol AnswerSelectionViewDelegate: class {
    func didSelectAnswer(withID: Int, isCorrect: Bool)
}

@objc protocol AnswerSelectionViewDataSource: class {
    var answers: [String] { get }
    var correctID: Int { get }
    @objc optional var colorCorrect: UIColor { get }
    @objc optional var colorWrong: UIColor { get }
    @objc optional var colorSelected: UIColor { get }
}
