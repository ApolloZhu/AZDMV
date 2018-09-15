//
//  ManualsCollectionViewController.swift
//  AZDMV
//
//  Created by Apollo Zhu on 2/11/18.
//  Copyright © 2016-2018 DMV A-Z. MIT License.
//

import UIKit

let manual = TableOfContents.fetch(from: .bundled)?.manuals.first

class ManualsCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    let sections = manual?.sections ?? []

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width
        let height = collectionView.bounds.height
        if height > width {
            return CGSize(width: width - 20, height: 100)
        } else {
            return CGSize(width: width / 2 - 20, height: 100)
        }
    }

    // MARK: - UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sections.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ManualsCollectionViewCell.reuseIdentifier, for: indexPath) as? ManualsCollectionViewCell else { return UICollectionViewCell() }
        cell.iconLabel.text = sections[indexPath.row].symbol
        cell.sectionTitleLabel.text = sections[indexPath.row].title
        let range: UInt32 = 118 - 47
        let hue = CGFloat(arc4random() % range) / 256 + 47 / 256
        let saturation = CGFloat(arc4random() % 128) / 256 + 0.5 // stay away from white
        let brightness = CGFloat(arc4random() % 128) / 256 + 0.5 // stay away from black
        cell.contentView.backgroundColor = UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1)
        return cell
    }

    // MARK: - Collection view delegate
}
