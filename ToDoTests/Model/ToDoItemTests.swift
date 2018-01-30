//
//  ToDoItemTests.swift
//  ToDoTests
//
//  Created by Niklas Rammerstorfer on 30.01.18.
//  Copyright © 2018 Niklas Rammerstorfer. All rights reserved.
//

import XCTest
@testable import ToDo

class ToDoItemTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func test_Init_TakesTitle() {
        let _ = ToDoItem(title: "foo")
    }

    func test_Init_TakesTitleAndDescription() {
        let _ = ToDoItem(title: "foo", itemDescription: "bar")
    }

    func test_Init_WhenGivenTitle_SetsTitle() {
        let item = ToDoItem(title: "foo")

        XCTAssertEqual(item.title, "foo", "should set title")
    }

    func test_Init_WhenGivenDescription_SetsDescription() {
        let item = ToDoItem(title: "", itemDescription: "bar")

        XCTAssertEqual(item.itemDescription, "bar", "should set description")
    }

    func test_Init_WhenGivenLocation_SetsLocation() {
        let location = Location(name: "Foo")
        let item = ToDoItem(title: "", location: location)

        XCTAssertEqual(item.location?.name, location.name, "should set location")
    }

    func test_EqualItems_AreEqual() {
        let first = ToDoItem(title: "foo")
        let second = ToDoItem(title: "foo")

        XCTAssertEqual(first, second)
    }

    func test_Items_WhenLocationDiffers_AreNotEqual() {
        let first = ToDoItem(title: "", location: Location(name: "foo"))
        let second = ToDoItem(title: "", location: Location(name: "bar"))

        XCTAssertNotEqual(first, second)
    }

    func test_Items_WhenOneLocationIsNil_AreNotEqual() {
        var first = ToDoItem(title: "", location: Location(name: "foo"))
        var second = ToDoItem(title: "", location: nil)

        XCTAssertNotEqual(first, second)

        second = ToDoItem(title: "", location: Location(name: "foo"))
        first = ToDoItem(title: "", location: nil)

        XCTAssertNotEqual(first, second)
    }

    func test_Items_WhenTimestampDiffers_AreNotEqual() {
        let first = ToDoItem(title: "", timeStamp: 1.0)
        let second = ToDoItem(title: "", timeStamp: 0.0)

        XCTAssertNotEqual(first, second)
    }

    func test_Items_WhenDescriptionDiffers_AreNotEqual() {
        let first = ToDoItem(title: "", itemDescription: "foo")
        let second = ToDoItem(title: "", itemDescription: "bar")

        XCTAssertNotEqual(first, second)
    }

    func test_Items_WhenTitlesDiffer_AreNotEqual() {
        let first = ToDoItem(title: "foo", itemDescription: "")
        let second = ToDoItem(title: "bar", itemDescription: "")

        XCTAssertNotEqual(first, second)
    }
}
