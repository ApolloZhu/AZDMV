//
//  AnswerSelectionViewController.swift
//  DMV
//
//  Created by Apollo Zhu on 12/22/16.
//  Copyright © 2016 WWITDC. All rights reserved.
//

import UIKit

protocol AnswerSelectionViewDelegate: class {
    func didSelectAnswer(withID: Int, isCorrect: Bool)
}

@objc protocol AnswerSelectionViewDataSource: class {
    var answers: [String] { get }
    var correctID: Int { get }
    @objc optional var colorCorrect: UIColor { get }
    @objc optional var colorWrong: UIColor { get }
    @objc optional var colorSelected: UIColor { get }
}

class AnswerSelectionViewController: UIViewController {
    // MARK: UI
    @IBOutlet var buttons: [UIButton]?

    @IBAction func didSelect(_ button: UIButton) {
        let isCorrect = button.tag == correctButtonID
        if isCorrect {
            buttons!.forEach { if $0.isHidden == false { $0.isEnabled = false } }
            button.backgroundColor = dataSource?.colorCorrect ?? .positive
        } else {
            button.isEnabled = false
            button.backgroundColor = dataSource?.colorCorrect ?? .negative
        }
        button.setTitleColor(dataSource?.colorSelected ?? .white, for: .disabled)
        delegate?.didSelectAnswer(withID: button.tag, isCorrect: isCorrect)
    }

    // MARK: Data
    private var correctButtonID: Int? {
        if let id = dataSource?.correctID {
            switch id {
            case 1...4: return id
            case 5, 6: return id - 4
            case 7: return 4
            default: break
            }
        }
        return nil
    }

    public weak var delegate: AnswerSelectionViewDelegate?
    public weak var dataSource: AnswerSelectionViewDataSource? {
        didSet { reloadData() }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        reloadData()
    }

    public func reloadData() {
        DispatchQueue.main.async { [weak self] in
            guard let this = self,
                let answers = this.dataSource?.answers,
                let buttons = this.buttons else { return }
            (0..<answers.count).forEach {
                let button = buttons[$0]
                button.setTitle(answers[$0], for: .normal)
                button.isHidden = false
                button.isEnabled = true
                button.backgroundColor = .white
            }
            (answers.count..<buttons.count).forEach {
                buttons[$0].isHidden = true
            }
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        guard buttons?.first?.titleLabel?.frame.size != .zero else { return }
        buttons!.forEach {
            $0.titleLabel!.fit(in: $0)
        }
    }

}
