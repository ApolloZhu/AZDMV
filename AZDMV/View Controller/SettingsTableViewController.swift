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
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                show(AcknowListViewController(), sender: self)
            default:
                break
            }
        default:
            break
        }
    }
}
