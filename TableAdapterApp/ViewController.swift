//
//  ViewController.swift
//  TableAdapterApp
//
//  Created by Rodrigo Kreutz on 9/28/17.
//  Copyright © 2017 Rodrigo Kreutz. All rights reserved.
//

import UIKit
import TableAdapter

extension UIColor {
    static func random() -> UIColor {
        return UIColor(red: CGFloat(Double(arc4random() % 256)/255.0), green: CGFloat(arc4random() % 256)/255.0, blue: CGFloat(arc4random() % 256)/255.0, alpha: 1)
    }
}

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            self.tableView.delegate = tableAdapter
            self.tableView.dataSource = tableAdapter
            self.tableView.tableFooterView = UIView()
            self.tableView.rowHeight = 100
            self.tableView.contentInset = UIEdgeInsets(top: 44, left: 0, bottom: 34, right: 0)
        }
    }
    
    lazy var tableAdapter = TableAdapter(withItems: [], delegate: self)

    @IBAction func changeData() {
        let sections = arc4random() % 4 + 1
        let data: [(TableSection?, [TableItem])] = (0..<sections).map { _ in
            let rows = arc4random() % 9 + 1
            let items = (0..<rows).map({ _ in ColorItem(color: .random()) })
            return (nil, items)
        }
        
        self.tableAdapter.data = data
    }
}

extension ViewController: TableAdapterDelegate {
    func didUpdateData(updatedIndexes: [IndexPath], insertedIndexes: [IndexPath], deletedIndexes: [IndexPath], insertedSections: IndexSet?, deletedSections: IndexSet?) {
        self.tableView.beginUpdates()
        self.tableView.reloadRows(at: updatedIndexes, with: .automatic)
        self.tableView.deleteRows(at: deletedIndexes, with: .automatic)
        self.tableView.insertRows(at: insertedIndexes, with: .automatic)
        if let insertedSections = insertedSections {
            self.tableView.insertSections(insertedSections, with: .automatic)
        }
        if let deletedSections = deletedSections {
            self.tableView.deleteSections(deletedSections, with: .automatic)
        }
        self.tableView.endUpdates()
    }
    
    func didSelect(item: TableItem, at indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
}
