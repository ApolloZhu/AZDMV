//
//  SettingsTableViewController.swift
//  AZDMV
//
//  Created by Apollo Zhu on 2/11/18.
//  Copyright © 2016-2020 DMV A-Z. MIT License.
//

import UIKit
import AcknowList

class SettingsTableViewController: UITableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.async {
            preloadAcknowledgementsViewController()
        }
    }

    override func tableView(_ tableView: UITableView,
                            didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 1:
            switch indexPath.row {
            case 0:
                show(acknowledgementsViewController, sender: self)
            default:
                break
            }
        default:
            break
        }
    }
}

public func preloadAcknowledgementsViewController() {
    _ = acknowledgementsViewController
}

fileprivate let acknowledgementsViewController: AcknowListViewController = {
    let vc: AcknowListViewController
    if #available(iOS 13.0, *) {
        let path = Bundle.main.path(forResource: "Pods-AZDMV-acknowledgements", ofType: "plist")!
        vc = AcknowListViewController(plistPath: path, style: .insetGrouped)
    } else {
        vc = AcknowListViewController()
    }
    vc.acknowledgements += [
        Acknow(title: "Kingfisher",
               text: "https://github.com/onevcat/Kingfisher/blob/master/LICENSE",
               license: "MIT License"),
        Acknow(title: "DZNEmptyDataSet",
               text: "https://github.com/dzenbot/DZNEmptyDataSet/blob/master/LICENSE",
               license: "MIT License"),
        Acknow(title: "WhatsNewKit",
               text: "https://github.com/SvenTiigi/WhatsNewKit/blob/master/LICENSE",
               license: "MIT License"),
        Acknow(title: "AcknowList",
               text: "https://github.com/vtourraine/AcknowList/blob/main/LICENSE.txt",
               license: "MIT License"),
    ]
    vc.acknowledgements.sort { $0.title.localizedCaseInsensitiveCompare($1.title) == .orderedAscending }
    return vc
}()
