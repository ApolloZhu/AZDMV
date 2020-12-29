//
//  IconsTableViewController.swift
//  AZDMV
//
//  Created by Apollo Zhu on 12/29/20.
//  Copyright © 2020 DMV A-Z. All rights reserved.
//

import UIKit
import DZNEmptyDataSet

class IconsTableViewController: UITableViewController, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    let icons: [String] = [
        NSLocalizedString(
            "AppIcon.manual.name",
            value: "Manual",
            comment: "Name of the default icon."
        ),
        NSLocalizedString(
            "AppIcon.bookmark.name",
            value: "Bookmark",
            comment: "Name of the icon with bookmark on top right."
        ),
        NSLocalizedString(
            "AppIcon.az.name",
            value: "A-Z",
            comment: "Name of the icon with Apollo Zhu's theme colors. However, you should translate this as if it only means 'A to Z'."
        ),
    ]
    let iconFileNames: [String?] = [nil, "Bookmark", "A-Z"]

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        if #available(iOS 10.3, *){
            return 1
        }
        return 0 // can't do this
    }

    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        return NSAttributedString(string: NSLocalizedString(
            "AppIcon.notAvailable.title",
            value: "Feature NOT available",
            comment: "Title when custom icons are not available."
        ))
    }

    func description(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        return NSAttributedString(string: NSLocalizedString(
            "AppIcon.notAvailable.description",
            value: "Your iOS version doesn't support custom icons.",
            comment: "Description for why custom icons are not available."
        ))
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return icons.count
    }

    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! IconsTableViewCell

        let iconName = icons[indexPath.row]
        cell.iconName.text = iconName
        cell.accessibilityValue = iconName
        cell.accessibilityLabel = NSLocalizedString(
            "AppIcon.accessibility.label",
            value: "App icon choice",
            comment: "Accessibility label for custom icon choice."
        )

        let iconFileName = iconFileNames[indexPath.row]
        cell.appIcon.image = UIImage(named: iconFileName ?? "Manual")
        if #available(iOS 10.3, *), iconFileName == UIApplication.shared.alternateIconName {
            cell.accessoryType = .checkmark
            cell.isSelected = true
            cell.accessibilityTraits = [.button, .selected]
        } else {
            cell.accessoryType = .none
            cell.isSelected = false
            cell.accessibilityTraits = [.button]
        }
        return cell
    }


    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if #available(iOS 10.3, *) {
            UIApplication.shared.setAlternateIconName(iconFileNames[indexPath.row]) { (error) in
                tableView.reloadData()
                guard let error = error else { return }
                dump(error)
            }
        }
    }
}
