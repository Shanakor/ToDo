//
// Created by Niklas Rammerstorfer on 30.01.18.
// Copyright (c) 2018 Niklas Rammerstorfer. All rights reserved.
//

import Foundation
import CoreLocation

struct Location: Equatable {
    // MARK: Constants

    private struct PlistKeys{
        static let Name = "nameKey"
        static let Latitude = "latitudeKey"
        static let Longitude = "longitudeKey"
    }

    // MARK: Properties

    let name: String
    let coordinate: CLLocationCoordinate2D?

    var plistDict: [String: Any]{
        var dict = [String: Any]()

        dict[PlistKeys.Name] = name

        if let coordinate = coordinate{
            dict[PlistKeys.Latitude] = coordinate.latitude
            dict[PlistKeys.Longitude] = coordinate.longitude
        }

        return dict
    }

    init(name: String, coordinate: CLLocationCoordinate2D? = nil){
        self.name = name
        self.coordinate = coordinate
    }

    init?(dict: [String: Any]){
        guard let name = dict[PlistKeys.Name] as? String else{
            return nil
        }

        var coordinate: CLLocationCoordinate2D? = nil
        if let latitude = dict[PlistKeys.Latitude] as? Double,
           let longitude = dict[PlistKeys.Longitude] as? Double{

            coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        }

        self.init(name: name, coordinate: coordinate)
    }
}

func ==(lhs: Location, rhs: Location) -> Bool{
    if lhs.name != rhs.name{
        return false
    }
    if lhs.coordinate?.latitude != rhs.coordinate?.latitude{
        return false
    }
    else if lhs.coordinate?.longitude != rhs.coordinate?.longitude{
        return false
    }

    return true
}
