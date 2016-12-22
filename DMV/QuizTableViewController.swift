//
//  QuizTableViewController.swift
//  DMV
//
//  Created by Apollo Zhu on 12/22/16.
//  Copyright © 2016 WWITDC. All rights reserved.
//

import UIKit
import Kingfisher

class QuizTableViewController: UITableViewController, UISplitViewControllerDelegate {

    @IBOutlet weak var question: UITextView!
    @IBOutlet weak var image: UIImageView!

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
            DispatchQueue.main.async { [weak self] in
                self?.tableView?.reloadData()
            }
        }
    }

    private func updateQuestion() {
        question?.text = quiz?.question ?? "No Quiz! Take a break!"
        if let url = URL(dmvImageName: quiz?.image) {
            image?.kf.setImage(with: url, placeholder: dmvLogo)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        splitViewController?.delegate = self
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = quiz?.answers.count ?? 0
        return count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Identifier.ChoiceReusableTableViewCell, for: indexPath)
        cell.textLabel?.text = quiz?.answers[indexPath.row] ?? "╮(￣▽￣)╭"
        return cell
    }

    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        return quiz == nil || false
    }

}
