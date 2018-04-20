//
//  SBD_SavedProjects.swift
//  HuckleberryGen
//
//  Created by David Vallas on 1/12/16.
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

/// context for a Selection Board of unique attributes
class SBD_SavedProjects: SelectionBoardDelegate {
    
    /// reference to the selection board
    weak var selectionBoard: SelectionBoard?
    
    /// reference to the cell type used
    let celltype = CellType.fieldCell2
    
    func selectionboard(_ sb: SelectionBoard, didChooseLocations locations: [HGCellLocation]) {
        let index = locations[0].row
        appDelegate.store.openProject(atIndex: index)
    }
}

// MARK: HGTableDisplayable
extension SBD_SavedProjects: HGTableDisplayable {
    
    func numberOfRows(fortable table: HGTable) -> Int {
        let count = appDelegate.store.savedProjects.count
        return count
    }
    
    func hgtable(_ table: HGTable, heightForRow row: Int) -> CGFloat {
        return celltype.rowHeightForTable(selectionBoard?.tableview)
    }
    
    func hgtable(_ table: HGTable, cellForRow row: Int) -> CellType {
        return celltype
    }
    
    func hgtable(_ table: HGTable, dataForRow row: Int) -> HGCellData {
        let savedProjectName = appDelegate.store.savedProjects[row]
        let fieldData = HGFieldData(title: savedProjectName)
        return HGCellData.fieldCell2(field0: fieldData, field1: HGFieldData(title: ""))
    }
}

// MARK: HGTableRowSelectable
extension SBD_SavedProjects: HGTableRowSelectable {
    
    func hgtable(_ table: HGTable, shouldSelectRow row: Int) -> Bool {
        return true
    }
}

// MARK: HGTableRowAppendable
extension SBD_SavedProjects: HGTableRowAppendable {
    
    func hgtable(shouldAddRowToTable table: HGTable) -> Bool {
        return false
    }
    
    func hgtable(willAddRowToTable table: HGTable) {
        // do nothing
    }
    
    func hgtable(_ table: HGTable, shouldDeleteRows rows: [Int]) -> Option {
        return .yes
    }
    
    func hgtable(_ table: HGTable, willDeleteRows rows: [Int]) {
        let row = rows[0]
        appDelegate.store.deleteProject(atIndex: row)
    }

}
