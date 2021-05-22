//
//  QuizzesTableViewController.swift
//  AZDMV
//
//  Created by Apollo Zhu on 2/11/18.
//  Copyright © 2016-2020 DMV A-Z. MIT License.
//

import UIKit
import AZDMVShared

class QuizzesTableViewController: UITableViewController {
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return flattened.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mapped[flattened[section]]!.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "QuizzesTableViewCell", for: indexPath)
        let subsection = mapped[flattened[indexPath.section]]![indexPath.row]
        cell.accessibilityLabel = String(
            format: NSLocalizedString(
                "Quiz.table.question.label",
                value:  "Question #%1$d",
                comment: "Accessibility label for a question in all quizzes"),
            subsection.questionID
        )
        cell.accessibilityValue = subsection.question

        cell.textLabel?.text = subsection.question
        cell.detailTextLabel?.text = "\(subsection.questionID)"
        return cell
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return flattened[section].name
    }

    // MARK: - Table view delegate

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? QuizTableViewController,
           let indexPath = tableView.indexPathForSelectedRow {
            let quiz = mapped[flattened[indexPath.section]]![indexPath.row]
//            quiz.translated { translated, _ in
                vc.quiz = quiz
                vc.section = indexPath.section
                vc.row = indexPath.row
                vc.allQuizzesVC = self
//            }
        }
    }
}
