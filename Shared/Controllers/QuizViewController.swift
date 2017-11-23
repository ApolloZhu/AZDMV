//
//  QuizViewController.swift
//  DMV
//
//  Created by Apollo Zhu on 12/22/16.
//  Copyright © 2016 WWITDC. All rights reserved.
//

import UIKit
import Kingfisher

#if os(iOS)
    import TTGSnackbar
#endif

class QuizViewController: UIViewController,
AnswerSelectionViewDelegate, AnswerSelectionViewDataSource {
    // MARK: UI
    @IBOutlet weak var question: UILabel!
    @IBOutlet weak var image: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        image.kf.indicatorType = .activity
        image.isHidden = true
        // Split View
        navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
        #if os(iOS)
            navigationItem.leftItemsSupplementBackButton = true
        #endif
    }

    // MARK: Basic
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
            answerSelectionViewController?.view.isHidden = false
            answerSelectionViewController?.reloadData()
        }
    }

    @IBOutlet var constraintsWhenHasImage: [NSLayoutConstraint]?

    @IBOutlet weak var constraintWhenNoImage: NSLayoutConstraint?

    private func updateQuestion() {
        DispatchQueue.main.async { [weak self] in
            guard let this = self else { return }
            this.question.text = this.quiz?.question ?? Localized.NoQuizSelected
            if let url = URL(dmvImageName: this.quiz?.imageURL) {
                this.image?.kf.setImage(with: url, placeholder: .dmvLogo)
            } else {
                UIView.animate(
                    withDuration: 1,
                    animations: { [weak self] in
                        guard let this = self else { return }
                        this.image.isHidden = true
                        this.constraintsWhenHasImage?.forEach { $0.priority = .defaultLow }
                        this.constraintWhenNoImage?.priority = .defaultHigh
                        this.view.layoutIfNeeded() },
                    completion: { [weak self] _ in
                        guard let this = self else { return }
                        this.question.fit(in: this.question) }
                )
            }
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
    private weak var answerSelectionViewController: AnswerSelectionViewController! {
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
            answerSelectionViewController.view.isHidden = true
        }
    }

    // MARK: Answer Selection Delegate
    func didSelectAnswer(withID: Int, isCorrect: Bool) {
        if isCorrect {
            ErrorPresenter.shared.dismiss()
            question.text = "Correct!\n\(quiz!.reason)"
            question.fit(in: question)
        } else {
            ErrorPresenter.shared.presentError(message: quiz?.reason, in: image.isHidden ? nil : image)
        }
    }

    @IBAction func didTap(_ sender: UITapGestureRecognizer) {
        ErrorPresenter.shared.dismiss()
    }
}
