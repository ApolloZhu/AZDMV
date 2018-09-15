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
            return CGSize(width: width / 2 - 60, height: 100)
        }
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: { _ in }) { [weak self] _ in
            self?.collectionViewLayout.invalidateLayout()
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
        let color = UIColor(
            hue: .random(in: 0...1),
            saturation: .random(in: 0.5...1), // stay away from white
            brightness: .random(in: 0.5...1), // stay away from black
            alpha: 1
        )
        cell.iconLabel.textColor = color
        cell.sectionTitleLabel.textColor = color
        cell.layer.shadowColor = color.cgColor
        return cell
    }

    // MARK: - Collection view delegate
}
