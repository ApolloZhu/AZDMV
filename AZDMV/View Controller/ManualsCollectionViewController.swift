//
//  ManualsCollectionViewController.swift
//  AZDMV
//
//  Created by Apollo Zhu on 2/11/18.
//  Copyright © 2016-2019 DMV A-Z. MIT License.
//

import UIKit
import WhatsNew
import CHTCollectionViewWaterfallLayout

let manual = TableOfContents.fetch(from: .bundled)?.manuals.first
let subsections = fetchAllSubsections(from: .bundled, in: manual) ?? []

class ManualsCollectionViewController: UICollectionViewController, CHTCollectionViewDelegateWaterfallLayout, UITableViewDelegate, UITableViewDataSource {

    private var layout: CHTCollectionViewWaterfallLayout {
        return collectionViewLayout as! CHTCollectionViewWaterfallLayout
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        whatsNew.presentIfNeeded(on: self)
        if #available(iOS 11, *) {
            layout.sectionInsetReference = .fromSafeArea
        }
        layout.minimumColumnSpacing = 20
        layout.minimumInteritemSpacing = 20
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }

    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return subsections[tableView.tag].count
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SubSectionTableViewCell", for: indexPath)
        let text = subsections[tableView.tag][indexPath.row].name
        cell.accessibilityValue = text
        cell.textLabel?.text = text
        return cell
    }

    let sections = manual?.sections ?? []

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellHeight = 110 + 44 * subsections[indexPath.row].count
        return CGSize(width: 0, height: CGFloat(cellHeight))
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        columnCountFor section: Int) -> Int {
        switch traitCollection.horizontalSizeClass {
        case .regular:
            if #available(iOS 11.0, *),
               traitCollection.preferredContentSizeCategory.isAccessibilityCategory {
                return 1
            }
            return 2
        case .compact, .unspecified:
            fallthrough
        @unknown default:
            let width = collectionView.bounds.width
            let height = collectionView.bounds.height
            return height > width ? 1 : 2
        }
    }

    // MARK: - UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int {
        return sections.count
    }

    override func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ManualsCollectionViewCell.reuseIdentifier, for: indexPath) as! ManualsCollectionViewCell
        cell.iconLabel.text = sections[indexPath.row].symbol.text
        cell.sectionTitleLabel.text = sections[indexPath.row].title
        cell.tableView.tag = indexPath.row
        cell.tableView.delegate = self
        cell.tableView.dataSource = self
        cell.tableView.reloadData()
        let color = sections[indexPath.row].symbol.color
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

// MARK: - What's New

var whatsNew: WhatsNewViewController = {
    let controller = WhatsNewViewController(items: [
        WhatsNewItem.image(
            title: NSLocalizedString(
                "WhatsNew.redesign.title",
                value: "Dark Mode",
                comment: "Dark Mode as in the system feature"),
            subtitle: NSLocalizedString(
                "WhatsNew.redesign.content",
                value: "We updated for the new system designs.",
                comment: "Short description for the redesign"),
            image: #imageLiteral(resourceName: "outline_color_lens_black_24pt")),
        WhatsNewItem.image(
            title: NSLocalizedString(
                "WhatsNew.privacy.title",
                value: "Privacy Policy",
                comment: "The legal term"),
            subtitle: NSLocalizedString(
                "WhatsNew.privacy.content",
                value: "I don't need your data, so nothing is collected.",
                comment: "Short description for privacy policy update"),
            image: #imageLiteral(resourceName: "outline_language_black_24pt")),
    ])
    controller.titleText = NSLocalizedString(
        "WhatsNew.title",
        value: "What's New",
        comment: "Title for What's New screen"
    )
    controller.buttonText = NSLocalizedString(
        "WhatsNew.continue",
        value: "Continue",
        comment: "Continue to use ap from What's New"
    )
    controller.buttonTextColor = .white
    controller.buttonBackgroundColor = .theme
    return controller
}()
