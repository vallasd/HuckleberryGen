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
    
    var enumcases: [EnumCase] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hgtable = HGTable(tableview: tableview, delegate: self)
    }
}

// MARK: HGTableDisplayable
extension EnumCasesVC: HGTableDisplayable {
    
    func numberOfItems(fortable table: HGTable) -> Int {
        
        if table.parentName != "" {
            enumcases = project.enums.get(name: table.parentName)?.cases.sorted { $0.name < $1.name } ?? []
            return enumcases.count
        }
        
        return 0
    }
    
    func cellType(fortable table: HGTable) -> CellType {
        return CellType.fieldCell2
    }
   
    func hgtable(_ table: HGTable, dataForIndex index: Int) -> HGCellData {
        let enumcase = enumcases[index]
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
        if loc.type == .row {
            return true
        }
        return false
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
        let enumcase = project.createIteratedEnumCase(enumName: table.parentName) ?? EnumCase.encodeError
        enumcases.append(enumcase)
    }
    
    func hgtable(_ table: HGTable, shouldDeleteRows rows: [Int]) -> Option {
        return .yes
    }
    
    func hgtable(_ table: HGTable, willDeleteRows rows: [Int]) {
        for row in rows {
            let name = enumcases[row].name
            let success = project.deleteEnumCase(name: name, enumName: table.parentName)
            if success {
                enumcases.remove(at: row)
            }
        }
    }
}

// MARK: HGTableFieldEditable
extension EnumCasesVC: HGTableFieldEditable {
    
    func hgtable(_ table: HGTable, shouldEditRow row: Int, field: Int) -> Bool {
        
        if field == 0 {
            return true
        }
        
        return false
    }
    
    func hgtable(_ table: HGTable, didEditRow row: Int, field: Int, withString string: String) {
        let name = enumcases[row].name
        let keyDict: EnumCaseKeyDict = [.name: string]
        let enumcase = project.updateEnumCase(keysDict: keyDict, name: name, enumName: table.parentName)
        if enumcase != nil {
            enumcases[row] = enumcase!
        }
    }
    
}

