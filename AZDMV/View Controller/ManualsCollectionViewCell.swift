//
//  ManualsCollectionViewCell.swift
//  AZDMV
//
//  Created by Apollo Zhu on 2/11/18.
//  Copyright © 2016-2020 DMV A-Z. MIT License.
//

import UIKit

class ManualsCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = "ManualsCollectionViewCell"
    @IBOutlet weak var iconLabel: UILabel!
    @IBOutlet weak var sectionTitleStack: UIStackView!
    @IBOutlet weak var sectionTitleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    var subSection: Subsection?

    override func layoutSubviews() {
        layer.cornerRadius = 14
        layer.shadowRadius = 4
        layer.shadowOpacity = 0.2
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: 14).cgPath
        layer.shadowOffset = CGSize(width: 0, height: 5)
        super.layoutSubviews()
    }
}
