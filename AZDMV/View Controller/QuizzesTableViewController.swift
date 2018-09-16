//
//  QuizzesTableViewController.swift
//  AZDMV
//
//  Created by Apollo Zhu on 2/11/18.
//  Copyright © 2016-2018 DMV A-Z. MIT License.
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
let flattend = subsections.flatMap { $0 }.filter { mapped.keys.contains($0) }

class QuizzesTableViewController: UITableViewController {
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return flattend.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mapped[flattend[section]]!.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "QuizzesTableViewCell", for: indexPath)
        let subsection = mapped[flattend[indexPath.section]]![indexPath.row]
        cell.textLabel?.text = subsection.question
        cell.detailTextLabel?.text = subsection.rawQuestionID
        return cell
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let subsection = flattend[section]
        return "\(subsection.section).\(subsection.subSectionID) \(subsection.title)"
    }

    // MARK: - Table view delegate

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? QuizTableViewController
            , let indexPath = tableView.indexPathForSelectedRow {
            vc.quiz = mapped[flattend[indexPath.section]]?[indexPath.row]
        }
    }
}
