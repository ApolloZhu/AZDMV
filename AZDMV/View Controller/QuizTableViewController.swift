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
        tableView.alwaysBounceVertical = false
        for direction in [UISwipeGestureRecognizer.Direction.left, .right] {
            let swipe = UISwipeGestureRecognizer(target: self, action: #selector(swiped))
            swipe.direction = direction
            tableView.addGestureRecognizer(swipe)
        }
    }
    
    // MARK: - UITableViewDataSource
    
    var quiz: Quiz! {
        didSet {
            selectedAnswers = []
            tableView.allowsSelection = true
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.title = String(
                    format: NSLocalizedString(
                        "Quiz.title",
                        value: "#%1$d, Section %2$d.%3$d",
                        comment: "Title for quiz view"),
                    self.quiz.questionID, self.quiz.section, self.quiz.subsection
                )
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
                    showAlert(
                        title: NSLocalizedString(
                            "QuizTableViewController.ImageCell.setImage.error",
                            value: "Failed to load image",
                            comment: "App failed to fetch image used in the current quiz."
                        ),
                        message: error.localizedDescription
                    )
                }
            } else {
                cell = tableView.dequeueReusableCell(withIdentifier: "QuestionCell", for: indexPath)
                cell.textLabel?.text = quiz.question
            }
            cell.isUserInteractionEnabled = false
            return cell
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TextCell", for: indexPath)
            cell.textLabel?.backgroundColor = .white
            cell.textLabel?.layer.cornerRadius = 0
            cell.textLabel?.layer.masksToBounds = false
            cell.textLabel?.textAlignment = .natural
            cell.accessoryType = .none
            var attributes: [NSAttributedString.Key: Any]? = nil
            if selectedAnswers.contains(indexPath) {
                if !tableView.allowsSelection && selectedAnswers.last == indexPath {
                    cell.textLabel?.backgroundColor = .success
                    cell.textLabel?.layer.cornerRadius = 5
                    cell.textLabel?.layer.masksToBounds = true
                    cell.textLabel?.textAlignment = .center
                    cell.textLabel?.textColor = .white
                } else {
                    cell.isUserInteractionEnabled = false
                    attributes = [
                        .strikethroughStyle: NSUnderlineStyle.single.rawValue,
                        .foregroundColor: UIColor.red,
                        .baselineOffset: 0
                    ]
                }
            } else {
                if tableView.allowsSelection {
                    cell.isUserInteractionEnabled = true
                    cell.textLabel?.textColor = .black
                } else {
                    cell.textLabel?.textColor = .lightGray
                }
            }
            cell.textLabel?.attributedText = NSAttributedString(
                string: quiz.answers[quiz.answers.count - 1 - indexPath.row].text,
                attributes: attributes
            )
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
            tableView.reloadData()
            correct.showBulletin(above: self)
        } else {
            cell?.isUserInteractionEnabled = false
            tableView.reloadRows(at: [indexPath], with: .none)
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
            self?.showNextQuiz()
        }
        page.alternativeHandler = { [weak self] _ in
            defer { manager.dismissBulletin() }
            self?.showPreviousQuiz()
        }
        return manager
    }
    
    private func showPreviousQuiz() {
        if row == 0 {
            if section == 0 {
                return showAlert(
                    title: NSLocalizedString(
                        "Quiz.first.title",
                        value: "Try next one?",
                        comment: "Direct the user to go to next question"
                    ),
                    message: NSLocalizedString(
                        "Quiz.first.message",
                        value: "This is the first question.",
                        comment: "Clarify it is the first question"
                    )
                )
            } else {
                section -= 1
                let quizzes = mapped[flattend[section]]!
                row = quizzes.count - 1
                quiz = quizzes.last
            }
        } else {
            row -= 1
            quiz = mapped[flattend[section]]![row]
        }
        needsSelectionUpdate = true
        tableView.reloadData(animation: .right)
    }
    
    private func showNextQuiz() {
        let newRow = row + 1
        if newRow == mapped[flattend[section]]!.count {
            if section + 1 == flattend.count {
                return showAlert(
                    title: NSLocalizedString(
                        "Quiz.last.title",
                        value: "Good job!",
                        comment: "Congradulate to user"
                    ),
                    message: NSLocalizedString(
                        "Quiz.last.message",
                        value: "This is the last question.",
                        comment: "Clarify it is the last question"
                    )
                )
            } else {
                row = 0
                section += 1
                quiz = mapped[flattend[section]]![0]
            }
        } else {
            row = newRow
            quiz = mapped[flattend[section]]![newRow]
        }
        needsSelectionUpdate = true
        tableView.reloadData(animation: .left)
    }
    
    @objc private func swiped(_ recognizer: UISwipeGestureRecognizer) {
        switch recognizer.direction {
        case .left:
            showPreviousQuiz()
        case .right:
            showNextQuiz()
        default:
            fatalError("\(recognizer.direction.rawValue)")
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    // MARK: - Update Selection in Previous Controller
    
    private var needsSelectionUpdate = false
    
    weak var allQuizzesVC: QuizzesTableViewController?
    
    private var allQuizzesTableView: UITableView? {
        return allQuizzesVC?.tableView
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        guard needsSelectionUpdate else {
            return super.viewWillDisappear(animated)
        }
        if let oldSelection = allQuizzesTableView?.indexPathForSelectedRow {
            allQuizzesTableView?.deselectRow(at: oldSelection, animated: false)
        }
        super.viewWillDisappear(animated)
        if let coordinator = transitionCoordinator {
            coordinator.animate(alongsideTransition: nil) { [weak self] (context) in
                self?.updateSelection(animated: animated && context.isAnimated)
            }
        } else {
            updateSelection(animated: animated)
        }
    }
    
    private func updateSelection(animated: Bool) {
        let newSelection = IndexPath(row: row, section: section)
        allQuizzesTableView?.selectRow(at: newSelection, animated: animated, scrollPosition: .middle)
        allQuizzesTableView?.deselectRow(at: newSelection, animated: animated)
    }
}

extension UITableView {
    /// https://stackoverflow.com/questions/33410482/table-view-cell-load-animation-one-after-another#49570817
    func reloadData(animation: UITableView.RowAnimation) {
        reloadData()
        
        let transform: CGAffineTransform
        let offset = bounds.size.width
        switch animation {
        case .left:
            transform = CGAffineTransform(translationX: -offset, y: 0)
        case .right:
            transform = CGAffineTransform(translationX: offset, y: 0)
        default:
            fatalError("Not implemented")
        }
        
        let cells = visibleCells
        cells.forEach { $0.transform = transform }
        for (delayCounter, cell) in cells.reversed().enumerated() {
            UIView.animate(withDuration: 1, delay: 0.06 * Double(delayCounter),
                           usingSpringWithDamping: 0.8, initialSpringVelocity: 0,
                           options: .curveEaseInOut, animations: {
                cell.transform = .identity
            }, completion: { finished in
                if !finished { cell.transform = .identity }
            })
        }
    }
}
