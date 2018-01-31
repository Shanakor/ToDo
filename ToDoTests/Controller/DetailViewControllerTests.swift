//
//  DetailViewControllerTests.swift
//  ToDoTests
//
//  Created by Niklas Rammerstorfer on 30.01.18.
//  Copyright © 2018 Niklas Rammerstorfer. All rights reserved.
//

import XCTest
@testable import ToDo

class DetailViewControllerTests: XCTestCase {

    var sut: DetailViewController!

    override func setUp() {
        super.setUp()

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        sut = storyboard.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        sut.loadViewIfNeeded()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func test_HasTitleLabel(){
        XCTAssertTrue(sut.titleLabel.isDescendant(of: sut.view))
    }

    func test_HasDateLabel(){
        XCTAssertTrue(sut.dateLabel.isDescendant(of: sut.view))
    }

    func test_HasLocationLabel(){
        XCTAssertTrue(sut.locationLabel.isDescendant(of: sut.view))
    }

    func test_HasDescriptionLabel(){
        XCTAssertTrue(sut.descriptionLabel.isDescendant(of: sut.view))
    }

    func test_HasMapView(){
        XCTAssertTrue(sut.mapView.isDescendant(of: sut.view))
    }

    func test_HasCheckButton(){
        XCTAssertTrue(sut.checkButton.isDescendant(of: sut.view))
    }
}
