//
//  TableSection.swift
//  TableAdapter
//
//  Created by Rodrigo Kreutz on 9/28/17.
//  Copyright © 2017 Rodrigo Kreutz. All rights reserved.
//

import Foundation

public protocol TableSection {
    var hashValue: Int { get }
    var headerIdentifier: String { get }
    var headerHeight: CGFloat { get }
    var footerIdentifier: String { get }
    var footerHeight: CGFloat { get }
    
    func configure(headerView: UIView)
    func configure(footerView: UIView)
}

public extension TableSection {
    var headerIdentifier: String {
        return ""
    }
    
    var headerHeight: CGFloat {
        return 0
    }
    
    var footerIdentifier: String {
        return ""
    }
    
    var footerHeight: CGFloat {
        return 0
    }
    
    func configure(headerView: UIView) {  }
    
    func configure(footerView: UIView) {  }
}
