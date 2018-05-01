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
    
    var enums: [Enum] = []
    
    var hgtable: HGTable!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

// MARK: HGTableDisplayable
extension EnumVC: HGTableDisplayable {
    
    func numberOfItems(fortable table: HGTable) -> Int {
        enums = project.enums.sorted { $0.name > $1.name }
        return enums.count
    }
    
    func cellType(fortable table: HGTable) -> CellType {
        return CellType.defaultCell
    }
    
    func hgtable(_ table: HGTable, dataForIndex index: Int) -> HGCellData {
        let enuM = enums[index]
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
    
    func postData(fortable table: HGTable, atIndex: Int) -> HGTablePostableData {
        let enumName = enums[atIndex].name
        let postData = HGTablePostableData(notificationName: .enumSelected, identifier: enumName)
        return postData
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
        return true
    }
    
    func hgtable(_ table: HGTable, didEditRow row: Int, field: Int, withString string: String) {
        let enuM = enums[row]
        let keyDict: EnumKeyDict = [.name: string]
        let _ = project.updateEnum(keyDict: keyDict, name: enuM.name)
    }
}

extension EnumVC: HGTableRowAppendable {
    
    func hgtable(shouldAddRowToTable table: HGTable) -> Bool  {
        return true
    }
    
    func hgtable(willAddRowToTable table: HGTable) {
        let _ = project.createIteratedEnum()
    }
    
    func hgtable(_ table: HGTable, shouldDeleteRows rows: [Int]) -> Option {
        
        var willAskUser = false
        
        for row in rows {
            if enums[row].cases.count > 0 {
                willAskUser = true
            }
        }
        
        if willAskUser { return .askUser }
        
        return .yes
    }
    
    func hgtable(_ table: HGTable, willDeleteRows rows: [Int]) {
        for row in rows {
            let enuM = enums[row]
            let _ = project.deleteEnum(name: enuM.name)
        }
    }
}
