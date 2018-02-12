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
        collectionView?.isDirectionalLockEnabled = true
    }

    // MARK: - Scroll

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(
            self, selector: #selector(orientationDidChange),
            name: .UIDeviceOrientationDidChange, object: nil
        )
        NotificationCenter.default.addObserver(
            self, selector: #selector(orientationDidChange),
            name: .UIApplicationDidChangeStatusBarOrientation, object: nil
        )
    }

    @objc private func orientationDidChange() {
        var direction: UICollectionViewScrollDirection = .vertical
        switch UIApplication.shared.statusBarOrientation {
        case .landscapeLeft, .landscapeRight:
            direction = .horizontal
        default:
            break
        }
        layout.scrollDirection = direction
        layout.itemSize = direction == .vertical ? view.bounds.width : view.bounds.height
        collectionView?.visibleCells.forEach(makeParallel)
    }


    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        orientationDidChange()
    }

    // Make parallax
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let collectionView = collectionView
            , let visibleCells = collectionView.visibleCells as? [ManualsCollectionViewCell]
            else { return }
        for parallaxCell in visibleCells {
            var yOffset = (collectionView.contentOffset.y - parallaxCell.frame.minY) / parallaxCell.iconLabel.frame.height
            if yOffset != 0 { yOffset += CGFloat(sections.count / 2) }
            var xOffset = (collectionView.contentOffset.x - parallaxCell.frame.minX) / parallaxCell.iconLabel.frame.width
            if xOffset != 0 { xOffset += CGFloat(sections.count / 2) }
            parallaxCell.iconLabel.frame = parallaxCell.iconLabel.bounds.offsetBy(dx: xOffset * 20, dy: yOffset * 20)
        }
    }

    private func makeParallel(_ cell: UICollectionViewCell) {
        guard let cell = cell as? ManualsCollectionViewCell else { return }
        cell.sectionTitleLabel.transform = CGAffineTransform(rotationAngle: layout.slantingAngle)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate(alongsideTransition: { _ in
            self.orientationDidChange()
        }, completion: nil)
    }

    // MARK: - UICollectionViewDataSource

    // #warning Incomplete implementation
    let sections = [
        (title: "as", icon: "A"),
        (title: "asga g", icon: "B"),
        (title: "sdg ", icon: "C"),
        (title: "sdfg a", icon: "D"),
        (title: "asdfl", icon: "E"),
        ]

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sections.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ManualsCollectionViewCell.reuseIdentifier, for: indexPath) as? ManualsCollectionViewCell else { return UICollectionViewCell() }
        makeParallel(cell)
        cell.iconLabel.text = sections[indexPath.row].icon
        cell.sectionTitleLabel.text = sections[indexPath.row].title
        let hue : CGFloat = CGFloat(arc4random() % 256) / 256 // use 256 to get full range from 0.0 to 1.0
        let saturation : CGFloat = CGFloat(arc4random() % 128) / 256 + 0.5 // from 0.5 to 1.0 to stay away from white
        let brightness : CGFloat = CGFloat(arc4random() % 128) / 256 + 0.5 // from 0.5 to 1.0 to stay away from black
        cell.contentView.backgroundColor = UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1)
        return cell
    }

    // MARK: - UICollectionViewDelegate
}
