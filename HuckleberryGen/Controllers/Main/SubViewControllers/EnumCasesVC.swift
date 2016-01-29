//
//  EnumCasesVC.swift
//  HuckleberryGen
//
//  Created by David Vallas on 10/2/15.
//  Copyright © 2015 Phoenix Labs. All rights reserved.
//

import Cocoa

class EnumCasesVC: NSViewController {
    
    @IBOutlet weak var tableview: HGTableView!
    
    let enumCell: HGCellType = HGCellType.FieldCell2
    var hgtable: HGTable!
    
    // MARK: HGTableDisplayable
    
    private var editingLocation: HGCellLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hgtable = HGTable(tableview: tableview, delegate: self)
    }
}

// MARK: HGTableDisplayable
extension EnumCasesVC: HGTableDisplayable {
    
    func tableview(fortable table: HGTable) -> HGTableView! {
        return tableview
    }
    
    func numberOfRows(fortable table: HGTable) -> Int {
        return table.parentRow == notSelected ? 0 : appDelegate.store.project.enums[table.parentRow].cases.count
    }
    
    func hgtable(table: HGTable, heightForRow row: Int) -> CGFloat {
        return 50.0
    }
    
    func hgtable(table: HGTable, cellForRow row: Int) -> HGCellType {
        return enumCell
    }
    
    func hgtable(table: HGTable, dataForRow row: Int) -> HGCellData {
        
        let casE = appDelegate.store.project.enums[table.parentRow].cases[row]
        return HGCellData.fieldCell2(
            field0: HGFieldData(title: casE.string),
            field1: HGFieldData(title: String(row))
        )
    }
}

// MARK: HGTableObservable
extension EnumCasesVC: HGTableObservable {
    
    func observeNotifications(fortable table: HGTable) -> [String] {
        return appDelegate.store.notificationNames(forNotifTypes: [.EnumSelected, .EnumCaseUpdated])
    }
}

// MARK: HGTableRowSelectable
extension EnumCasesVC: HGTableRowSelectable {
    
    func hgtable(table: HGTable, shouldSelectRow row: Int) -> Bool {
        return true
    }
}

// MARK: HGTableRowAppendable
extension EnumCasesVC: HGTableRowAppendable {
    
    func hgtable(shouldAddRowToTable table: HGTable) -> Bool  {
        
        if table.parentRow == notSelected {
            return false
        }
        
        return appDelegate.store.project.enums[table.parentRow].editable
    }
    
    func hgtable(willAddRowToTable table: HGTable) {
        appDelegate.store.project.enums[table.parentRow].cases.append(EnumCase.new)
    }
    
    func hgtable(table: HGTable, shouldDeleteRows rows: [Int]) -> Option {
        
        return appDelegate.store.project.enums[table.parentRow].editable == true ? .Yes : .No
    }
    
    func hgtable(table: HGTable, willDeleteRows rows: [Int]) {
        appDelegate.store.project.enums[table.parentRow].cases.removeIndexes(rows)
    }
}

// MARK: HGTableFieldEditable
extension EnumCasesVC: HGTableFieldEditable {
    
    func hgtable(table: HGTable, shouldEditRow row: Int, field: Int) -> Bool {
        if field == 0 {
            return appDelegate.store.project.enums[table.parentRow].editable
        }
        return false
    }
    
    func hgtable(table: HGTable, didEditRow row: Int, field: Int, withString string: String) {
        var enumcase = appDelegate.store.project.enums[table.parentRow].cases[row]
        enumcase.string = string
        appDelegate.store.project.enums[table.parentRow].cases[row] = enumcase
    }
    
}

