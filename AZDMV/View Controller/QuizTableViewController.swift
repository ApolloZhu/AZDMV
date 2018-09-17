//
//  QuizTableViewController.swift
//  AZDMV
//
//  Created by Apollo Zhu on 9/16/18.
//  Copyright © 2018 DMV A-Z. All rights reserved.
//

import UIKit
import Kingfisher
import BLTNBoard
import ReverseExtension
import StatusAlert

extension UIColor {
    static let success = #colorLiteral(red: 0.294, green: 0.85, blue: 0.392, alpha: 1)
}

class QuizTableViewController: UITableViewController {
    var quiz: Quiz!
    override func viewDidLoad() {
        super.viewDidLoad()
        title = String(
            format: NSLocalizedString(
                "Quiz.title",
                value: "#%1$d, Section %2$d.%3$d",
                comment: "Title for quiz view"),
            quiz.rawQuestionID, quiz.rawSection, quiz.rawSubsection
        )
        tableView.allowsSelection = true
        tableView.re.delegate = self
        if #available(iOS 11.0, *) {
            navigationItem.largeTitleDisplayMode = .never
        }
        tableView.tableFooterView = UIView()
        tableView.alwaysBounceVertical = false
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

    var selected = [IndexPath]()

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selected.append(indexPath)
        let cell = tableView.cellForRow(at: indexPath)
        if quiz.answers.count - indexPath.row == quiz.correctAnswer {
            tableView.allowsSelection = false
            quiz.answers.indices.forEach {
                let indexPath = IndexPath(row: $0, section: 0)
                if selected.contains(indexPath) { return }
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
            if selected.contains(indexPath) {
                if !tableView.allowsSelection && selected.last == indexPath {
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

    private lazy var wrong: BLTNItemManager = {
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
    }()

    private lazy var correct: BLTNItemManager = {
        let page = BLTNPageItem(title: NSLocalizedString(
            "Quiz.correct.title",
            value: "Correct!",
            comment: "Enthusiastically congratulate the user."
        ))
        let manager = BLTNItemManager(rootItem: page)
        page.requiresCloseButton = false
        page.descriptionText = quiz?.feedback
        page.actionButtonTitle = NSLocalizedString(
            "Quiz.correct.action.next",
            value: "Try Next One",
            comment: "Prompt the user to move on to next question."
        )
        page.alternativeButtonTitle = NSLocalizedString(
            "Quiz.correct.action.cancel",
            value: "Maybe Later",
            comment: "Give the user a choice to stay in the current quiz."
        )
        page.appearance.actionButtonColor = .success
        page.appearance.actionButtonTitleColor = .white
        page.appearance.alternativeButtonTitleColor = .success
        page.actionHandler = { _ in
            #warning("TODO: Implement go to next quiz")
            manager.dismissBulletin()
        }
        page.alternativeHandler = { _ in
            manager.dismissBulletin()
        }
        return manager
    }()
}
