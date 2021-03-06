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

class ItemListDataProvider: NSObject, UITableViewDataSource, UITableViewDelegate, ItemManagerSettable {

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

        let item: ToDoItem?
        switch section{
            case .toDo:
                item = itemManager.item(at: indexPath.row)
            case .done:
                item = itemManager.doneItem(at: indexPath.row)
        }

        if let item = item{
            cell.configCell(with: item)
        }
        else{
            print("Log: Could not find a TodoItem at index: \(indexPath.row)!")
        }

        return cell
    }

    // MARK: Delegate

    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        guard let section = Section(rawValue: indexPath.section) else{
            fatalError()
        }

        return section == .toDo ? "Check" : "Uncheck"
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        guard let section = Section(rawValue: indexPath.section) else{
            fatalError()
        }

        switch section{
            case .toDo:
                itemManager?.checkItem(at: indexPath.row)
            case .done:
                itemManager?.unCheckItem(at: indexPath.row)
        }

        tableView.reloadData()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let section = Section(rawValue: indexPath.section) else{
            fatalError()
        }

        switch(section){
            case .toDo:
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ItemSelectedNotification"),
                        object: nil, userInfo: ["index": indexPath.row])
            default: break
        }
    }
}

@objc protocol ItemManagerSettable{
    var itemManager: ItemManager? {get set}
}
