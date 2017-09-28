//
//  TableAdapter.swift
//  TableAdapter
//
//  Created by Rodrigo Kreutz on 9/28/17.
//  Copyright © 2017 Rodrigo Kreutz. All rights reserved.
//

import UIKit

public protocol TableAdapterDelegate {
    func didUpdateData(updatedIndexes: [IndexPath], insertedIndexes: [IndexPath], deletedIndexes: [IndexPath], insertedSections: IndexSet?, deletedSections: IndexSet?)
    func didSelect(item: TableItem, at indexPath: IndexPath)
}

open class TableAdapter: NSObject {

    public var data: [(section: TableSection?, items: [TableItem])] {
        didSet {
            var insertIndexes: [IndexPath] = []
            var updateIndexes: [IndexPath] = []
            for y in 0..<self.data.count {
                guard y < oldValue.count else {
                    insertIndexes.append(contentsOf: (0..<self.data[y].items.count).map({ IndexPath(row: $0, section: y) }))
                    continue
                }
                
                for x in 0..<self.data[y].items.count {
                    guard x < oldValue[y].items.count else {
                        insertIndexes.append(IndexPath(row: x, section: y))
                        continue
                    }
                    
                    if self.data[y].items[x].hashValue != oldValue[y].items[x].hashValue {
                        updateIndexes.append(IndexPath(row: x, section: y))
                    }
                }
            }
            
            var deleteIndexes: [IndexPath] = []
            for y in 0..<oldValue.count {
                guard y < self.data.count else {
                    deleteIndexes.append(contentsOf: (0..<oldValue[y].items.count).map({ IndexPath(row: $0, section: y) }))
                    continue
                }
                
                for x in 0..<oldValue[y].items.count {
                    guard x < self.data[y].items.count else {
                        deleteIndexes.append(IndexPath(row: x, section: y))
                        continue
                    }
                }
            }
            
            var deleteSections: IndexSet?
            var insertSections: IndexSet?
            if oldValue.count > self.data.count {
                deleteSections = IndexSet(integersIn: self.data.count..<oldValue.count)
            } else if oldValue.count < self.data.count {
                insertSections = IndexSet(integersIn: oldValue.count..<self.data.count)
            }
            
            self.delegate?.didUpdateData(updatedIndexes: updateIndexes, insertedIndexes: insertIndexes, deletedIndexes: deleteIndexes, insertedSections: insertSections, deletedSections: deleteSections)
        }
    }
    
    fileprivate var lastIndexSelected: IndexPath? {
        didSet {
            guard
                let index = self.lastIndexSelected,
                index.section < self.data.count,
                index.row < self.data[index.section].items.count
            else { return }
            
            self.delegate?.didSelect(item: self.data[index.section].items[index.row], at: index)
        }
    }
    
    public var delegate: TableAdapterDelegate?
    
    public init(withItems items: [TableItem], delegate: TableAdapterDelegate?) {
        self.data = [(nil, items)]
        self.delegate = delegate
        super.init()
    }
    
    public init(withData data: [(TableSection?, [TableItem])], delegate: TableAdapterDelegate?) {
        self.data = data
        self.delegate = delegate
        super.init()
    }
    
    
}

// MARK: - UITableViewDataSource

extension TableAdapter: UITableViewDataSource {
    public func numberOfSections(in tableView: UITableView) -> Int {
        return data.count
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard section < data.count else { return 0 }
        return data[section].items.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard indexPath.section < self.data.count, indexPath.row < self.data[indexPath.section].items.count else { return UITableViewCell() }
        let item = self.data[indexPath.section].items[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: item.cellIdentifier, for: indexPath)
        item.configure(cell: cell)
        return cell
    }
}

// MARK: - UITableViewDelegate

extension TableAdapter: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard
            section < self.data.count,
            let sectionItem = self.data[section].section,
            let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: sectionItem.headerIdentifier)
        else { return nil }
        
        sectionItem.configure(headerView: view)
        return view
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard section < self.data.count, let sectionItem = self.data[section].section else { return 0 }
        return sectionItem.headerHeight
    }
    
    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard
            section < self.data.count,
            let sectionItem = self.data[section].section,
            let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: sectionItem.footerIdentifier)
        else { return nil }
        
        sectionItem.configure(footerView: view)
        return view
    }
    
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        guard section < self.data.count, let sectionItem = self.data[section].section else { return 0 }
        return sectionItem.footerHeight
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard indexPath.section < self.data.count, indexPath.row < self.data[indexPath.section].items.count else { return }
        self.lastIndexSelected = indexPath
    }
    
    public func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        guard indexPath.section < self.data.count, indexPath.row < self.data[indexPath.section].items.count else { return nil }
        let item = self.data[indexPath.section].items[indexPath.row]
        return item.editActions
    }
}
