//
//  EnumCasesVC.swift
//  HuckleberryGen
//
//  Created by David Vallas on 10/2/15.
//  Copyright © 2015 Phoenix Labs.
//
//  All Rights Reserved.

import Cocoa

class EnumCasesVC: NSViewController {
    
    @IBOutlet weak var tableview: HGTableView!
    
    var hgtable: HGTable!
    
    var enumCases: [EnumCase]
    
    fileprivate var editingLocation: HGTableLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hgtable = HGTable(tableview: tableview, delegate: self)
    }
    
    func update() {
        
    }
}

// MARK: HGTableDisplayable
extension EnumCasesVC: HGTableDisplayable {
    
    func numberOfItems(fortable table: HGTable) -> Int {
        enumCases = table.parentName
        return table.parentRow == notSelected ? 0 : appDelegate.store.project.enums[table.parentRow].cases.count
    }
    
    func cellType(fortable table: HGTable) -> CellType {
        return CellType.fieldCell2
    }
   
    func hgtable(_ table: HGTable, dataForIndex index: Int) -> HGCellData {
        let enumcase = appDelegate.store.project.enums[table.parentRow].cases[index]
        return HGCellData.fieldCell2(
            field0: HGFieldData(title: enumcase),
            field1: HGFieldData(title: String(index))
        )
    }
}

// MARK: HGTableObservable
extension EnumCasesVC: HGTableObservable {
    
    func observeNotifications(fortable table: HGTable) -> [String] {
        return appDelegate.store.notificationNames(forNotifTypes: [.enumSelected, .enumCaseUpdated])
    }
}

// MARK: HGTableRowSelectable
extension EnumCasesVC: HGTableLocationSelectable {
    
    func hgtable(_ table: HGTable, shouldSelectLocation loc: HGTableLocation) -> Bool {
        return true
    }
    func hgtable(_ table: HGTable, didSelectLocation loc: HGTableLocation) {
        // do nothing
    }
}

// MARK: HGTableRowAppendable
extension EnumCasesVC: HGTableRowAppendable {
    
    func hgtable(shouldAddRowToTable table: HGTable) -> Bool  {
        
        if table.parentName == "" {
            return false
        }
        
        return true
    }
    
    func hgtable(willAddRowToTable table: HGTable) {
        let _ = appDelegate.store.createEnumCase(atEnumIndex: table.parentRow)
    }
    
    func hgtable(_ table: HGTable, shouldDeleteRows rows: [Int]) -> Option {
        return appDelegate.store.project.enums[table.parentRow].cases.count > 0 ? .askUser : .yes
    }
    
    func hgtable(_ table: HGTable, willDeleteRows rows: [Int]) {
        appDelegate.store.project.enums[table.parentRow].cases.removeIndexes(rows)
    }
}

// MARK: HGTableFieldEditable
extension EnumCasesVC: HGTableFieldEditable {
    
    func hgtable(_ table: HGTable, shouldEditRow row: Int, field: Int) -> Bool {
        return true
    }
    
    func hgtable(_ table: HGTable, didEditRow row: Int, field: Int, withString string: String) {
        let _ = appDelegate.store.updateEnumCase(name: string, atIndex: row, enumIndex: table.parentRow)
    }
    
}

