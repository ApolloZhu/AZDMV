//
//  QuizzesTableViewController.swift
//  AZDMV
//
//  Created by Apollo Zhu on 2/11/18.
//  Copyright © 2016-2019 DMV A-Z. MIT License.
//

import UIKit

let quizzes = Quizzes.fetch(from: .bundled)!
extension Quiz {
    var subSection: Subsection {
        return subsections[section - 1][subsection - 1]
    }
}
let mapped = [Subsection: [Quiz]](grouping: quizzes) { $0.subSection }
    .mapValues { $0.sorted(by: { $0.rawQuestionID < $1.rawQuestionID }) }
let flattened = Array(subsections.lazy.flatMap { $0 }.filter { mapped.keys.contains($0) })

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
                value:  "Question #%1$@",
                comment: "Accessibility label for a question in all quizzes"),
            subsection.rawQuestionID
        )
        cell.accessibilityValue = subsection.question

        cell.textLabel?.text = subsection.question
        cell.detailTextLabel?.text = subsection.rawQuestionID
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
            quiz.translated { translated, _ in
                vc.quiz = translated ?? quiz
                vc.section = indexPath.section
                vc.row = indexPath.row
                vc.allQuizzesVC = self
            }
        }
    }
}
