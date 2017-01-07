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
    // MARK: UI
    @IBOutlet var buttons: [UIButton]?
    
    @IBAction func didSelect(_ button: UIButton) {
        let isCorrect = button.tag == correctButtonID
        if isCorrect {
            buttons!.forEach { if $0.isHidden == false { $0.isEnabled = false } }
            button.backgroundColor = dataSource?.colorCorrect ?? .green
        } else {
            button.isEnabled = false
            button.backgroundColor = dataSource?.colorCorrect ?? .red
        }
        button.setTitleColor(dataSource?.colorSelected ?? .white, for: .disabled)
        delegate?.didSelectAnswer(withID: button.tag, isCorrect: isCorrect)
        snackBar.dismiss()
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
            if let this = self {
                this.snackBar.dismiss()
                this.buttonWithTouchOnTop = nil
                if  let answers = this.dataSource?.answers,
                    let buttons = this.buttons
                {
                    (0..<answers.count).forEach {
                        let button = buttons[$0]
                        button.setTitle(answers[$0], for: .all)
                        button.isHidden = false
                        button.isEnabled = true
                        button.backgroundColor = .white
                        if #available(iOS 9.0, *) {
                            button.titleLabel?.font = .system
                        } // else using title2
                    }
                    (answers.count..<buttons.count).forEach {
                        buttons[$0].isHidden = true
                    }
                }
            }
        }
    }
    
    // MARK: Zoom
    private weak var buttonWithTouchOnTop: UIButton? = nil
    var snackBar =  TTGSnackbar()
    @IBAction func didPress(_ sender: UILongPressGestureRecognizer) {
        switch sender.state {
        case .began, .changed:
            let touchLocation = sender.location(in: view)
            if let buttons = buttons {
                for button in buttons {
                    if  button.isEnabled &&
                        button.frame.contains(touchLocation) &&
                        buttonWithTouchOnTop != button
                    {
                        buttonWithTouchOnTop = button
                        showSnackBar(message: button.currentTitle, in: view)
                    }
                }
            }
        default: break
        }
    }
    
}
