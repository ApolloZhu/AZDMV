//
//  Extension.swift
//  DMV
//
//  Created by Apollo Zhu on 12/21/16.
//  Copyright © 2016 WWITDC. All rights reserved.
//

import UIKit

extension UIStoryboardSegue {
    var terminus: UIViewController {
        return (destination as? UINavigationController)?.visibleViewController ?? destination
    }
}

extension URL {
    init?(dmvImageName name: String?) {
        if let imageName = name, !imageName.isEmpty {
            self.init(string: "https://dmvstore.blob.core.windows.net/manuals/images/1/\(imageName)")
        } else {
            return nil
        }
    }
}

extension UIControlState {
    public static var all: UIControlState {
        return UIControlState()
    }
}

let dmvLogo = UIImage(named: "dmvLogo.png")
