//
//  Library.swift
//  DMV
//
//  Created by Apollo Zhu on 12/21/16.
//  Copyright © 2016 WWITDC. All rights reserved.
//

import SwiftyJSON

open class Manual {
    public static let shared = Manual()
    private init(){}

    private lazy var symbol: [String:String] = [
        "edit": "\u{f044}",
        "signIcon": "\u{e606}",
        "steeringWheel": "\u{e603}",
        "seatBelt": "\u{e607}",
        "exclamation-circle": "\u{f06a}",
        "license": "\u{e611}",
        "info" : "\u{f129}"
    ]

    private lazy var _contents: JSON = {
        return JSON(data: try! Data(contentsOf: Bundle.main.url(forResource: "manual", withExtension: "json")!))
    }()
    public lazy var sections: [String] = {
        var secs = [String]()
        // For all sections
        for i in 0..<self._contents[2]["manualData"][0]["totalSections"].intValue {
            // Get section JSON data
            let section = self._contents[2]["manualData"][0]["sections"][i]
            // Get section title with image(icon in font)
            secs.append("\(self.symbol[section["symbol"].stringValue] ?? "") \(section["sectionTitle"])")
        }
        return secs
    }()
    public lazy var subsections: [[SubSection]] = {
        var subsecs = [[SubSection]]()
        // For each section
        for i in 1...self.sections.count {
            // Count subsections
            let subCount = self._contents.lazy.filter { $0.1["section"].intValue == i }.count
            // Add subsection data in ascending order
            subsecs.append((1...subCount).lazy.map { self.subSection($0, ofSection: i)! })
        }
        return subsecs
    }()
    fileprivate lazy var _noQuiz: [String] = {
        // Subsections without quiz
        return self._contents[2]["manualData"][0]["noQuiz"].arrayObject as! [String]
    }()

    private func subSection(_ subSectionID: Int, ofSection sectionID: Int) -> SubSection? {
        for (_, subJSON) in _contents.lazy {
            let section = subJSON["section"].intValue
            let subSection = subJSON["subSectionID"].intValue
            if section == sectionID && subSection == subSectionID {
                return SubSection(
                    title: subJSON["subSectionTitle"].stringValue,
                    content: subJSON["copy"].stringValue,
                    sectionID: sectionID,
                    subSectionID: subSectionID,
                    updateTime: subJSON["update"].stringValue
                )
            }
        }
        return nil
    }
}

extension Manual: CustomStringConvertible {
    public var description: String {
        return NSLocalizedString("Virginia DMV Driver's Manual", comment: "Name for the driver's manual in VA, US")
    }
}

extension Manual {
    public struct SubSection {
        public let title: String
        public let content: String
        public let sectionID: Int
        public let subSectionID: Int
        public let updateTime: String
        public var hasQuiz: Bool {
            return !Manual.shared._noQuiz.contains("\(sectionID).\(subSectionID)")
        }
    }
}
