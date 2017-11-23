//
//  RootViewController.swift
//  AZDMV-tvOS
//
//  Created by Apollo Zhu on 6/10/17.
//  Copyright © 2017 WWITDC. All rights reserved.
//

import UIKit

class RootViewController: UISplitViewController {

    static var current: RootViewController!

    override func viewDidLoad() {
        super.viewDidLoad()
        preferredPrimaryColumnWidthFraction = 0.5
        RootViewController.current = self
    }

    var quizViewController: QuizViewController! {
        return viewControllers.first as? QuizViewController
    }

    var topMostNavigator: UIViewController! {
        return viewControllers.last
    }

}
