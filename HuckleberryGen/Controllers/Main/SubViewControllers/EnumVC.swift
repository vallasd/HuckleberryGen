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
    
    @IBOutlet weak var tableview: HGTableView!
    
    let cellType: HGCellType = HGCellType.DefaultCell
    let hgtable: HGTable = HGTable()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hgtable.delegate = self
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
    
    func hgtable(table: HGTable, cellForRow row: Int) -> HGCellType {
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
    
    func observeNotification(fortable table: HGTable) -> String {
        return appDelegate.store.notificationName(forNotifType: .EnumUpdated)
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

// MARK: HGTableItemEditable
extension EnumVC: HGTableItemEditable {
    
    func hgtable(table: HGTable, shouldEditRow row: Int, tag: Int, type: HGCellItemType) -> HGOption {
        if type == .Field && tag == 0 { return .Yes } // Entity Name
        return .No
    }
    
    func hgtable(table: HGTable, didEditRow row: Int, tag: Int, withData data: HGCellItemData) {
        if tag == 0 && data is HGFieldData {
            var enuM = appDelegate.store.project.enums[row]
            enuM.name = data.title
            appDelegate.store.project.enums[row] = enuM
        }
    }
}

// MARK: HGTableRowAppendable
extension EnumVC: HGTableRowAppendable {
    
    func hgtable(shouldAddRowToTable table: HGTable) -> Bool  {
        return true
    }
    
    func hgtable(willAddRowToTable table: HGTable) {
        
        appDelegate.store.project.enums.append(Enum.new)
    }
    
    func hgtable(table: HGTable, shouldDeleteRows rows: [Int]) -> HGOption {
        
        for row in rows {
            let enuM = appDelegate.store.project.enums[row]
            if enuM.cases.count > 0 {
                return .AskUser
            }
        }
        
        return .Yes
    }
    
    func hgtable(table: HGTable, willDeleteRows rows: [Int]) {
        appDelegate.store.project.enums.removeIndexes(rows)
    }
}