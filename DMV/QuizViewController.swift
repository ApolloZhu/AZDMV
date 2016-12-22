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

class QuizViewController: UIViewController, UISplitViewControllerDelegate, AnswerSelectionViewDelegate, AnswerSelectionViewDataSource {

    @IBOutlet weak var question: UILabel!
    @IBOutlet weak var image: UIImageView!

    private lazy var snackBar = TTGSnackbar()

    private weak var answerSelectionViewController: AnswerSelectionViewController? {
        willSet {
            newValue?.delegate = self
            newValue?.dataSource = self
        }
    }

    public var id: Int = 0 {
        willSet {
            DispatchQueue.global(qos: .userInteractive).async { [weak self] in
                self?.quiz = quizSet.quiz(withID: newValue)
            }
        }
    }

    private var quiz: QuizSet.Quiz? = nil {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.updateQuestion()
            }
            DispatchQueue.global(qos: .userInteractive).async { [weak self] in
                self?.answerSelectionViewController?.reloadData()
            }
        }
    }

    var correctID: Int {
        return quiz?.correctAnswerID ?? 0
    }

    var answers: [String] {
        return quiz?.answers ?? []
    }

    func didSelectAnswer(withID: Int, isCorrect: Bool) {
        if isCorrect {
            snackBar.dismiss()
            question.text = "Correct!\n\(quiz!.reason)"
        } else {
            showSnackBar(message: quiz?.reason)
        }
    }

    private func updateQuestion() {
        question?.text = quiz?.question ?? Identifier.NoQuizSelected
        if let url = URL(dmvImageName: quiz?.image) {
            image?.kf.setImage(with: url, placeholder: dmvLogo)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        splitViewController?.delegate = self
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.terminus as? AnswerSelectionViewController,
            segue.identifier == Identifier.ShowAnswersSegue {
            answerSelectionViewController = vc
        }
    }
    @IBAction func didTap(_ sender: UITapGestureRecognizer) {
        snackBar.dismiss()
    }

    @IBAction func showLongQuestion(_ sender: UILongPressGestureRecognizer) {
        if sender.state == .began {
            showSnackBar(message: question?.text)
        }
    }

    private func showSnackBar(message: String?) {
        snackBar.dismiss()
        snackBar = TTGSnackbar(message: message ?? Identifier.Nothing, duration: .long)
        snackBar.animationType = .slideFromTopBackToTop
        snackBar.contentInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        snackBar.show()
    }

    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        return quiz == nil || false
    }
    
}
