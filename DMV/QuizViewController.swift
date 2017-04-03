//
//  QuizViewController.swift
//  DMV
//
//  Created by Apollo Zhu on 12/22/16.
//  Copyright © 2016 WWITDC. All rights reserved.
//

import UIKit
import Kingfisher
import TTGSnackbar

class QuizViewController: UIViewController, AnswerSelectionViewDelegate, AnswerSelectionViewDataSource, TTGSnackbarPresenter {

    // MARK: UI
    override func viewDidLoad() {
        super.viewDidLoad()
        // Split View
        navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
        navigationItem.leftItemsSupplementBackButton = true
    }

    // MARK: Basic
    @IBOutlet weak var question: UILabel!
    @IBOutlet weak var image: UIImageView!

    public var id: Int = 0 {
        willSet {
            DispatchQueue.global(qos: .userInteractive).async { [weak self] in
                self?.quiz = quizSet.quiz(withID: newValue)
            }
        }
    }

    private var quiz: QuizSet.Quiz? = nil {
        didSet {
            updateQuestion()
            answerSelectionViewController?.reloadData()
        }
    }

    private func updateQuestion() {
        DispatchQueue.main.async { [weak self] in
            guard let this = self else { return }
            let text = this.quiz?.question ?? Localized.NoQuizSelected
            this.showSnackBar(message: text, in: this.image)
            if let url = URL(dmvImageName: this.quiz?.imageURL) {
                this.image?.kf.setImage(with: url, placeholder: dmvLogo)
            }
            this.question.text = text
            this.question.fit(in: this.question)
        }
    }

    // MARK: Answer Selection Data Source
    var correctID: Int {
        return quiz?.correctAnswerID ?? 0
    }

    var answers: [String] {
        return quiz?.answers ?? []
    }

    // MARK: Answer Selection Setup
    private weak var answerSelectionViewController: AnswerSelectionViewController? {
        willSet {
            answerSelectionViewController?.delegate = nil
            answerSelectionViewController?.dataSource = nil
            newValue?.delegate = self
            newValue?.dataSource = self
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.terminus as? AnswerSelectionViewController,
            segue.identifier == Identifier.ShowAnswersSegue {
            answerSelectionViewController = vc
        }
    }

    // MARK: Answer Selection Delegate
    func didSelectAnswer(withID: Int, isCorrect: Bool) {
        if isCorrect {
            snackBar.dismiss()
            question.text = "Correct!\n\(quiz!.reason)"
            question.fit(in: question)
            showSnackBar(message: question.text, in: image)
        } else {
            showSnackBar(message: quiz?.reason, in: image)
        }
    }

    // MARK: Zoom
    var snackBar = TTGSnackbar()

    @IBAction func didTap(_ sender: UITapGestureRecognizer) {
        snackBar.dismiss()
    }

    @IBAction func showLongQuestion(_ sender: UILongPressGestureRecognizer) {
        if sender.state == .began {
            showSnackBar(message: question?.text, in: image)
        }
    }
    
}
