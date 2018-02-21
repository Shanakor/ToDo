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
        sut.removeAll()
        sut = nil

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

    func test_ItemAt_ZeroItems_ReturnsNil(){
        let returnedItem = sut.item(at: 0)

        XCTAssertNil(returnedItem)
    }

    func test_ItemAt_IndexOutOfRange_ReturnsNil(){
        sut.add(ToDoItem(title: ""))

        XCTAssertNil(sut.item(at: 1))
    }

    func test_CheckItemAt_ZeroItems_DoesNotCrash(){
        sut.checkItem(at: 0)
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

    func test_UncheckItemAt_ZeroItems_DoesNotCrash(){
        sut.unCheckItem(at: 0)
    }

    func test_UnCheckItemAt_ChangesCounts(){
        sut.add(ToDoItem(title: ""))

        sut.checkItem(at: 0)
        sut.unCheckItem(at: 0)

        XCTAssertEqual(sut.toDoCount, 1, "should increase todoCount")
        XCTAssertEqual(sut.doneCount, 0, "should decrease doneCount")
    }

    func test_UnCheckItemAt_RemovesItemFromDoneItems(){
        sut.add(ToDoItem(title: "first"))
        let item2 = ToDoItem(title: "second")

        sut.add(item2)
        sut.checkItem(at: 0)
        sut.checkItem(at: 0)
        sut.unCheckItem(at: 0)

        XCTAssertEqual(sut.doneItem(at: 0), item2)
    }

    func test_DoneItemAt_ZeroItems_ReturnsNil(){
        XCTAssertNil(sut.doneItem(at: 0))
    }

    func test_DoneItemAt_IndexOutOfRange_ReturnsNil(){
        sut.add(ToDoItem(title: ""))
        sut.checkItem(at: 0)

        XCTAssertNil(sut.doneItem(at: 1))
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

    func test_ApplicationWillResignActive_ToDoItemsGetSerialized(){
        var itemManager: ItemManager? = ItemManager()
        let item1 = ToDoItem(title: "first")
        let item2 = ToDoItem(title: "second")
        itemManager!.add(item1)
        itemManager!.add(item2)

        NotificationCenter.default.post(name: .UIApplicationWillResignActive, object: nil)
        itemManager = nil

        XCTAssertNil(itemManager)

        itemManager = ItemManager()
        XCTAssertEqual(itemManager!.toDoCount, 2)
        XCTAssertEqual(itemManager!.item(at: 0), item1)
        XCTAssertEqual(itemManager!.item(at: 1), item2)
    }

    func test_ApplicationWillResignActive_DoneItemsGetSerialized(){
        var itemManager: ItemManager? = ItemManager()
        let item1 = ToDoItem(title: "first")
        let item2 = ToDoItem(title: "second")
        itemManager!.add(item1)
        itemManager!.add(item2)

        itemManager!.checkItem(at: 0)
        itemManager!.checkItem(at: 0)

        NotificationCenter.default.post(name: .UIApplicationWillResignActive, object: nil)
        itemManager = nil

        XCTAssertNil(itemManager)

        itemManager = ItemManager()
        XCTAssertEqual(itemManager!.doneCount, 2)
        XCTAssertEqual(itemManager!.doneItem(at: 0), item1)
        XCTAssertEqual(itemManager!.doneItem(at: 1), item2)
    }
}
