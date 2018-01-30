//
//  ItemCell.swift
//  ToDo
//
//  Created by Niklas Rammerstorfer on 30.01.18.
//  Copyright © 2018 Niklas Rammerstorfer. All rights reserved.
//

import UIKit

class ItemCell: UITableViewCell {

    // MARK: IBOutlets

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!

    // MARK: Properties

    lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        return dateFormatter
    }()
    
    func configCell(with item: ToDoItem, checked: Bool = false) {
        if checked{
            configCheckedCell(with: item)
        }
        else{
            configUnCheckedCell(with: item)
        }
    }

    private func configUnCheckedCell(with item: ToDoItem) {
        titleLabel.text = item.title

        if let timeStamp = item.timeStamp{
            let date = Date(timeIntervalSince1970: timeStamp)
            dateLabel.text = dateFormatter.string(from: date)
        }

        if let location = item.location{
            locationLabel.text = location.name
        }
    }

    private func configCheckedCell(with item: ToDoItem) {
        let attributedString = NSAttributedString(string: item.title, attributes: [
            NSAttributedStringKey.strikethroughStyle: NSUnderlineStyle.styleSingle.rawValue
        ])

        titleLabel.attributedText = attributedString
        dateLabel.text = nil
        locationLabel.text = nil
    }
}
