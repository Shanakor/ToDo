//
//  ItemListViewControllerTests.swift
//  ToDoTests
//
//  Created by Niklas Rammerstorfer on 30.01.18.
//  Copyright © 2018 Niklas Rammerstorfer. All rights reserved.
//

import XCTest
@testable import ToDo

class ItemListViewControllerTests: XCTestCase {

    var sut: ItemListViewController!

    override func setUp() {
        super.setUp()

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        sut = storyboard.instantiateViewController(withIdentifier: "ItemListViewController") as! ItemListViewController
        sut.loadViewIfNeeded()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func test_TableView_AfterViewDidLoad_IsNotNil(){
        XCTAssertNotNil(sut.tableView)
    }

    func test_LoadingView_SetsTableViewDataSource(){
        XCTAssertTrue(sut.tableView.dataSource is ItemListDataProvider)
    }

    func test_LoadingView_SetsTableViewDelegate(){
        XCTAssertTrue(sut.tableView.delegate is ItemListDataProvider)
    }

    func test_LoadingView_DataSourceEqualsDelegate(){
        XCTAssertEqual(sut.tableView.dataSource as? ItemListDataProvider, sut.tableView.delegate as? ItemListDataProvider)
    }
}
