//
//  StoryboardTests.swift
//  ToDoTests
//
//  Created by Niklas Rammerstorfer on 20.02.18.
//  Copyright © 2018 Niklas Rammerstorfer. All rights reserved.
//

import XCTest
import UIKit

@testable import ToDo

class StoryboardTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func test_InitialViewController_IsItemListViewController(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)

        let navigationController = storyboard.instantiateInitialViewController() as! UINavigationController
        let rootViewController = navigationController.viewControllers[0]

        XCTAssertTrue(rootViewController is ItemListViewController)
    }
}
