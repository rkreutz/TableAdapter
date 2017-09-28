//
//  TableItem.swift
//  TableAdapter
//
//  Created by Rodrigo Kreutz on 9/28/17.
//  Copyright © 2017 Rodrigo Kreutz. All rights reserved.
//

import Foundation

public protocol TableItem {
    var hashValue: Int { get }
    var cellIdentifier: String { get }
    var editActions: [UITableViewRowAction]? { get }
    
    func configure(cell: UITableViewCell)
}

public extension TableItem {
    public var hashValue: Int {
        return 0
    }
    
    var editActions: [UITableViewRowAction]? {
        return nil
    }
}
