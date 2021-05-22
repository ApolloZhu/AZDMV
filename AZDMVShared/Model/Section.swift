//
//  Section.swift
//  AZDMV
//
//  Created by Apollo Zhu on 2/12/18.
//  Copyright © 2016-2020 DMV A-Z. MIT License.
//

public struct Section: Codable {
    public let symbolID: String
    public let title: String
    public let rawSectionID: String
    enum CodingKeys: String, CodingKey {
        case symbolID = "symbol"
        case rawSectionID = "sectionID"
        case title = "sectionTitle"
    }
}

import UIKit

extension Section {
    public var sectionID: Int {
        return Int(rawSectionID)!
    }

    public var symbol: (text: String, color: UIColor) {
        switch symbolID {
        case "edit": return ("\u{f044}", #colorLiteral(red: 0.01960784314, green: 0.4666666667, blue: 0.2823529412, alpha: 1))
        case "signIcon": return ("\u{e606}", #colorLiteral(red: 0.7647058824, green: 0.1529411765, blue: 0.168627451, alpha: 1))
        case "steeringWheel": return ("\u{e603}", #colorLiteral(red: 0.6588235294, green: 0.2862745098, blue: 0.4784313725, alpha: 1))
        case "seatBelt": return ("\u{e607}", #colorLiteral(red: 0.04705882353, green: 0.537254902, blue: 0.09411764706, alpha: 1))
        case "exclamation-circle": return ("\u{f06a}", #colorLiteral(red: 0.9490196078, green: 0.04705882353, blue: 0, alpha: 1))
        case "license": return ("\u{e611}", #colorLiteral(red: 0.2941176471, green: 0.3607843137, blue: 0.768627451, alpha: 1))
        case "info": return ("\u{f129}", #colorLiteral(red: 0.1803921569, green: 0.662745098, blue: 0.8745098039, alpha: 1))
        default: fatalError(symbolID)
        }
    }
}
