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
    
}
