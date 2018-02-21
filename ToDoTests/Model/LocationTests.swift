//
//  LocationTests.swift
//  ToDoTests
//
//  Created by Niklas Rammerstorfer on 30.01.18.
//  Copyright © 2018 Niklas Rammerstorfer. All rights reserved.
//

import XCTest
@testable import ToDo
import CoreLocation

class LocationTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func test_Init_WhenGivenCoordinate_SetsCoordinate(){
        let coordinate = CLLocationCoordinate2D(latitude: 1, longitude: 2)
        let loc = Location(name: "", coordinate: coordinate)

        XCTAssertEqual(loc.coordinate?.latitude, coordinate.latitude)
        XCTAssertEqual(loc.coordinate?.longitude, coordinate.longitude)
    }

    func test_Init_WhenGivenName_SetsName(){
        let loc = Location(name: "foo")

        XCTAssertEqual(loc.name, "foo", "should set name")
    }

    func test_EqualLocations_AreEqual(){
        let loc1 = Location(name: "foo")
        let loc2 = Location(name: "foo")

        XCTAssertEqual(loc1, loc2)
    }

    func test_Locations_WhenLatitudeDiffers_AreNotEqual(){
        assertLocationsNotEqual(name1: nil, lonLat1: (0, 0), name2: nil, lonLat2: (1, 0))
    }

    func test_Locations_WhenLongitudeDiffers_AreNotEqual(){
        assertLocationsNotEqual(name1: nil, lonLat1: (0, 0), name2: nil, lonLat2: (0, 1))
    }

    func test_Locations_WhenOnlyOneHasCoordinates_AreNotEqual(){
        assertLocationsNotEqual(name1: nil, lonLat1: (0, 0), name2: nil, lonLat2: nil)
    }

    func test_Locations_WhenNamesDiffer_AreNotEqual(){
        assertLocationsNotEqual(name1: "foo", lonLat1: nil, name2: "bar", lonLat2: nil)
    }

    private func assertLocationsNotEqual(name1: String?, lonLat1: (Double, Double)?, name2: String?, lonLat2: (Double, Double)?, line: UInt = #line){
        var coordinate1: CLLocationCoordinate2D? = nil
        if let firstLongLat = lonLat1 {
            coordinate1 = CLLocationCoordinate2D(latitude: firstLongLat.0, longitude: firstLongLat.1)
        }

        var coordinate2: CLLocationCoordinate2D? = nil
        if let secondLongLat = lonLat2 {
            coordinate2 = CLLocationCoordinate2D(latitude: secondLongLat.0, longitude: secondLongLat.1)
        }

        let loc1 = Location(name: name1 == nil ? "" : name1!, coordinate: coordinate1)
        let loc2 = Location(name: name2 == nil ? "" : name2!, coordinate: coordinate2)

        XCTAssertNotEqual(loc1, loc2, line: line)
    }

    func test_CanBeSerializedAndDeserialized(){
        let location = Location(name: "Home", coordinate: CLLocationCoordinate2D(latitude: 50, longitude: 6))

        let dict = location.plistDict
        XCTAssertNotNil(dict)

        let recreatedLocation = Location(dict: dict)
        XCTAssertEqual(recreatedLocation, location)
    }
}
