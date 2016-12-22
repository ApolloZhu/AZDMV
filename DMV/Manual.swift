//
//  Library.swift
//  DMV
//
//  Created by Apollo Zhu on 12/21/16.
//  Copyright © 2016 WWITDC. All rights reserved.
//

import SwiftyJSON

let manual = Manual.shared
open class Manual {
    public static let shared = Manual()

    private var contents: JSON
    private(set) public var sections = [String]()
    private var noQuiz = [String]()
    private(set) public var subsections = [[SubSection]]()

    private init(){
        contents = JSON(data: try! Data(contentsOf: Bundle.main.url(forResource: "manual", withExtension: "json")!))
        noQuiz.append(contentsOf: contents[2]["manualData"][0]["noQuiz"].arrayObject as! [String])
        for i in 0..<contents[2]["manualData"][0]["totalSections"].intValue {
            let section = contents[2]["manualData"][0]["sections"][i]
            sections.append("\(symbol(named: section["symbol"].stringValue)) \(section["sectionTitle"])")
        }
        for i in 1...sections.count {
            let subCount = contents.filter { (_, json) in json["section"].intValue == i }.count
            subsections.append((1...subCount).map{ subSection($0, ofSection: i)! })
        }
    }

    private func symbol(named name: String) -> String {
        switch name {
        case "edit": return "\u{f044}"
        case "signIcon": return "\u{e606}"
        case "steeringWheel": return "\u{e603}"
        case "seatBelt": return "\u{e607}"
        case "exclamation-circle": return "\u{f06a}"
        case "license": return "\u{e611}"
        case "info": return "\u{f129}"
        default: return ""
        }
    }

    private func subSection(_ id: Int, ofSection sectionID: Int) -> SubSection? {
        for (_, subJSON) in contents {
            let section = subJSON["section"].intValue
            let subSection = subJSON["subSectionID"].intValue
            if section == sectionID && subSection == id {
                return SubSection(
                    title: subJSON["subSectionTitle"].stringValue,
                    content: subJSON["copy"].stringValue,
                    section: sectionID,
                    subSection: id,
                    updateTime: subJSON["update"].stringValue,
                    hasQuiz: !noQuiz.contains("\(sectionID).\(id)")
                )
            }
        }
        return nil
    }
}

extension Manual: CustomStringConvertible {
    public var description: String {
        return "Virginia DMV Driver's Manual"
    }
}

extension Manual {
    open class SubSection {
        open let title: String // subSectionTitle
        open let content: String // copy
        open let sectionID: Int // section
        open let subSectionID: Int // subSectionID
        open let updateTime: String // update
        open let hasQuiz: Bool // calculated

        init(title: String, content: String, section: Int, subSection: Int, updateTime: String, hasQuiz: Bool = true) {
            self.title = title
            self.content = content
            self.sectionID = section
            self.subSectionID = subSection
            self.updateTime = updateTime
            self.hasQuiz = hasQuiz
        }
    }
}
