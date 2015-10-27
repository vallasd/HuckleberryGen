//
//  HGTableCellIdentifier.swift
//  HuckleberryGen
//
//  Created by David Vallas on 9/18/15.
//  Copyright © 2015 Phoenix Labs. All rights reserved.
//

import Foundation


// MARK: Private Variables
struct TableCellIdentifier {
    var tableId: String?
    var cellId: String
}

extension TableCellIdentifier: Hashable {
    
    var hashValue: Int {
        let t = tableId ?? "NotDefined"
        let hash = t + cellId
        return hash.hashValue
    }
    
}

extension TableCellIdentifier: Equatable {}
func ==(lhs: TableCellIdentifier, rhs: TableCellIdentifier) -> Bool {
    return lhs.tableId == rhs.tableId && lhs.cellId == rhs.cellId
}