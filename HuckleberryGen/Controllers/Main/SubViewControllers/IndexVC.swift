//
//  IndexVC.swift
//  HuckleberryGen
//
//  Created by David Vallas on 1/31/16.
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

import Cocoa

/// NSViewController that displays a table of Indexes
class IndexVC: NSViewController {
    
    // MARK: Public Variables
    
    @IBOutlet weak var tableview: HGTableView! { didSet { hgtable = HGTable(tableview: tableview, delegate: self) } }
    
    let cellType = CellType.DefaultCell
    
    var hgtable: HGTable!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension IndexVC: HGTableDisplayable {
    
    func tableview(fortable table: HGTable) -> HGTableView! {
        return tableview
    }
    
    func numberOfRows(fortable table: HGTable) -> Int {
        return appDelegate.store.project.indexes.count
    }
    
    func hgtable(table: HGTable, heightForRow row: Int) -> CGFloat {
        return 50.0
    }
    
    func hgtable(table: HGTable, cellForRow row: Int) -> CellType {
        return cellType
    }
    
    func hgtable(table: HGTable, dataForRow row: Int) -> HGCellData {
        let index = appDelegate.store.getIndex(index: row)
        return HGCellData.defaultCell(
            field0: HGFieldData(title: index.varRep),
            field1: HGFieldData(title: ""),
            image0: HGImageData(title: "", image: index.entityImage)
        )
    }
}

// MARK: HGTableObservable
extension IndexVC: HGTableObservable {
    
    func observeNotifications(fortable table: HGTable) -> [String] {
        return appDelegate.store.notificationNames(forNotifTypes: [.IndexUpdated])
    }
}


// MARK: HGTableRowSelectable
extension IndexVC: HGTableRowSelectable {
    
    func hgtable(table: HGTable, shouldSelectRow row: Int) -> Bool {
        return true
    }
}

// MARK: HGItemSelectable
extension IndexVC: HGTableItemSelectable {
    
    func hgtable(table: HGTable, shouldSelect row: Int, tag: Int, type: CellItemType) -> Bool {
        if type == .Image && tag == 0 {
            // present a selection board to update current Attribute
            let context = SBD_Entities(indexIndex: row)
            let boarddata = SelectionBoard.boardData(withContext: context)
            appDelegate.mainWindowController.boardHandler.start(withBoardData: boarddata)
        }
        return false
    }
    
    func hgtable(table: HGTable, didSelectRow row: Int, tag: Int, type: CellItemType) {
        // Do Nothing
    }
}


// MARK: HGTableFieldEditable
extension IndexVC: HGTableFieldEditable {
    
    func hgtable(table: HGTable, shouldEditRow row: Int, field: Int) -> Bool {
        return field == 0 ? true : false
    }
    
    func hgtable(table: HGTable, didEditRow row: Int, field: Int, withString string: String) {
        var index = appDelegate.store.getIndex(index: row)
        index.varRep = string
        appDelegate.store.replaceIndex(atIndex: row, withIndex: index)
    }
}

// MARK: HGTableRowAppendable
extension IndexVC: HGTableRowAppendable {
    
    func hgtable(shouldAddRowToTable table: HGTable) -> Bool  {
        return true
    }
    
    func hgtable(willAddRowToTable table: HGTable) {
        appDelegate.store.createIndex()
    }
    
    func hgtable(table: HGTable, shouldDeleteRows rows: [Int]) -> Option {
        return .Yes
    }
    
    func hgtable(table: HGTable, willDeleteRows rows: [Int]) {
        appDelegate.store.deleteIndexes(atIndexes: rows)
    }
}