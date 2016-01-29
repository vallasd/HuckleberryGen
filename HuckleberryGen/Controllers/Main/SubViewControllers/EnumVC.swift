//
//  EnumVC.swift
//  HuckleberryGen
//
//  Created by David Vallas on 8/19/15.
//  Copyright © 2015 Phoenix Labs. All rights reserved.
//

import Foundation

//
//  EntityVC.swift
//  HuckleberryGen
//
//  Created by David Vallas on 7/23/15.
//  Copyright © 2015 Phoenix Labs. All rights reserved.
//

import Cocoa

protocol EnumVCDelegate: AnyObject {
    func enumVC(vc: EnumVC, selectedEnum: Enum)
}

/// NSViewController that displays a table of Enums
class EnumVC: NSViewController {
    
    // MARK: Public Variables
    
    @IBOutlet weak var tableview: HGTableView! { didSet { hgtable = HGTable(tableview: tableview, delegate: self) } }
    
    let cellType = CellType.DefaultCell
    
    var hgtable: HGTable!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

// MARK: HGTableDisplayable
extension EnumVC: HGTableDisplayable {
    
    func tableview(fortable table: HGTable) -> HGTableView! {
        return tableview
    }
    
    func numberOfRows(fortable table: HGTable) -> Int {
        return appDelegate.store.project.enums.count
    }
    
    func hgtable(table: HGTable, heightForRow row: Int) -> CGFloat {
        return 50.0
    }
    
    func hgtable(table: HGTable, cellForRow row: Int) -> CellType {
        return cellType
    }
    
    func hgtable(table: HGTable, dataForRow row: Int) -> HGCellData {
        let enuM = appDelegate.store.project.enums[row]
        return HGCellData.defaultCell(
            field0: HGFieldData(title: enuM.name),
            field1: HGFieldData(title: ""),
            image0: HGImageData(title: "", image: NSImage(named: "enumIcon"))
        )
    }
}

// MARK: HGTableObservable
extension EnumVC: HGTableObservable {
    
    func observeNotifications(fortable table: HGTable) -> [String] {
        return appDelegate.store.notificationNames(forNotifTypes: [.EnumUpdated])
    }
}

// MARK: HGTablePostable
extension EnumVC: HGTablePostable {
    
    func selectNotification(fortable table: HGTable) -> String {
        return appDelegate.store.notificationName(forNotifType: .EnumSelected)
    }
}

// MARK: HGTableRowSelectable
extension EnumVC: HGTableRowSelectable {
    
    func hgtable(table: HGTable, shouldSelectRow row: Int) -> Bool {
        return true
    }
}

// MARK: HGTableFieldEditable
extension EnumVC: HGTableFieldEditable {
    
    func hgtable(table: HGTable, shouldEditRow row: Int, field: Int) -> Bool {
        if field == 0 {
            let editable = appDelegate.store.project.enums[row].editable
            return editable
        }
        return false
    }
    
    func hgtable(table: HGTable, didEditRow row: Int, field: Int, withString string: String) {
        var enuM = appDelegate.store.project.enums[row]
        enuM.name = string
        appDelegate.store.project.enums[row] = enuM
    }
    
}

// MARK: HGTableRowAppendable
extension EnumVC: HGTableRowAppendable {
    
    func hgtable(shouldAddRowToTable table: HGTable) -> Bool  {
        return true
    }
    
    func hgtable(willAddRowToTable table: HGTable) {
        let newEnum = Enum.new
        appDelegate.store.project.enums.append(newEnum)
    }
    
    func hgtable(table: HGTable, shouldDeleteRows rows: [Int]) -> Option {
        
        var willAskUser = false
        
        for row in rows {
            let enuM = appDelegate.store.project.enums[row]
            if enuM.editable == false {
                return .No
            }
            if enuM.cases.count > 0 {
                willAskUser = true
            }
        }
        
        if willAskUser { return .AskUser }
        
        return .Yes
    }
    
    func hgtable(table: HGTable, willDeleteRows rows: [Int]) {
        appDelegate.store.project.enums.removeIndexes(rows)
    }
}