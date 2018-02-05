//
//  InputViewController.swift
//  ToDo
//
//  Created by Niklas Rammerstorfer on 31.01.18.
//  Copyright © 2018 Niklas Rammerstorfer. All rights reserved.
//

import UIKit
import CoreLocation

class InputViewController: UIViewController {

    // MARK: IBOutlets

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!

    // MARK: Constants

    let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        return dateFormatter
    }()

    // MARK: Properties

    lazy var geocoder = CLGeocoder()
    var itemManager: ItemManager?

    // MARK: IBActions

    func save(){
        guard let titleString = titleTextField.text,
              !titleString.isEmpty else{
            return
        }

        let date: Date?
        if let dateString = dateTextField.text,
           !dateString.isEmpty{
            date = dateFormatter.date(from: dateString)
        }
        else{
            date = nil
        }

        let descriptionString = descriptionTextField.text

        if let locationName = locationTextField.text,
            !locationName.isEmpty{

            if let address = addressTextField.text,
                !address.isEmpty{

                geocoder.geocodeAddressString(address){
                    (placeMarks, error) in

                    let placemark = placeMarks?.first

                    let item = ToDoItem(title: titleString, itemDescription: descriptionString, timeStamp: date?.timeIntervalSince1970,
                            location: Location(name: locationName, coordinate: placemark?.location?.coordinate))

                    self.itemManager?.add(item)
                }
            }
        }
    }
}
