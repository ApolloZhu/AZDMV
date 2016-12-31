//
//  AnswerSelectionViewController.swift
//  DMV
//
//  Created by Apollo Zhu on 12/22/16.
//  Copyright © 2016 WWITDC. All rights reserved.
//

import UIKit
import TTGSnackbar

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

class AnswerSelectionViewController: UIViewController, TTGSnackbarPresenter {
    // MARK: Fields
    @IBOutlet private weak var a: UIButton!
    @IBOutlet private weak var b: UIButton!
    @IBOutlet private weak var c: UIButton!
    @IBOutlet private weak var d: UIButton!
    private var buttons: [UIButton?] { return [a,b,c,d] }

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

    // MARK: Data loading
    override func viewDidLoad() {
        super.viewDidLoad()
        reloadData()
    }

    public func reloadData() {
        DispatchQueue.main.async { [weak self] in
            if let this = self {
                this.snackBar.dismiss()
                this.buttonWithTouchOnTop = nil
                if let answers = this.dataSource?.answers {
                    for i in 0..<answers.count {
                        if let button = this.buttons[i] {
                            button.setTitle(answers[i], for: .all)
                            button.isHidden = false
                            button.isEnabled = true
                            button.backgroundColor = .white
                            button.titleLabel?.numberOfLines = 0
                            button.titleLabel?.minimumScaleFactor = 0.2
                            button.titleLabel?.adjustsFontSizeToFitWidth = true
                        }
                    }
                    for i in answers.count..<4 {
                        this.buttons[i]?.isHidden = true
                    }
                }
            }
        }
    }

    // MARK: Answer Selection
    @IBAction func didSelect(_ button: UIButton) {
        let isCorrect = button.tag == correctButtonID
        if isCorrect {
            buttons.forEach { if $0?.isHidden == false { $0?.isEnabled = false } }
            button.backgroundColor = dataSource?.colorCorrect ?? .green
        } else {
            button.isEnabled = false
            button.backgroundColor = dataSource?.colorCorrect ?? .red
        }
        button.setTitleColor(dataSource?.colorSelected ?? .white, for: .disabled)
        delegate?.didSelectAnswer(withID: button.tag, isCorrect: isCorrect)
        snackBar.dismiss()
    }

    // MARK: Trigger Preview
    private weak var buttonWithTouchOnTop: UIButton? = nil
    var snackBar =  TTGSnackbar()
    @IBAction func didPress(_ sender: UILongPressGestureRecognizer) {
        switch sender.state {
        case .began, .changed:
            let loc = sender.location(in: view)
            for button in buttons {
                if let button = button {
                    if button.isEnabled && button.frame.contains(loc) && buttonWithTouchOnTop != button {
                        buttonWithTouchOnTop = button
                        showSnackBar(message: button.currentTitle, in: view)
                    }
                }
            }
        default: break
        }
    }
    
}
