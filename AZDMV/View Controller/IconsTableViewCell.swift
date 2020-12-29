//
//  IconsTableViewCell.swift
//  AZDMV
//
//  Created by Apollo Zhu on 12/29/20.
//  Copyright © 2020 DMV A-Z. All rights reserved.
//

import UIKit

class IconsTableViewCell: UITableViewCell {
    @IBOutlet weak var iconName: UILabel!
    @IBOutlet weak var appIcon: UIImageView! {
        didSet {
            guard let appIcon = appIcon else { return }
            appIcon.layer.cornerRadius = 10
            if #available(iOS 13.0, *) {
                appIcon.layer.cornerCurve = .continuous
            }
            if #available(iOS 11.0, *) {
                appIcon.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner,
                                            .layerMinXMinYCorner, .layerMinXMaxYCorner]
            } else {
                appIcon.layer.masksToBounds = true
            }
            if #available(iOS 11.0, *) {
                appIcon.accessibilityIgnoresInvertColors = true
            }
        }
    }
}
