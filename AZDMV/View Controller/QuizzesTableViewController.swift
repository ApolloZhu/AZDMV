//
//  QuizzesTableViewController.swift
//  AZDMV
//
//  Created by Apollo Zhu on 2/11/18.
//  Copyright © 2016-2018 DMV A-Z. MIT License.
//

import UIKit

let subsections = fetchAllSubsections(from: .bundled, in: manual) ?? []

class QuizzesTableViewController: UITableViewController {
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return subsections.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subsections[section].count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "QuizzesTableViewCell", for: indexPath)
        let subsection = subsections[indexPath.section][indexPath.row]
        cell.textLabel?.text = "\(subsection.section).\(subsection.subSectionID)"
        cell.detailTextLabel?.text = subsection.title
        return cell
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return manual?.sections[section].title
    }

    // MARK: - Table view delegate

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
