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

    func test_LoadingView_SetsItemManagerToDataProvider(){
        XCTAssertTrue(sut.itemManager === sut.dataProvider.itemManager)
    }

    func test_ItemListViewController_HasAddBarButtonWithSelfAsTarget(){
        let target = sut.navigationItem.rightBarButtonItem?.target

        XCTAssertEqual(target as? UIViewController, sut)
    }

    func test_AddItem_PresentsAddItemViewController(){
        guard tryClickAddButton() else{
            XCTFail(); return
        }

        XCTAssertNotNil(sut.presentedViewController, "You need to present a ViewController after the 'add' button was tapped.")
        XCTAssertTrue(sut.presentedViewController is InputViewController, "You need to present an \(InputViewController.self) after the 'add' button was tapped.")
        XCTAssertNotNil((sut.presentedViewController as! InputViewController).titleTextField, "Instantiate presented ViewController using the storyboard")
    }

    func test_ItemListVC_SharesItemManagerWithInputVC(){
        guard tryClickAddButton() else{
            XCTFail(); return
        }
        guard let inputViewController = sut.presentedViewController as? InputViewController else{
            XCTFail(); return
        }
        guard let inputItemManger = inputViewController.itemManager else{
            XCTFail(); return
        }

        XCTAssertTrue(inputItemManger === sut.itemManager)
    }

    func test_TableView_OnViewWillAppear_ReloadsData(){
        let mockTableView = MockTableView()
        sut.tableView = mockTableView

        sut.beginAppearanceTransition(true, animated: false)
        sut.endAppearanceTransition()

        XCTAssertTrue(mockTableView.reloadDataGotCalled)
    }

    private func tryClickAddButton() -> Bool {
        UIApplication.shared.keyWindow?.rootViewController = sut
        XCTAssertNil(sut.presentedViewController, "You should not be able to press the add button, while a ViewController is presented.")

        guard let addButton = sut.navigationItem.rightBarButtonItem else{
            return false
        }

        guard let action = addButton.action else{
            return false
        }

        sut.performSelector(onMainThread: action, with: addButton, waitUntilDone: true)

        return true
    }
}

extension ItemListViewControllerTests{
    class MockTableView: UITableView{
        var reloadDataGotCalled = false

        override func reloadData() {
            reloadDataGotCalled = true
        }
    }
}
