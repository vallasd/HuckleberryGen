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
    
    fileprivate var editingLocation: HGTableLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hgtable = HGTable(tableview: tableview, delegate: self)
    }
}

// MARK: HGTableDisplayable
extension EnumCasesVC: HGTableDisplayable {
    
    func numberOfItems(fortable table: HGTable) -> Int {
        return table.parentRow == notSelected ? 0 : appDelegate.store.project.enums[table.parentRow].cases.count
    }
    
    func cellType(fortable table: HGTable) -> CellType {
        return CellType.fieldCell2
    }
   
    func hgtable(_ table: HGTable, dataForIndex index: Int) -> HGCellData {
        let casE = appDelegate.store.project.enums[table.parentRow].cases[index]
        return HGCellData.fieldCell2(
            field0: HGFieldData(title: casE.string),
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
extension EnumCasesVC: HGTableRowSelectable {
    
    func hgtable(_ table: HGTable, shouldSelectRow row: Int) -> Bool {
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
    
    func hgtable(_ table: HGTable, shouldDeleteRows rows: [Int]) -> Option {
        
        return appDelegate.store.project.enums[table.parentRow].editable == true ? .yes : .no
    }
    
    func hgtable(_ table: HGTable, willDeleteRows rows: [Int]) {
        appDelegate.store.project.enums[table.parentRow].cases.removeIndexes(rows)
    }
}

// MARK: HGTableFieldEditable
extension EnumCasesVC: HGTableFieldEditable {
    
    func hgtable(_ table: HGTable, shouldEditRow row: Int, field: Int) -> Bool {
        if field == 0 {
            return appDelegate.store.project.enums[table.parentRow].editable
        }
        return false
    }
    
    func hgtable(_ table: HGTable, didEditRow row: Int, field: Int, withString string: String) {
        var enumcase = appDelegate.store.project.enums[table.parentRow].cases[row]
        enumcase.string = string
        appDelegate.store.project.enums[table.parentRow].cases[row] = enumcase
    }
    
}

