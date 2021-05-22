//
//  WhatsNew.swift
//  AZDMV
//
//  Created by Apollo Zhu on 5/22/21.
//  Copyright © 2021 DMV A-Z. All rights reserved.
//

import UIKit
import Foundation
import WhatsNewKit

// MARK: - What's New

// Initialize WhatsNew
fileprivate let whatsNew = WhatsNew(
    // The Title
    title: NSLocalizedString(
        "WhatsNew.title",
        value: "What's New",
        comment: "Title for What's New screen"
    ),
    // The features you want to showcase
    items: [
        WhatsNew.Item(
            title: NSLocalizedString("WhatsNew.widget.title",
                                     value: "Widget",
                                     comment: "The Apple translation for home screen widgets"),
            subtitle: NSLocalizedString("WhatsNew.widget.subtitle",
                                         value: "Pin questions on your home screen!",
                                         comment: "Description on why they care about widgets."),
            image: #imageLiteral(resourceName: "outline_color_lens_black_24pt")
        ),
    ]
)

fileprivate let whatsNewConfig: WhatsNewViewController.Configuration = {
    // Initialize default Configuration
    var configuration = WhatsNewViewController.Configuration()
    // Customize Configuration to your needs
    configuration.tintColor = .theme
    configuration.apply(animation: .slideUp)
    return configuration
}()

func getWhatsNewViewController() -> WhatsNewViewController? {
    // Initialize WhatsNewVersionStore
    let versionStore: WhatsNewVersionStore = KeyValueWhatsNewVersionStore()

    // Initialize WhatsNewViewController with WhatsNew
    return WhatsNewViewController(
        whatsNew: whatsNew,
        configuration: whatsNewConfig,
        versionStore: versionStore
    )
}
