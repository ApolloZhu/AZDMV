//
//  ManualsCollectionViewController.swift
//  AZDMV
//
//  Created by Apollo Zhu on 2/11/18.
//  Copyright © 2016-2018 DMV A-Z. MIT License.
//

import UIKit
import CollectionViewSlantedLayout

class ManualsCollectionViewController: UICollectionViewController {
    private var layout: CollectionViewSlantedLayout! {
        return collectionViewLayout as? CollectionViewSlantedLayout
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        layout.isFirstCellExcluded = true
        layout.isLastCellExcluded = true
    }

    // #warning Incomplete implementation
    let sections = [
        (title: "as", icon: "A"),
        (title: "asga g", icon: "B"),
        (title: "sdg ", icon: "C"),
        (title: "sdfg a", icon: "D"),
        (title: "asdfl", icon: "E"),
    ]

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sections.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ManualsCollectionViewCell.reuseIdentifier, for: indexPath) as? ManualsCollectionViewCell else { return UICollectionViewCell() }
        cell.sectionTitleLabel.transform = CGAffineTransform(rotationAngle: layout.slantingAngle)
        cell.iconLabel.text = sections[indexPath.row].icon
        cell.sectionTitleLabel.text = sections[indexPath.row].title
        let hue : CGFloat = CGFloat(arc4random() % 256) / 256 // use 256 to get full range from 0.0 to 1.0
        let saturation : CGFloat = CGFloat(arc4random() % 128) / 256 + 0.5 // from 0.5 to 1.0 to stay away from white
        let brightness : CGFloat = CGFloat(arc4random() % 128) / 256 + 0.5 // from 0.5 to 1.0 to stay away from black
        cell.contentView.backgroundColor = UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1)
        return cell
    }

    // MARK: UICollectionViewDelegate

}
