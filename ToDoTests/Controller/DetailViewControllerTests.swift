//
//  DetailViewControllerTests.swift
//  ToDoTests
//
//  Created by Niklas Rammerstorfer on 30.01.18.
//  Copyright © 2018 Niklas Rammerstorfer. All rights reserved.
//

import XCTest
import CoreLocation

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

    func test_SettingItemInfo_SetsTitleLabelText(){
        setItemInfo(with: ToDoItem(title: "foo"))

        XCTAssertEqual(sut.titleLabel.text, "foo")
    }

    private func setItemInfo(with item: ToDoItem){
        let itemManager = ItemManager()
        itemManager.add(item)

        sut.itemInfo = (itemManager, 0)

        sut.beginAppearanceTransition(true, animated: false)
        sut.endAppearanceTransition()
    }

    func test_SettingItemInfo_SetsDateLabelText(){
        let date = Date(timeIntervalSince1970: 1456150025)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        let dateString = dateFormatter.string(from: date)

        setItemInfo(with: ToDoItem(title: "", timeStamp: 1456150025))

        XCTAssertEqual(sut.dateLabel.text, dateString)
    }

    func test_SettingItemInfo_SetsLocationLabelText(){
        let loc = Location(name: "Steyr")

        setItemInfo(with: ToDoItem(title: "", location: loc))

        XCTAssertEqual(sut.locationLabel.text, loc.name)
    }

    func test_SettingItemInfo_SetsDescriptionLabelText(){
        setItemInfo(with: ToDoItem(title: "", itemDescription: "foo bar"))

        XCTAssertEqual(sut.descriptionLabel.text, "foo bar")
    }

    func test_SettingItemInfo_SetsMapViewCenterCoordinate(){
        let location = Location(name: "foo", coordinate: CLLocationCoordinate2D(latitude: 51.2277, longitude: 6.7735))

        setItemInfo(with: ToDoItem(title: "", location: location))

        XCTAssertEqual(sut.mapView.centerCoordinate.latitude, 51.2277, accuracy: 0.001)
        XCTAssertEqual(sut.mapView.centerCoordinate.longitude, 6.7735, accuracy: 0.001)
    }

    func test_CheckItem_ChecksItemInItemManager(){
        let itemManager = ItemManager()
        itemManager.add(ToDoItem(title: "foo"))

        sut.itemInfo = (itemManager, 0)
        sut.checkItem()

        XCTAssertEqual(itemManager.toDoCount, 0, "should update todo count")
        XCTAssertEqual(itemManager.doneCount, 1, "should update done count")
    }
}
