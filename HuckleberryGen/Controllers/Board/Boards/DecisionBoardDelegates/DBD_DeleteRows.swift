//
//  DBD_DeleteRows.swift
//  HuckleberryGen
//
//  Created by David Vallas on 1/13/16.
//  Copyright © 2016 Phoenix Labs.
//
//  This file is part of HuckleberryGen.
//
//  HuckleberryGen is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  HuckleberryGen is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with HuckleberryGen.  If not, see <http://www.gnu.org/licenses/>.

import Foundation

class DBD_DeleteRows {
    
    weak var tableview: HGTableView?
    
    var rowsToDelete: [Int]
    
    init(tableview: HGTableView, rowsToDelete: [Int]) {
        self.tableview = tableview
        self.rowsToDelete = rowsToDelete
    }
}

extension DBD_DeleteRows: DecisionBoardDelegate {
 
    func decisionboardQuestion(_ db: DecisionBoard) -> String {
        if rowsToDelete.count > 1 { return "Do you really want to delete \(rowsToDelete.count) rows?" }
        return "Do you really want to delete row?"
    }
    
    func decisionboard(_ db: DecisionBoard, didChoose: Bool) {
        if didChoose { tableview?.delete(rows: rowsToDelete) }
    }
}
