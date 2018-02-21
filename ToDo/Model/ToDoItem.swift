//
// Created by Niklas Rammerstorfer on 30.01.18.
// Copyright (c) 2018 Niklas Rammerstorfer. All rights reserved.
//

import Foundation

struct ToDoItem: Equatable{
    // MARK: Constants

    private struct PlistKeys{
        static let Title = "titleKey"
        static let ItemDescription = "itemDescriptionKey"
        static let TimeStamp = "timeStampKey"
        static let Location = "locationKey"
    }

    // MARK: Properties

    let title: String
    let itemDescription: String?
    let timeStamp: Double?
    let location: Location?

    var plistDict: [String: Any]{
        var dict = [String: Any]()

        dict[PlistKeys.Title] = title

        if let itemDescription = itemDescription{
            dict[PlistKeys.ItemDescription] = itemDescription
        }
        if let timeStamp = timeStamp{
            dict[PlistKeys.TimeStamp] = timeStamp
        }

        if let location = location{
            dict[PlistKeys.Location] = location.plistDict
        }

        return dict
    }

    init(title: String, itemDescription: String? = nil, timeStamp: Double? = nil, location: Location? = nil){
        self.title = title
        self.itemDescription = itemDescription
        self.timeStamp = timeStamp
        self.location = location
    }

    init?(dict: [String: Any]){
        guard let title = dict[PlistKeys.Title] as? String else{
            return nil
        }

        self.title = title
        self.itemDescription = dict[PlistKeys.ItemDescription] as? String
        self.timeStamp = dict[PlistKeys.TimeStamp] as? Double

        if let locationDict = dict[PlistKeys.Location] as? [String: Any]{
            self.location = Location(dict: locationDict)
        }
        else{
            self.location = nil
        }
    }
}

func ==(lhs: ToDoItem, rhs: ToDoItem) -> Bool{
    if lhs.location != rhs.location{
        return false
    }
    if lhs.timeStamp != rhs.timeStamp{
        return false
    }
    if lhs.itemDescription != rhs.itemDescription{
        return false
    }
    if lhs.title != rhs.title{
        return false
    }

    return true
}
