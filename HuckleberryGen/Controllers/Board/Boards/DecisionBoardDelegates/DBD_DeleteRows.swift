//
//  DBD_DeleteRows.swift
//  HuckleberryGen
//
//  Created by David Vallas on 1/13/16.
//  Copyright © 2016 Phoenix Labs. All rights reserved.
//

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
 
    func decisionboardQuestion(db: DecisionBoard) -> String {
        if rowsToDelete.count > 1 { return "Do you really want to delete \(rowsToDelete.count) rows?" }
        return "Do you really want to delete row?"
    }
    
    func decisionboard(db: DecisionBoard, didChoose: Bool) {
        tableview?.delete(rows: rowsToDelete)
    }
}