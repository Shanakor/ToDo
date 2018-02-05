//
//  DetailViewController.swift
//  ToDo
//
//  Created by Niklas Rammerstorfer on 30.01.18.
//  Copyright © 2018 Niklas Rammerstorfer. All rights reserved.
//

import UIKit
import MapKit

class DetailViewController: UIViewController {
    
    // MARK: IBOutlets
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var checkButton: UIButton!

    // MARK: Properties

    var itemInfo: (ItemManager, Int)?

    lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        return dateFormatter
    }()

    // MARK: Initialization

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        updateUI()
    }

    private func updateUI() {
        guard let itemInfo = itemInfo else{
            fatalError()
        }

        let itemManager = itemInfo.0
        let selectedIdx = itemInfo.1

        guard let item = itemManager.item(at: selectedIdx) else{
            print("Log: Could not find a TodoItem at index \(selectedIdx)!")
            return
        }

        titleLabel.text = item.title

        if let timeStamp = item.timeStamp {
            dateLabel.text = dateFormatter.string(from: Date(timeIntervalSince1970: timeStamp))
        }
        if let location = item.location{
            locationLabel.text = location.name

            if let coordinate = location.coordinate {
                mapView.region = MKCoordinateRegionMakeWithDistance(coordinate, 100, 100)
            }
        }
        if let description = item.itemDescription{
            descriptionLabel.text = description
        }
    }


    // MARK: IBActions

    @IBAction func checkItem() {
        if let itemInfo = itemInfo{
            itemInfo.0.checkItem(at: itemInfo.1)
        }
    }
}
