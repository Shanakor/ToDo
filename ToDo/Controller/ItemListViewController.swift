//
//  ItemListViewController.swift
//  ToDo
//
//  Created by Niklas Rammerstorfer on 30.01.18.
//  Copyright © 2018 Niklas Rammerstorfer. All rights reserved.
//

import UIKit

class ItemListViewController: UIViewController {

    // MARK: IBOutlets
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var dataProvider: (UITableViewDataSource & UITableViewDelegate & ItemManagerSettable)!

    // MARK: Properties

    let itemManager = ItemManager()

    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = dataProvider
        tableView.delegate = dataProvider
        dataProvider.itemManager = itemManager
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        tableView.reloadData()
    }

    // MARK: IBActions
    
    @IBAction func addItem(_ sender: Any) {

        if let inputViewController = self.storyboard?.instantiateViewController(withIdentifier: "InputViewController") as? InputViewController{
            inputViewController.itemManager = itemManager
            self.present(inputViewController, animated: true)
        }
    }
}
