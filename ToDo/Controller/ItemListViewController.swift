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

        NotificationCenter.default.addObserver(self, selector: #selector(showDetails(sender:)),
                name: NSNotification.Name(rawValue: "ItemSelectedNotification"), object: nil)
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

    // MARK: Navigation

    @objc func showDetails(sender: NSNotification){
        guard let index = sender.userInfo?["index"] as? Int else{
            fatalError()
        }

        if let detailVC = storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController{
            detailVC.itemInfo = (itemManager, index)
            navigationController?.pushViewController(detailVC, animated: true)
        }
    }
}
