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
    var controller: ItemListViewController!

    override func setUp() {
        super.setUp()

        sut = ItemListDataProvider()
        sut.itemManager = ItemManager()

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        controller = storyboard.instantiateViewController(withIdentifier: "ItemListViewController") as! ItemListViewController
        controller.loadViewIfNeeded()

        tableView = controller.tableView
        tableView.dataSource = sut
        tableView.delegate = sut
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

    func test_CellForRow_DequeuesCellFromTableView(){
        let mockTableView = MockTableView.mockTableView(withDataSource: sut)

        sut.itemManager?.add(ToDoItem(title: ""))
        mockTableView.reloadData()

        _ = mockTableView.cellForRow(at: IndexPath(row: 0, section: 0))

        XCTAssertTrue(mockTableView.cellGotDequeued)
    }

    func test_CellForRow_CallsConfigCell(){
        let mockTableView = MockTableView.mockTableView(withDataSource: sut)
        let item = ToDoItem(title: "foo")

        sut.itemManager?.add(item)
        mockTableView.reloadData()

        let cell = mockTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! MockItemCell

        XCTAssertEqual(cell.caughtItem, item)
    }

    func test_CellForRow_InSection2_CallsConfigCellWithDoneItem(){
        let mockTableView = MockTableView.mockTableView(withDataSource: sut)

        sut.itemManager?.add(ToDoItem(title: "foo"))

        let item = ToDoItem(title: "bar")
        sut.itemManager?.add(item)
        sut.itemManager?.checkItem(at: 1)
        mockTableView.reloadData()

        let cell = mockTableView.cellForRow(at: IndexPath(row: 0, section: 1)) as! MockItemCell

        XCTAssertEqual(cell.caughtItem, item)
    }

    func test_DeleteButton_InFirstSection_ShowsTitleCheck(){
        let deleteButtonTitle = tableView.delegate?.tableView?(tableView,
                titleForDeleteConfirmationButtonForRowAt: IndexPath(row: 0, section: 0))

        XCTAssertEqual(deleteButtonTitle, "Check")
    }

    func test_DeleteButton_InSecondSection_ShowsTitleUncheck(){
        let deleteButtonTitle = tableView.delegate?.tableView?(tableView,
                titleForDeleteConfirmationButtonForRowAt: IndexPath(row: 0, section: 1))

        XCTAssertEqual(deleteButtonTitle, "Uncheck")
    }
}

extension ItemListDataProviderTests{

    class MockTableView: UITableView{
        var cellGotDequeued = false

        override func dequeueReusableCell(withIdentifier identifier: String, for indexPath: IndexPath) -> UITableViewCell {
            cellGotDequeued = true

            return super.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        }

        class func mockTableView(withDataSource dataSource: UITableViewDataSource) -> MockTableView{
            let mockTableView = MockTableView(
                    frame: CGRect(x: 0, y:0, width: 320, height: 480),
                    style: .plain)

            mockTableView.dataSource = dataSource
            mockTableView.register(MockItemCell.self, forCellReuseIdentifier: "ItemCell")

            return mockTableView
        }
    }

    class MockItemCell: ItemCell{
        var caughtItem: ToDoItem?

        override func configCell(with item: ToDoItem){
            caughtItem = item
        }
    }
}
