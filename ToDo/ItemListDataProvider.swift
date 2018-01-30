//
//  ItemListDataProvider.swift
//  ToDo
//
//  Created by Niklas Rammerstorfer on 30.01.18.
//  Copyright © 2018 Niklas Rammerstorfer. All rights reserved.
//

import UIKit

enum Section: Int{
    case toDo
    case done
}

class ItemListDataProvider: NSObject, UITableViewDataSource, UITableViewDelegate {

    var itemManager: ItemManager?

    // MARK: DataSource

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        guard let itemManager = itemManager else{
            return 0
        }

        guard let section = Section(rawValue: section) else{
            fatalError()
        }

        let numberOfRows: Int

        switch section{
            case .toDo:
                numberOfRows = itemManager.toDoCount
            case .done:
                numberOfRows = itemManager.doneCount
        }

        return numberOfRows
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let itemManager = itemManager else{
            fatalError()
        }

        guard let section = Section(rawValue: indexPath.section) else{
            fatalError()
        }

        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! ItemCell

        let item: ToDoItem
        switch section{
            case .toDo:
                item = itemManager.item(at: indexPath.row)
            case .done:
                item = itemManager.doneItem(at: indexPath.row)
        }

        cell.configCell(with: item)

        return cell
    }

    // MARK: Delegate
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        guard let section = Section(rawValue: indexPath.section) else{
            fatalError()
        }

        return section == .toDo ? "Check" : "Uncheck"
    }
}
