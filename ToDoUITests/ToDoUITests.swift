//
//  ToDoUITests.swift
//  ToDoUITests
//
//  Created by Niklas Rammerstorfer on 21.02.18.
//  Copyright © 2018 Niklas Rammerstorfer. All rights reserved.
//

import XCTest

class ToDoUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        
        let app = XCUIApplication()
        app.navigationBars["ToDo.ItemListView"].buttons["Add"].tap()
        
        let callMomTextField = app.textFields["Call Mom"]
        callMomTextField.tap()
        callMomTextField.typeText("Call Mom")
        
        let textField = app.textFields["29.01.1998"]
        textField.tap()
        textField.typeText("29.01.1998")
        
        let homeTextField = app.textFields["Home"]
        homeTextField.tap()
        homeTextField.typeText("Home")
        
        let adressTextField = app.textFields["Adress"]
        adressTextField.tap()
        adressTextField.typeText("Adress")
        
        let loremIpsumTextField = app.textFields["Lorem Ipsum"]
        loremIpsumTextField.tap()
        loremIpsumTextField.typeText("Lorem Ipsum")
        
        app.buttons["Save"].tap()
        
        XCTAssertTrue(app.staticTexts["Call Mom"].exists)
        XCTAssertTrue(app.staticTexts["29.01.1998"].exists)
        XCTAssertTrue(app.staticTexts["Home"].exists)
    }
    
}
