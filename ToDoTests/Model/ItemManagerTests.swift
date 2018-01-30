//
//  ItemManagerTests.swift
//  ToDoTests
//
//  Created by Niklas Rammerstorfer on 30.01.18.
//  Copyright © 2018 Niklas Rammerstorfer. All rights reserved.
//

import XCTest
@testable import ToDo

class ItemManagerTests: XCTestCase {

    var sut: ItemManager!

    override func setUp() {
        super.setUp()

        sut = ItemManager()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func test_ToDoCount_Initially_IsZero(){
        XCTAssertEqual(sut.toDoCount, 0)
    }

    func test_DoneCount_Initially_IsZero(){
        XCTAssertEqual(sut.doneCount, 0)
    }

    func test_AddItem_IncreasesTodoCountToOne(){
        sut.add(ToDoItem(title: ""))

        XCTAssertEqual(sut.toDoCount, 1)
    }

    func test_ItemAt_ReturnsAddedItem(){
        let item = ToDoItem(title: "")
        sut.add(item)

        let returnedItem = sut.item(at: 0)

        XCTAssertEqual(returnedItem, item)
    }

    func test_CheckItemAt_ChangesCounts(){
        sut.add(ToDoItem(title: ""))

        sut.checkItem(at: 0)

        XCTAssertEqual(sut.toDoCount, 0, "should decrease toDoCount")
        XCTAssertEqual(sut.doneCount, 1, "should increase doneCount")
    }

    func test_CheckItemAt_RemovesItemFromToDoItems(){
        sut.add(ToDoItem(title: "first"))
        let item2 = ToDoItem(title: "second")

        sut.add(item2)
        sut.checkItem(at: 0)

        XCTAssertEqual(sut.item(at: 0), item2)
    }

    func test_DoneItemAt_ReturnsCheckedItem(){
        let item = ToDoItem(title: "foo")
        sut.add(item)

        sut.checkItem(at: 0)
        let doneItem = sut.doneItem(at: 0)

        XCTAssertEqual(doneItem, item)
    }

    func test_RemoveAll_ResultsInCountsBeZero(){
        sut.add(ToDoItem(title: "foo"))
        sut.add(ToDoItem(title: "bar"))
        sut.checkItem(at: 0)

        XCTAssertEqual(sut.toDoCount, 1)
        XCTAssertEqual(sut.doneCount, 1)

        sut.removeAll()

        XCTAssertEqual(sut.toDoCount, 0)
        XCTAssertEqual(sut.doneCount, 0)
    }

    func test_Add_WhenItemIsAlreadyAdded_DoesNotIncreaseCount(){
        sut.add(ToDoItem(title: "foo"))
        sut.add(ToDoItem(title: "foo"))

        XCTAssertEqual(sut.toDoCount, 1)
    }
}
