//
//  AZDMV_UITests.swift
//  AZDMV-UITests
//
//  Created by Apollo Zhu on 1/12/19.
//  Copyright © 2019 DMV A-Z. All rights reserved.
//

import XCTest

class AZDMV_UITests: XCTestCase {

    /// Put setup code here. This method is called before the invocation of each test method in the class.
    override func setUp() {
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    /// Put teardown code here. This method is called after the invocation of each test method in the class.
    override func tearDown() {
    }

    /// Use recording to get started writing UI tests.
    /// Use XCTAssert and related functions to verify your tests produce the correct results.
    func testExample() {
        let app = XCUIApplication()
        saveScreenshot(withName: "Manuals Collection View")
        
        let subsection = app.collectionViews.tables.cells.staticTexts["5.1 Penalties"]
        app.collectionViews.element(boundBy: 0).scrollToElement(subsection)
        subsection.tap()
        sleep(30)
        saveScreenshot(withName: "Manual Section Web View")
        app.navigationBars["5.1 Penalties"].buttons["Manuals"].tap()
        
        XCUIApplication().tabBars.buttons["Quiz"].tap()
        saveScreenshot(withName: "Quizzes Table View")
        
        let q1502 = app.tables.cells.containing(.staticText, identifier:"1502").element(boundBy: 0)
        app.tables.element(boundBy: 0).scrollToElement(q1502)
        q1502.tap()
        app.tables.staticTexts["Reduce your speed."].tap()
        app.buttons["Try Aagain"].tap()
        app.tables.staticTexts["Come to a complete stop."].tap()
        app.otherElements["Close"].tap()
        saveScreenshot(withName: "Quiz Completion")
        
        app.tables.children(matching: .cell).element(boundBy: 4).swipeLeft()
        app.tables.staticTexts["Do not enter."].tap()
        saveScreenshot(withName: "Wrong Answer")
        app.buttons["Try Aagain"].tap()
        
        app.tables.children(matching: .cell).element(boundBy: 4).swipeLeft()
        app.tables.staticTexts["Special conditions or hazards ahead."].tap()
        saveScreenshot(withName: "Right Answer")
        app.otherElements["Close"].tap()
    }
    
    private static var screenshotID = 0
    private static let lock = NSLock()
    
    private func saveScreenshot(withName name: String? = nil) {
        let screenshot = XCUIScreen.main.screenshot()
        let attachment = XCTAttachment(screenshot: screenshot)
        attachment.lifetime = .keepAlways
        if let name = name {
            attachment.name = name
        } else {
            AZDMV_UITests.lock.lock()
            attachment.name = "\(AZDMV_UITests.screenshotID)"
            AZDMV_UITests.screenshotID += 1
            AZDMV_UITests.lock.unlock()
        }
        add(attachment)
    }
}

extension XCUIElement {
    func scrollToElement(_ element: XCUIElement) {
        while !element.isVisible {
            swipeUp()
        }
    }
    
    var isVisible: Bool {
        return exists && !frame.isEmpty &&
            XCUIApplication().windows.element(boundBy: 0).frame.contains(frame)
    }
}
