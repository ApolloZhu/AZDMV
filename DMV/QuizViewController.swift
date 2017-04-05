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
            title = "#\(newValue)"
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

    @IBOutlet var constraintsWhenHasImage: [NSLayoutConstraint]?

    @IBOutlet weak var constraintWhenNoImage: NSLayoutConstraint?

    private func updateQuestion() {
        DispatchQueue.main.async { [weak self] in
            guard self != nil else { return }
            self!.question.text = self!.quiz?.question ?? Localized.NoQuizSelected
            let url = URL(dmvImageName: self!.quiz?.imageURL)
            if let url = url {
                self!.image?.kf.setImage(with: url, placeholder: dmvLogo)
            }
            UIView.animate(withDuration: 1, animations: { [weak self] in
                guard let this = self, url == nil else { return }
                this.image.isHidden = true
                this.constraintsWhenHasImage?.forEach {
                    $0.priority = 1
                }
                this.constraintWhenNoImage?.priority = 999
                this.view.layoutIfNeeded()
                }, completion: { [weak self] _ in
                    guard self != nil else { return }
                    self!.question.fit(in: self!.question)
            })
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
        } else {
            showSnackBar(message: quiz?.reason, in: image.isHidden ? nil : image)
        }
    }

    var snackBar = TTGSnackbar()

    @IBAction func didTap(_ sender: UITapGestureRecognizer) {
        snackBar.dismiss()
    }
}
