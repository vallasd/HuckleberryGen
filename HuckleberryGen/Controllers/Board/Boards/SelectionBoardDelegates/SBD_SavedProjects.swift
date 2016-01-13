//
//  SBD_SavedProjects.swift
//  HuckleberryGen
//
//  Created by David Vallas on 1/12/16.
//  Copyright © 2016 Phoenix Labs. All rights reserved.
//

import Foundation

/// context for a Selection Board of unique attributes
class SBD_SavedProjects: SelectionBoardDelegate {
    
    /// reference to the selection board
    weak var selectionBoard: SelectionBoard?
    
    /// reference to the cell type used
    let celltype = HGCellType.FieldCell1
    
    /// a list of ProjectInfos for saved projects
    let savedProjects = appDelegate.store.savedProjects
    
    func selectionboard(sb: SelectionBoard, didChooseLocations locations: [HGCellLocation]) {
        let index = locations[0].row
        appDelegate.store.openProject(atIndex: index)
    }
}

// MARK: HGTableDisplayable
extension SBD_SavedProjects: HGTableDisplayable {
    
    func numberOfRows(fortable table: HGTable) -> Int {
        return savedProjects.count
    }
    
    func hgtable(table: HGTable, heightForRow row: Int) -> CGFloat {
        return celltype.rowHeightForTable(selectionBoard?.tableview)
    }
    
    func hgtable(table: HGTable, cellForRow row: Int) -> HGCellType {
        return celltype
    }
    
    func hgtable(table: HGTable, dataForRow row: Int) -> HGCellData {
        let savedProject = savedProjects[row]
        let fieldData = HGFieldData(title: savedProject)
        return HGCellData.fieldCell1(field0: fieldData)
    }
}

extension SBD_SavedProjects: HGTableRowSelectable {
    
    func hgtable(table: HGTable, shouldSelectRow row: Int) -> Bool {
        return true
    }
    
}


