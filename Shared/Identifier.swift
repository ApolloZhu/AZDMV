//
//  Identifier.swift
//  DMV
//
//  Created by Apollo Zhu on 12/21/16.
//  Copyright © 2016 WWITDC. All rights reserved.
//

import Foundation

struct Identifier {
    public static let NoQuizReusableTableViewCell = "No Quiz"
    public static let NormalReusableTableViewCell = "Has Quiz"
    public static let ShowQuestionListSegue = "Show Question List"
    public static let ShowQuizSegue = "Show Quiz"
    public static let ShowAnswersSegue = "To Select Answers"
}

struct Localized {
    public static let NoQuizSelected = NSLocalizedString("<~ Select Quiz Here", comment: "To prompt uesr to select a quiz on the left hand side. For RTL languages, please make the arrow pointing to the right.")
    public static let NoQuizForSection = NSLocalizedString("No quiz for that section", comment: "Tell user that the selected section has no associated quiz")
}
