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
    
    var enumCases: [EnumCase] = []
    
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
        
        if table.parentName != "" {
            enumCases = project.enums.get(name: table.parentName)?.cases.sorted { $0.name > $1.name } ?? []
            return enumCases.count
        }
        
        return 0
    }
    
    func cellType(fortable table: HGTable) -> CellType {
        return CellType.fieldCell2
    }
   
    func hgtable(_ table: HGTable, dataForIndex index: Int) -> HGCellData {
        let enumcase = enumCases[index]
        return HGCellData.fieldCell2(
            field0: HGFieldData(title: enumcase.name),
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
        let _ = project.createIteratedEnumCase(enumName: table.parentName)
    }
    
    func hgtable(_ table: HGTable, shouldDeleteRows rows: [Int]) -> Option {
        return enumCases.count > 0 ? .askUser : .yes
    }
    
    func hgtable(_ table: HGTable, willDeleteRows rows: [Int]) {
        for row in rows {
            let name = enumCases[row].name
            let _ = project.deleteEnumCase(name: name, enumName: table.parentName)
        }
    }
}

// MARK: HGTableFieldEditable
extension EnumCasesVC: HGTableFieldEditable {
    
    func hgtable(_ table: HGTable, shouldEditRow row: Int, field: Int) -> Bool {
        return true
    }
    
    func hgtable(_ table: HGTable, didEditRow row: Int, field: Int, withString string: String) {
        let name = enumCases[row].name
        let keyDict: EnumCaseKeyDict = [.name: string]
        let _ = project.updateEnumCase(keysDict: keyDict, name: name, enumName: table.parentName)
    }
    
}

