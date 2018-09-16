//
//  ManualsCollectionViewController.swift
//  AZDMV
//
//  Created by Apollo Zhu on 2/11/18.
//  Copyright © 2016-2018 DMV A-Z. MIT License.
//

import UIKit
import WhatsNew

let manual = TableOfContents.fetch(from: .bundled)?.manuals.first
let subsections = fetchAllSubsections(from: .bundled, in: manual) ?? []

class ManualsCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UITableViewDelegate, UITableViewDataSource {
    override func viewDidLoad() {
        super.viewDidLoad()
        WhatsNewViewController(items: [
            WhatsNewItem.image(
                title: NSLocalizedString(
                    "WhatsNew.redesign.title",
                    value: "Better Design",
                    comment: "Short title for redesign"),
                subtitle: NSLocalizedString(
                    "WhatsNew.redesign.content",
                    value: "Carefully crafted for your convinence.",
                    comment: "Short description for redesign"),
                image: #imageLiteral(resourceName: "outline_color_lens_black_24pt")),
            WhatsNewItem.image(
                title: NSLocalizedString(
                    "WhatsNew.languages.title",
                    value: "Many Languages",
                    comment: "Short title for auto translate"),
                subtitle: NSLocalizedString(
                    "WhatsNew.languages.content",
                    value: "Everything is now translated into your language.",
                    comment: "Short description for auto translate"),
                image: #imageLiteral(resourceName: "outline_language_black_24pt")),
            WhatsNewItem.image(
                title: NSLocalizedString(
                    "WhatsNew.manual.title",
                    value: "One more thing...",
                    comment: "Short title for including driver's manual"),
                subtitle: NSLocalizedString(
                    "WhatsNew.manual.content",
                    value: "Driver's Manual and quizzes, 2 in 1.",
                    comment: "Short description for including driver's manual"),
                image: #imageLiteral(resourceName: "ic_school"))
            ]).presentIfNeeded(on: self)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subsections[tableView.tag].count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SubSectionTableViewCell", for: indexPath)
        let subsection = subsections[tableView.tag][indexPath.row]
        cell.textLabel?.text = "\(subsection.section).\(subsection.subSectionID) \(subsection.title)"
        return cell
    }

    let sections = manual?.sections ?? []

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width
        let height = collectionView.bounds.height
        let cellHeight = CGFloat(110 + 44 * subsections[indexPath.row].count)
        if height > width {
            return CGSize(width: width - 20, height: cellHeight)
        } else {
            return CGSize(width: width / 2 - 60, height: cellHeight)
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ManualsCollectionViewCell.reuseIdentifier, for: indexPath) as! ManualsCollectionViewCell
        cell.iconLabel.text = sections[indexPath.row].symbol
        cell.sectionTitleLabel.text = sections[indexPath.row].title
        cell.tableView.tag = indexPath.row
        cell.tableView.delegate = self
        cell.tableView.dataSource = self
        cell.tableView.reloadData()
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


    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ShowSubSectionContent",
                     sender: subsections[tableView.tag][indexPath.row])
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowSubSectionContent",
            let vc = segue.destination as? SubSectionViewController,
            let subSection = sender as? Subsection {
            vc.subSection = subSection
        }
    }
}
