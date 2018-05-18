//
//  JoinVC.swift
//  HuckleberryGen
//
//  Created by David Vallas on 5/17/18.
//  Copyright © 2018 Phoenix Labs. All rights reserved.
//

import Cocoa

class JoinVC: NSViewController {
    
    // MARK: Public Variables
    
    @IBOutlet weak var tableview: HGTableView!
    
    var joins: [Join] = []
    
    var hgtable: HGTable!
    
    // MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hgtable = HGTable(tableview: tableview, delegate: self)
    }
}

// MARK: HGTableDisplayable
extension JoinVC: HGTableDisplayable {
    
    func numberOfItems(fortable table: HGTable) -> Int {
        joins = project.joins.sorted { $0.name < $1.name }
        return joins.count
    }
    
    func cellType(fortable table: HGTable) -> CellType {
        return CellType.defaultCell
    }
    
    func hgtable(_ table: HGTable, dataForIndex index: Int) -> HGCellData {
        let join = joins[index]
        return HGCellData.defaultCell(
            field0: HGFieldData(title: join.name),
            field1: HGFieldData(title: ""),
            image0: HGImageData(title: "", image: #imageLiteral(resourceName: "entityIcon"))
        )
    }
}

// MARK: HGTableObservable
extension JoinVC: HGTableObservable {
    
    func observeNotifications(fortable table: HGTable) -> [String] {
        return appDelegate.store.notificationNames(forNotifTypes: [.entityUpdated])
    }
}

// MARK: HGTablePostable
extension JoinVC: HGTablePostable {
    
    func postData(fortable table: HGTable, atIndex: Int) -> HGTablePostableData {
        let name = atIndex == notSelected ? "" : joins[atIndex].name
        let notification = appDelegate.store.notificationNames(forNotifTypes: [.entitySelected]).first!
        let postData = HGTablePostableData(notificationName: notification, identifier: name)
        return postData
    }
}

// MARK: HGTableLocationSelectable
extension JoinVC: HGTableLocationSelectable {
    
    func hgtable(_ table: HGTable, shouldSelectLocation loc: HGTableLocation) -> Bool {
        // if a row or hash field, return true
        if loc.type == .row { return true }
        return false
    }
    
    func hgtable(_ table: HGTable, didSelectLocation loc: HGTableLocation) {
        // do nothing
    }
}

// MARK: HGTableFieldEditable
extension JoinVC: HGTableFieldEditable {
    
    func hgtable(_ table: HGTable, shouldEditRow row: Int, field: Int) -> Bool {
        if field == 0 { return true }
        return false
    }
    
    func hgtable(_ table: HGTable, didEditRow row: Int, field: Int, withString string: String) {
        let joinName = joins[row].name
        let keyDict: JoinKeyDict = [.name: string]
        let join = project.updateJoin(keyDict: keyDict, name: joinName)
        if join != nil {
            joins[row] = join!
        }
    }
}

// MARK: HGTableRowAppendable
extension JoinVC: HGTableRowAppendable {
    
    func hgtable(shouldAddRowToTable table: HGTable) -> Bool  {
        if project.entities.count == 0 { return false }
        return true
    }
    
    func hgtable(willAddRowToTable table: HGTable) {
        let join = project.createIteratedJoin() ?? Join.encodeError
        joins.append(join)
    }
    
    func hgtable(_ table: HGTable, shouldDeleteRows rows: [Int]) -> Option {
        
        for row in rows {
            let join = joins[row]
            if join.attributes.count > 0 {
                return .askUser
            }
        }
        
        return .yes
    }
    
    func hgtable(_ table: HGTable, willDeleteRows rows: [Int]) {
        for row in rows {
            let name = joins[row].name
            let success = project.deleteJoin(name: name)
            if success {
                joins.remove(at: row)
            }
        }
    }
}
