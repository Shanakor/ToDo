//
//  ItemCellTests.swift
//  ToDoTests
//
//  Created by Niklas Rammerstorfer on 30.01.18.
//  Copyright © 2018 Niklas Rammerstorfer. All rights reserved.
//

import XCTest
import UIKit
@testable import ToDo

class ItemCellTests: XCTestCase {

    var tableView: UITableView!
    var dataSource: FakeDataSource!
    var cell: ItemCell!

    override func setUp() {
        super.setUp()

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "ItemListViewController") as! ItemListViewController
        controller.loadViewIfNeeded()

        tableView = controller.tableView
        tableView.dataSource = FakeDataSource()

        cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: IndexPath(row: 0, section: 0)) as! ItemCell
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func test_HasNameLabel(){
        XCTAssertTrue(cell.titleLabel.isDescendant(of: cell.contentView))
    }

    func test_HasLocationLabel(){
        XCTAssertTrue(cell.locationLabel.isDescendant(of: cell.contentView))
    }

    func test_HasDateLabel(){
        XCTAssertTrue(cell.dateLabel.isDescendant(of: cell.contentView))
    }
}

extension ItemCellTests{

    class FakeDataSource: NSObject, UITableViewDataSource{
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return 1
        }

        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            return UITableViewCell()
        }
    }
}
