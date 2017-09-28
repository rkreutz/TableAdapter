//
//  ColorItem.swift
//  TableAdapterApp
//
//  Created by Rodrigo Kreutz on 9/28/17.
//  Copyright © 2017 Rodrigo Kreutz. All rights reserved.
//

import UIKit
import TableAdapter

struct ColorItem: TableItem {

    let color: UIColor
    
    var hashValue: Int {
        return self.color.hash
    }
    
    var cellIdentifier: String {
        return ColorTableViewCell.identifier
    }
    
    func configure(cell: UITableViewCell) {
        (cell as? ColorTableViewCell)?.configure(withColor: self.color)
    }
}
