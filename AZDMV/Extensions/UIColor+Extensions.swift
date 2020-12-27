//
//  UIColor+Extensions.swift
//  AZDMV
//
//  Created by Apollo Zhu on 12/27/20.
//  Copyright © 2016-2019 DMV A-Z. MIT License.
//

import UIKit

extension UIColor {
    static let theme: UIColor = {
        if #available(iOS 11.0, *) {
            return UIColor(named: "Accent")!
        } else {
            return #colorLiteral(red: 0, green: 0.4, blue: 0.4, alpha: 1)
        }
    }()
}
