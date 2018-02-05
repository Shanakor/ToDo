//
//  InputViewControllerTests.swift
//  ToDoTests
//
//  Created by Niklas Rammerstorfer on 31.01.18.
//  Copyright © 2018 Niklas Rammerstorfer. All rights reserved.
//

import XCTest
import CoreLocation

@testable import ToDo

class InputViewControllerTests: XCTestCase {

    var sut: InputViewController!
    var placemark: MockPlaceMark!

    override func setUp() {
        super.setUp()

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        sut = storyboard.instantiateViewController(withIdentifier: "InputViewController") as! InputViewController
        sut.loadViewIfNeeded()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func test_HasTitleTextField(){
        XCTAssertTrue(sut.titleTextField.isDescendant(of: sut.view))
    }

    func test_HasDateTextField(){
        XCTAssertTrue(sut.dateTextField.isDescendant(of: sut.view))
    }

    func test_HasLocationTextField(){
        XCTAssertTrue(sut.locationTextField.isDescendant(of: sut.view))
    }

    func test_HasAddressTextField(){
        XCTAssertTrue(sut.addressTextField.isDescendant(of: sut.view))
    }

    func test_HasDescriptionTextField(){
        XCTAssertTrue(sut.descriptionTextField.isDescendant(of: sut.view))
    }

    func test_HasSaveButton(){
        XCTAssertTrue(sut.saveButton.isDescendant(of: sut.view))
    }

    func test_HasCancelButton(){
        XCTAssertTrue(sut.cancelButton.isDescendant(of: sut.view))
    }

    func test_Save_UsesGeocoderToCoordinateFromAddress(){
        // Variables.

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"

        let timeStamp = 1456095600.0
        let date = Date(timeIntervalSince1970: timeStamp)

        sut.titleTextField.text = "foo"
        sut.dateTextField.text = dateFormatter.string(from: date)
        sut.locationTextField.text = "bar"
        sut.addressTextField.text = "Infinite Loop 1, Cubertino"
        sut.descriptionTextField.text = "baz"

        let mockGeoCoder = MockGeoCoder()
        sut.geocoder = mockGeoCoder

        sut.itemManager = ItemManager()

        // Invocation.

        sut.save()

        // Assertion.

        placemark = MockPlaceMark()
        let coordinate = CLLocationCoordinate2D(latitude: 37.3316851,
                longitude: -122.0300674)
        placemark.mockCoordinate = coordinate

        mockGeoCoder.completionHandler?([placemark], nil)

        let item = sut.itemManager?.item(at: 0)

        let testItem = ToDoItem(title: "foo", itemDescription: "baz", timeStamp: timeStamp, location: Location(name: "bar", coordinate: coordinate))

        XCTAssertEqual(item, testItem)
    }

//    func test_Save_GivenTitleOnly_SavesItem(){
//        let item = ToDoItem(title: "foo")
//        sut.titleTextField.text = item.title
//        let itemManager = ItemManager()
//        sut.itemManager = itemManager
//
//        sut.save()
//
//        XCTAssertEqual(itemManager.item(at: 0), item)
//    }
}

extension InputViewControllerTests{
    class MockGeoCoder: CLGeocoder{
        var completionHandler: CLGeocodeCompletionHandler?

        override func geocodeAddressString(_ addressString: String, completionHandler: @escaping CLGeocodeCompletionHandler) {
            self.completionHandler = completionHandler
        }
    }

    class MockPlaceMark: CLPlacemark{
        var mockCoordinate: CLLocationCoordinate2D?

        override var location: CLLocation? {
            guard let coordinate = mockCoordinate else{
                return CLLocation()
            }

            return CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        }
    }
}
