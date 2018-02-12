//
//  ManualsCollectionViewCell.swift
//  AZDMV
//
//  Created by Apollo Zhu on 2/11/18.
//  Copyright © 2016-2018 DMV A-Z. MIT License.
//

import UIKit
import CollectionViewSlantedLayout

class ManualsCollectionViewCell: CollectionViewSlantedCell {
    static let reuseIdentifier = "ManualsCollectionViewCell"
    @IBOutlet weak var iconLabel: UILabel!
    @IBOutlet weak var sectionTitleLabel: UILabel!
}
