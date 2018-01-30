//
//  ItemListDataProviderTests.swift
//  ToDoTests
//
//  Created by Niklas Rammerstorfer on 30.01.18.
//  Copyright © 2018 Niklas Rammerstorfer. All rights reserved.
//

import XCTest
@testable import ToDo

class ItemListDataProviderTests: XCTestCase {

    var sut: ItemListDataProvider!
    var tableView: UITableView!

    override func setUp() {
        super.setUp()

        sut = ItemListDataProvider()
        sut.itemManager = ItemManager()
        tableView = UITableView()
        tableView.dataSource = sut
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func test_NumberOfSections_IsTwo(){
        XCTAssertEqual(tableView.numberOfSections, 2)
    }

    func test_NumberOfRows_InSection1_IsToDoCount(){
        sut.itemManager?.add(ToDoItem(title: "foo"))

        XCTAssertEqual(tableView.numberOfRows(inSection: 0), 1)

        sut.itemManager?.add(ToDoItem(title: "bar"))
        tableView.reloadData()

        XCTAssertEqual(tableView.numberOfRows(inSection: 0), 2)
    }

    func test_NumberOfRow_InSection2_IsDoneCount(){
        sut.itemManager?.add(ToDoItem(title: "foo"))
        sut.itemManager?.add(ToDoItem(title: "bar"))
        sut.itemManager?.checkItem(at: 0)

        XCTAssertEqual(tableView.numberOfRows(inSection: 1), 1)

        sut.itemManager?.checkItem(at: 0)
        tableView.reloadData()

        XCTAssertEqual(tableView.numberOfRows(inSection: 1), 2)
    }

    func test_CellForRow_ReturnsItemCell(){
        sut.itemManager?.add(ToDoItem(title: ""))
        tableView.reloadData()

        let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0))

        XCTAssertTrue(cell is ItemCell)
    }
}
