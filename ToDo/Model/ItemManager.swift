//
// Created by Niklas Rammerstorfer on 30.01.18.
// Copyright (c) 2018 Niklas Rammerstorfer. All rights reserved.
//

import Foundation

class ItemManager {

    // MARK: Properties

    private var toDoItems = [ToDoItem]()
    private var doneItems = [ToDoItem]()

    var toDoCount: Int { return toDoItems.count}
    var doneCount: Int { return doneItems.count}

    // MARK: Utility Methods

    func add(_ item: ToDoItem) {
        if(!toDoItems.contains(item)) {
            toDoItems.append(item)
        }
    }

    func item(at index: Int) -> ToDoItem {
        return toDoItems[index]
    }

    func checkItem(at index: Int) {
        let item = toDoItems.remove(at: index)
        doneItems.append(item)
    }

    func unCheckItem(at index: Int) {
        let item = doneItems.remove(at: index)
        toDoItems.append(item)
    }

    func doneItem(at index: Int) -> ToDoItem {
        return doneItems[index]
    }

    func removeAll() {
        toDoItems.removeAll()
        doneItems.removeAll()
    }
}
