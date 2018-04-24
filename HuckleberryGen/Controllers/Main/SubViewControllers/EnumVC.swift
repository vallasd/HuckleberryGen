//
//  EnumVC.swift
//  HuckleberryGen
//
//  Created by David Vallas on 8/19/15.
//  Copyright © 2015 Phoenix Labs.
//
//  All Rights Reserved.

import Foundation
import Cocoa

protocol EnumVCDelegate: AnyObject {
    func enumVC(_ vc: EnumVC, selectedEnum: Enum)
}

/// NSViewController that displays a table of Enums
class EnumVC: NSViewController {
    
    // MARK: Public Variables
    
    @IBOutlet weak var tableview: HGTableView! { didSet { hgtable = HGTable(tableview: tableview, delegate: self) } }
    
    var hgtable: HGTable!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

// MARK: HGTableDisplayable
extension EnumVC: HGTableDisplayable {
    
    func numberOfItems(fortable table: HGTable) -> Int {
        return appDelegate.store.project.enums.count
    }
    
    func cellType(fortable table: HGTable) -> CellType {
        return CellType.defaultCell
    }
    
    func hgtable(_ table: HGTable, dataForIndex index: Int) -> HGCellData {
        let enuM = appDelegate.store.project.enums[index]
        return HGCellData.defaultCell(
            field0: HGFieldData(title: enuM.name),
            field1: HGFieldData(title: ""),
            image0: HGImageData(title: "", image: #imageLiteral(resourceName: "enumIcon"))
        )
    }
}

extension EnumVC: HGTableObservable {
    
    func observeNotifications(fortable table: HGTable) -> [String] {
        return appDelegate.store.notificationNames(forNotifTypes: [.enumUpdated])
    }
}

extension EnumVC: HGTablePostable {
    
    func selectNotification(fortable table: HGTable) -> String {
        return appDelegate.store.notificationName(forNotifType: .enumSelected)
    }
}

extension EnumVC: HGTableLocationSelectable {
    
    func hgtable(_ table: HGTable, shouldSelectLocation loc: HGTableLocation) -> Bool {
        return true
    }
    
    func hgtable(_ table: HGTable, didSelectLocation loc: HGTableLocation) {
        // do nothing
    }
}

extension EnumVC: HGTableFieldEditable {
    
    func hgtable(_ table: HGTable, shouldEditRow row: Int, field: Int) -> Bool {
        if field == 0 {
            let editable = appDelegate.store.project.enums[row].editable
            return editable
        }
        return false
    }
    
    func hgtable(_ table: HGTable, didEditRow row: Int, field: Int, withString string: String) {
        var enuM = appDelegate.store.project.enums[row]
        enuM.name = string
        appDelegate.store.project.enums[row] = enuM
    }
    
}

extension EnumVC: HGTableRowAppendable {
    
    func hgtable(shouldAddRowToTable table: HGTable) -> Bool  {
        return true
    }
    
    func hgtable(willAddRowToTable table: HGTable) {
        let newEnum = Enum.new
        appDelegate.store.project.enums.append(newEnum)
    }
    
    func hgtable(_ table: HGTable, shouldDeleteRows rows: [Int]) -> Option {
        
        var willAskUser = false
        
        for row in rows {
            let enuM = appDelegate.store.project.enums[row]
            if enuM.editable == false {
                return .no
            }
            if enuM.cases.count > 0 {
                willAskUser = true
            }
        }
        
        if willAskUser { return .askUser }
        
        return .yes
    }
    
    func hgtable(_ table: HGTable, willDeleteRows rows: [Int]) {
        appDelegate.store.project.enums.removeIndexes(rows)
    }
}
