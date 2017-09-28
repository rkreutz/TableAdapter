//
//  ColorTableViewCell.swift
//  TableAdapterApp
//
//  Created by Rodrigo Kreutz on 9/28/17.
//  Copyright © 2017 Rodrigo Kreutz. All rights reserved.
//

import UIKit

class ColorTableViewCell: UITableViewCell {
    
    static let identifier = "colorCell"
    
    func configure(withColor color: UIColor) {
        self.contentView.backgroundColor = color
    }

}
