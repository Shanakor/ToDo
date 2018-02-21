//
// Created by Niklas Rammerstorfer on 30.01.18.
// Copyright (c) 2018 Niklas Rammerstorfer. All rights reserved.
//

import Foundation

class ItemManager: NSObject {

    // MARK: Properties

    private var toDoItems = [ToDoItem]()
    private var doneItems = [ToDoItem]()

    var toDoCount: Int { return toDoItems.count}
    var doneCount: Int { return doneItems.count}

    private var basePathURL: URL{
        let fileURLs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)

        guard let documentURL = fileURLs.first else{
            print("Something went wrong. Documents url could not be found.")
            fatalError()
        }

        return documentURL
    }

    private var toDoItemPathURL: URL{
        return basePathURL.appendingPathComponent("toDoItems.plist")
    }

    private var doneItemPathURL: URL{
        return basePathURL.appendingPathComponent("doneItems.plist")
    }

    // MARK: Initialization

    override init(){
        super.init()

        NotificationCenter.default.addObserver(self, selector: #selector(persist), name: .UIApplicationWillResignActive, object: nil)

        restoreItems()
    }

    deinit{
        NotificationCenter.default.removeObserver(self)
        persist()
    }

    // MARK: Utility Methods

    func add(_ item: ToDoItem) {
        if(!toDoItems.contains(item)) {
            toDoItems.append(item)
        }
    }

    func item(at index: Int) -> ToDoItem? {
        guard toDoItems.count > index else{
            return nil
        }

        return toDoItems[index]
    }

    func checkItem(at index: Int) {
        if toDoItems.count > index {
            let item = toDoItems.remove(at: index)
            doneItems.append(item)
        }
    }

    func unCheckItem(at index: Int) {
        if doneItems.count > index {
            let item = doneItems.remove(at: index)
            toDoItems.append(item)
        }
    }

    func doneItem(at index: Int) -> ToDoItem? {
        guard doneItems.count > index else{
            return nil
        }

        return doneItems[index]
    }

    func removeAll() {
        toDoItems.removeAll()
        doneItems.removeAll()
    }

    // MARK: Persistence

    @objc private func persist(){
        persistToDoItems()
        persistDoneItems()
    }

    private func persistDoneItems() {
        let nsDoneItems = doneItems.map { $0.plistDict }
        persistItems(nsDoneItems, at: doneItemPathURL)
    }

    private func persistToDoItems() {
        let nsToDoItems = toDoItems.map { $0.plistDict }
        persistItems(nsToDoItems, at: toDoItemPathURL)
    }

    private func persistItems(_ items: [[String: Any]], at url: URL) {
        guard items.count > 0 else{
            try? FileManager.default.removeItem(at: url)
            return
        }

        do{
            let plistData = try PropertyListSerialization.data(fromPropertyList: items, format: .xml, options: PropertyListSerialization.WriteOptions(0))
            try plistData.write(to: url, options: .atomic)
        }
        catch{
            print(error)
        }
    }

    private func restoreItems(){
        restoreToDoItems()
        restoreDoneItems()
    }

    private func restoreToDoItems() {
        if let nsToDoItems = NSArray(contentsOf: toDoItemPathURL) {
            for dict in nsToDoItems {
                if let toDoItem = ToDoItem(dict: dict as! [String: Any]){
                    toDoItems.append(toDoItem)
                }
            }
        }
    }

    private func restoreDoneItems() {
        if let nsDoneItems = NSArray(contentsOf: doneItemPathURL) {
            for dict in nsDoneItems {
                if let doneItem = ToDoItem(dict: dict as! [String: Any]){
                    doneItems.append(doneItem)
                }
            }
        }
    }
}
