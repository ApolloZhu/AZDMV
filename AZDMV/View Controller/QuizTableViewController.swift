//
//  QuizTableViewController.swift
//  AZDMV
//
//  Created by Apollo Zhu on 9/16/18.
//  Copyright © 2016-2019 DMV A-Z. MIT License.
//

import UIKit
import Kingfisher
import BLTNBoard
import ReverseExtension
import StatusAlert

extension UIColor {
    static let success = UIColor.theme
}

class QuizTableViewController: UITableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.allowsSelection = true
        tableView.re.delegate = self
        if #available(iOS 11.0, *) {
            navigationItem.largeTitleDisplayMode = .never
        }
        tableView.tableFooterView = UIView()
        tableView.alwaysBounceVertical = false
    }
    
    // MARK: - UITableViewDataSource
    
    var quiz: Quiz! {
        didSet {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.selectedAnswers = []
                self.tableView.allowsSelection = true
                self.title = String(
                    format: NSLocalizedString(
                        "Quiz.title",
                        value: "#%1$d, Section %2$d.%3$d",
                        comment: "Title for quiz view"),
                    self.quiz.questionID, self.quiz.section, self.quiz.subsection
                )
                self.tableView.reloadData()
            }
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 1: return quiz.images.count + 1
        case 0: return quiz.answers.count
        default: return 0
        }
    }
    
    private var selectedAnswers = [IndexPath]()
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 1:
            let cell: UITableViewCell
            if let url = quiz.imageURL, indexPath.row == 0 {
                cell = tableView.dequeueReusableCell(withIdentifier: "ImageCell", for: indexPath)
                let imageView = cell.contentView.subviews.first as! UIImageView
                if #available(iOS 11.0, *) {
                    imageView.accessibilityIgnoresInvertColors = true
                }
                imageView.kf.indicatorType = .activity
                imageView.kf.setImage(with: url) { _, error, _, _ in
                    guard let error = error else { return }
                    let statusAlert = StatusAlert()
                    if #available(iOS 10.0, *) {
                        statusAlert.appearance.blurStyle = .prominent
                    }
                    statusAlert.title = NSLocalizedString(
                        "QuizTableViewController.ImageCell.setImage.error",
                        value: "Failed to load image",
                        comment: "App failed to fetch image used in the current quiz."
                    )
                    statusAlert.message = error.localizedDescription
                    statusAlert.showInKeyWindow()
                }
            } else {
                cell = tableView.dequeueReusableCell(withIdentifier: "QuestionCell", for: indexPath)
                cell.textLabel?.text = quiz.question
            }
            cell.isUserInteractionEnabled = false
            return cell
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TextCell", for: indexPath)
            cell.textLabel?.text = quiz.answers[quiz.answers.count - 1 - indexPath.row].text
            cell.backgroundColor = .white
            cell.accessoryType = .none
            if selectedAnswers.contains(indexPath) {
                if !tableView.allowsSelection && selectedAnswers.last == indexPath {
                    cell.textLabel?.textColor = .success
                } else {
                    cell.isUserInteractionEnabled = false
                    cell.textLabel?.textColor = .red
                }
            } else {
                if tableView.allowsSelection {
                    cell.isUserInteractionEnabled = true
                    cell.textLabel?.textColor = .black
                } else {
                    cell.textLabel?.textColor = .lightGray
                }
            }
            return cell
        default:
            fatalError("Extra Section")
        }
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedAnswers.append(indexPath)
        let cell = tableView.cellForRow(at: indexPath)
        if quiz.answers.count - indexPath.row == quiz.correctAnswer {
            tableView.allowsSelection = false
            quiz.answers.indices.forEach {
                let indexPath = IndexPath(row: $0, section: 0)
                if selectedAnswers.contains(indexPath) { return }
                tableView.cellForRow(at: indexPath)?.textLabel?.textColor = .lightGray
            }
            cell?.textLabel?.textColor = .success
            correct.showBulletin(above: self)
        } else {
            cell?.isUserInteractionEnabled = false
            cell?.textLabel?.textColor = .red
            wrong.showBulletin(above: self)
        }
    }

    private var wrong: BLTNItemManager {
        let page = BLTNPageItem(title: NSLocalizedString(
            "Quiz.wrong.title",
            value: "Not Quite...",
            comment: "Friendly tell the user the answer selected is wrong."
        ))
        let manager = BLTNItemManager(rootItem: page)
        page.requiresCloseButton = false
        page.descriptionText = quiz?.feedback
        page.actionButtonTitle = NSLocalizedString(
            "Quiz.wrong.action",
            value: "Try Aagain",
            comment: "Prompt the user to select another answer."
        )
        page.appearance.actionButtonColor = .red
        page.appearance.actionButtonTitleColor = .white
        page.actionHandler = { _ in
            manager.dismissBulletin()
        }
        if #available(iOS 10, *) {
            manager.backgroundViewStyle = .blurredLight
        }
        return manager
    }
    
    var section: Int!
    var row: Int!
    
    private var correct: BLTNItemManager {
        let page = BLTNPageItem(title: NSLocalizedString(
            "Quiz.correct.title",
            value: "Correct!",
            comment: "Enthusiastically congratulate the user."
        ))
        let manager = BLTNItemManager(rootItem: page)
        page.descriptionText = quiz?.feedback
        page.actionButtonTitle = NSLocalizedString(
            "Quiz.correct.action.next",
            value: "Try Next One",
            comment: "Prompt the user to move on to next question."
        )
        page.alternativeButtonTitle = NSLocalizedString(
            "Quiz.correct.action.previous",
            value: "Try Previous One",
            comment: "Prompt the user to move on to previous question."
        )
        page.appearance.actionButtonColor = .success
        page.appearance.actionButtonTitleColor = .white
        page.appearance.alternativeButtonTitleColor = .success
        page.actionHandler = { [weak self] _ in
            defer { manager.dismissBulletin() }
            guard let self = self else { return }
            let newRow = self.row + 1
            if newRow == mapped[flattend[self.section]]!.count {
                if self.section + 1 == flattend.count {
                    let statusAlert = StatusAlert()
                    if #available(iOS 10.0, *) {
                        statusAlert.appearance.blurStyle = .prominent
                    }
                    statusAlert.title = NSLocalizedString(
                        "Quiz.last.title",
                        value: "Good job!",
                        comment: "Congradulate to user"
                    )
                    statusAlert.message = NSLocalizedString(
                        "Quiz.last.message",
                        value: "This is the last question.",
                        comment: "Clarify it is the last question"
                    )
                    statusAlert.showInKeyWindow()
                } else {
                    self.row = 0
                    self.section += 1
                    self.quiz = mapped[flattend[self.section]]![0]
                }
            } else {
                self.row = newRow
                self.quiz = mapped[flattend[self.section]]![newRow]
            }
        }
        page.alternativeHandler = { [weak self] _ in
            defer { manager.dismissBulletin() }
            guard let self = self else { return }
            if self.row == 0 {
                if self.section == 0 {
                    let statusAlert = StatusAlert()
                    if #available(iOS 10.0, *) {
                        statusAlert.appearance.blurStyle = .prominent
                    }
                    statusAlert.title = NSLocalizedString(
                        "Quiz.first.title",
                        value: "Try next one?",
                        comment: "Direct the user to go to next question"
                    )
                    statusAlert.message = NSLocalizedString(
                        "Quiz.first.message",
                        value: "This is the first question.",
                        comment: "Clarify it is the first question"
                    )
                    statusAlert.showInKeyWindow()
                } else {
                    self.section -= 1
                    let quizzes = mapped[flattend[self.section]]!
                    self.row = quizzes.count - 1
                    self.quiz = quizzes.last
                }
            } else {
                self.row -= 1
                self.quiz = mapped[flattend[self.section]]![self.row]
            }
        }
        return manager
    }

    // MARK: - Update Selection in Previous Controller
    
    weak var allQuizzesVC: QuizzesTableViewController?
    
    private var allQuizzesTableView: UITableView? {
        return allQuizzesVC?.tableView
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if let oldSelection = allQuizzesTableView?.indexPathForSelectedRow {
            allQuizzesTableView?.deselectRow(at: oldSelection, animated: false)
        }
        super.viewWillDisappear(animated)
        if let coordinator = transitionCoordinator {
            coordinator.animate(alongsideTransition: { [weak self] context in
                self?.updateSelection(animated: animated && context.isAnimated)
            })
        } else {
            updateSelection(animated: animated)
        }
    }
    
    func updateSelection(animated: Bool) {
        let newSelection = IndexPath(row: row, section: section)
        allQuizzesTableView?.selectRow(at: newSelection, animated: false, scrollPosition: .middle)
        allQuizzesTableView?.deselectRow(at: newSelection, animated: animated)
    }
}
