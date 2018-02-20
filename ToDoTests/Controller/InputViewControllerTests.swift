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

    lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"

        return dateFormatter
    }()

    override func setUp() {
        super.setUp()

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        sut = storyboard.instantiateViewController(withIdentifier: "InputViewController") as! InputViewController
        sut.loadViewIfNeeded()

        sut.itemManager = ItemManager()
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

    func test_SaveButtonHasSaveAction(){
        let saveButton: UIButton = sut.saveButton

        guard let actions = saveButton.actions(forTarget: sut, forControlEvent: .touchUpInside) else{
            XCTFail(); return
        }

        XCTAssertTrue(actions.contains("save"))
    }

    func test_HasCancelButton(){
        XCTAssertTrue(sut.cancelButton.isDescendant(of: sut.view))
    }

    func test_Save_NoTitle_DoesNotSave(){
        sut.save()

        XCTAssertEqual(sut.itemManager!.toDoCount, 0)
    }

    func test_Save_UsesGeocoderToCoordinateFromAddress(){
        // Preparation.

        let item = ToDoItem(title: "foo", itemDescription: "bar", timeStamp: 1456095600.0,
                            location: Location(name: "baz", coordinate: CLLocationCoordinate2D(latitude: 37.3316851,
                                    longitude: -122.0300674)))

        sut.titleTextField.text = item.title
        sut.dateTextField.text = dateFormatter.string(from: Date(timeIntervalSince1970: item.timeStamp!))
        sut.locationTextField.text = item.location!.name
        sut.addressTextField.text = "Infinite Loop 1, Cubertino"
        sut.descriptionTextField.text = item.itemDescription

        let mockGeoCoder = MockGeoCoder()
        sut.geocoder = mockGeoCoder

        // Invocation.

        sut.save()

        placemark = MockPlaceMark()
        placemark.mockCoordinate = item.location!.coordinate

        mockGeoCoder.completionHandler?([placemark], nil)

        // Assertion.

        XCTAssertEqual(sut.itemManager!.item(at: 0), item)
    }

    func test_Save_GivenTitleOnly_SavesItem(){
        let item = ToDoItem(title: "foo")
        sut.titleTextField.text = item.title

        sut.save()

        XCTAssertEqual(sut.itemManager!.item(at: 0), item)
    }

    func test_Save_GivenAllButLocation_SavesItem(){
        let item = ToDoItem(title: "foo", itemDescription: "bar", timeStamp: 1456095600.0)

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"

        let date = Date(timeIntervalSince1970: item.timeStamp!)

        sut.titleTextField.text = item.title
        sut.dateTextField.text = dateFormatter.string(from: date)
        sut.descriptionTextField.text = item.itemDescription

        sut.save()

        XCTAssertEqual(sut.itemManager!.item(at: 0), item)
    }

    func test_Geocoder_FetchesCoordinates(){
        let address = "Infinite Loop 1, Cubertino"
        let geocoderAnswered = expectation(description: "Geocoder")

        CLGeocoder().geocodeAddressString(address){
            (placeMarks, error) in

            let coordinate = placeMarks?.first?.location?.coordinate

            guard let latitude = coordinate?.latitude else{
                XCTFail(); return
            }

            guard let longitude = coordinate?.longitude else{
                XCTFail(); return
            }

            XCTAssertEqual(latitude, 37.3316, accuracy: 0.001)
            XCTAssertEqual(longitude, -122.0300, accuracy: 0.001)

            geocoderAnswered.fulfill()
        }

        waitForExpectations(timeout: 3)
    }
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
