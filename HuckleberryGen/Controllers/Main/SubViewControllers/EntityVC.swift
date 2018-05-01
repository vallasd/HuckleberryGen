//
//  EntityVC.swift
//  HuckleberryGen
//
//  Created by David Vallas on 7/23/15.
//  Copyright © 2015 Phoenix Labs.
//
//  All Rights Reserved.

import Cocoa

class EntityVC: NSViewController {

    // MARK: Public Variables
    
    @IBOutlet weak var tableview: HGTableView!
    
    var entities: [Entity] = []
    
    var hgtable: HGTable!
    
    // MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hgtable = HGTable(tableview: tableview, delegate: self)
    }
}

// MARK: HGTableDisplayable
extension EntityVC: HGTableDisplayable {
    
    func numberOfItems(fortable table: HGTable) -> Int {
        entities = project.entities.sorted { $0.name < $1.name }
        return entities.count
    }
    
    func cellType(fortable table: HGTable) -> CellType {
        return CellType.defaultCell
    }
    
    func hgtable(_ table: HGTable, dataForIndex index: Int) -> HGCellData {
        let entity = entities[index]
        return HGCellData.defaultCell(
            field0: HGFieldData(title: entity.name),
            field1: HGFieldData(title: ""),
            image0: HGImageData(title: "", image: #imageLiteral(resourceName: "entityIcon"))
        )
    }
}

// MARK: HGTableObservable
extension EntityVC: HGTableObservable {
    
    func observeNotifications(fortable table: HGTable) -> [String] {
        return appDelegate.store.notificationNames(forNotifTypes: [.entityUpdated])
    }
}

// MARK: HGTablePostable
extension EntityVC: HGTablePostable {
    
    func postData(fortable table: HGTable, atIndex: Int) -> HGTablePostableData {
        let name = atIndex == notSelected ? "" : entities[atIndex].name
        let postData = HGTablePostableData(notificationName: .entitySelected, identifier: name)
        return postData
    }
}

// MARK: HGTableLocationSelectable
extension EntityVC: HGTableLocationSelectable {
    
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
extension EntityVC: HGTableFieldEditable {
    
    func hgtable(_ table: HGTable, shouldEditRow row: Int, field: Int) -> Bool {
        if field == 0 { return true }
        return false
    }
    
    func hgtable(_ table: HGTable, didEditRow row: Int, field: Int, withString string: String) {
        let entityName = entities[row].name
        let keyDict: EntityKeyDict = [.name: string]
        let entity = project.updateEntity(keyDict: keyDict, name: entityName) ?? Entity.encodeError
        entities[row] = entity
    }
}

// MARK: HGTableRowAppendable
extension EntityVC: HGTableRowAppendable {
    
    func hgtable(shouldAddRowToTable table: HGTable) -> Bool  {
        return true
    }
    
    func hgtable(willAddRowToTable table: HGTable) {
        let entity = project.createIteratedEntity() ?? Entity.encodeError
        entities.append(entity)
    }
    
    func hgtable(_ table: HGTable, shouldDeleteRows rows: [Int]) -> Option {
        
        for row in rows {
            let entity = entities[row]
            if entity.attributes.count > 0 {
                return .askUser
            }
        }
        
        return .yes
    }
    
    func hgtable(_ table: HGTable, willDeleteRows rows: [Int]) {
        for row in rows {
            let name = entities[row].name
            let success = project.deleteEntity(name: name)
            if success {
                entities.remove(at: row)
            }
        }
    }
}


