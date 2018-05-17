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
        enums = project.enums.sorted { $0.name < $1.name }
        return enums.count
    }
    
    func cellType(fortable table: HGTable) -> CellType {
        return CellType.mixedCell1
    }
    
    func hgtable(_ table: HGTable, dataForIndex index: Int) -> HGCellData {
        let enuM = enums[index]
        return HGCellData.mixedCell1(field0: HGFieldData(title: enuM.name),
                                     field1: HGFieldData(title: enuM.value1Name),
                                     field2: HGFieldData(title: enuM.value2Name),
                                     image0: HGImageData(title: "", image: #imageLiteral(resourceName: "enumIcon")),
                                     check0: HGCheckData(title: "isString", state: enuM.value1String),
                                     check1: HGCheckData(title: "isString", state: enuM.value2String))
    }
}

extension EnumVC: HGTableObservable {
    
    func observeNotifications(fortable table: HGTable) -> [String] {
        return appDelegate.store.notificationNames(forNotifTypes: [.enumUpdated])
    }
}

extension EnumVC: HGTablePostable {
    
    func postData(fortable table: HGTable, atIndex: Int) -> HGTablePostableData {
        let enumName = atIndex == notSelected ? "" : enums[atIndex].name
        let notification = appDelegate.store.notificationNames(forNotifTypes: [.enumSelected]).first!
        let postData = HGTablePostableData(notificationName: notification, identifier: enumName)
        return postData
    }
}

extension EnumVC: HGTableLocationSelectable {
    
    func hgtable(_ table: HGTable, shouldSelectLocation loc: HGTableLocation) -> Bool {
        if loc.type == .row || loc.type == .check { return true }
        return false
    }
    
    func hgtable(_ table: HGTable, didSelectLocation loc: HGTableLocation) {
        
        if loc.type == .check {
            let enuM = enums[loc.index]
            let isString = loc.typeIndex == 0 ? enuM.value1String : enuM.value2String
            var keyDict: EnumKeyDict!
            
            switch loc.typeIndex {
            case 0: keyDict = isString ? [.value1String: false] : [.value1String: true]
            case 1: keyDict = isString ? [.value2String: false] : [.value2String: true]
            default:
                HGReport.shared.mappingFailed(HGCell.self, object: loc.index, returning: "nothing")
            }
            
            let enuM2 = project.updateEnum(keyDict: keyDict, name: enuM.name)
            if enuM2 != nil {
                enums[loc.index] = enuM2!
            }
        }
    }
}

extension EnumVC: HGTableFieldEditable {
    
    func hgtable(_ table: HGTable, shouldEditRow row: Int, field: Int) -> Bool {
        return true
    }
    
    func hgtable(_ table: HGTable, didEditRow row: Int, field: Int, withString string: String) {
        
        let enumName = enums[row].name
        var keyDict: EnumKeyDict!
        
        switch field {
        case 0: keyDict = [.name: string]
        case 1: keyDict = [.value1Name: string]
        case 2: keyDict = [.value2Name: string]
        default:
            HGReport.shared.mappingFailed(HGCell.self, object: field, returning: "nothing")
        }
        
        let enuM = project.updateEnum(keyDict: keyDict, name: enumName)
        if enuM != nil {
            enums[row] = enuM!
        }
    }
}

extension EnumVC: HGTableRowAppendable {
    
    func hgtable(shouldAddRowToTable table: HGTable) -> Bool  {
        return true
    }
    
    func hgtable(willAddRowToTable table: HGTable) {
        let enuM = project.createIteratedEnum() ?? Enum.encodeError
        enums.append(enuM)
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
            let success = project.deleteEnum(name: enuM.name)
            if success {
                enums.remove(at: row)
            }
        }
    }
}
