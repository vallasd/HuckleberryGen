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
        return appDelegate.store.project.entities.count
    }
    
    func cellType(fortable table: HGTable) -> CellType {
        return CellType.defaultCell
    }
    
    func hgtable(_ table: HGTable, dataForIndex index: Int) -> HGCellData {
        let entity = appDelegate.store.project.entities[index]
        return HGCellData.defaultCell(
            field0: HGFieldData(title: entity.typeRep),
            field1: HGFieldData(title: entity.hashRep),
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
    
    func selectNotification(fortable table: HGTable) -> String {
        return appDelegate.store.notificationName(forNotifType: .entitySelected)
    }
}

// MARK: HGTableLocationSelectable
extension EntityVC: HGTableLocationSelectable {
    
    func hgtable(_ table: HGTable, shouldSelectLocation loc: HGTableLocation) -> Bool {
        
        // if a row or hash field, return true
        if loc.type == .row { return true }
        if loc.type == .field && loc.typeIndex == 1 { return true }
        return false
    }
    
    func hgtable(_ table: HGTable, didSelectLocation loc: HGTableLocation) {
        
        // if hash field, display selection board of hashes
        if loc.type == .field && loc.typeIndex == 1 {
            let entity = appDelegate.store.getEntity(index: loc.index)
            let hashes = appDelegate.store.project.hashables(forEntity: entity)
            let context = SBD_Hash(entityIndex: loc.index, hashes: hashes)
            let boarddata = SelectionBoard.boardData(withContext: context)
            appDelegate.mainWindowController.boardHandler.start(withBoardData: boarddata)
        }
    }
}

// MARK: HGTableFieldEditable
extension EntityVC: HGTableFieldEditable {
    
    func hgtable(_ table: HGTable, shouldEditRow row: Int, field: Int) -> Bool {
        if field == 0 { return true }
        return false
    }
    
    func hgtable(_ table: HGTable, didEditRow row: Int, field: Int, withString string: String) {
        
        var entity = appDelegate.store.project.entities[row]
        
        entity.typeRep = string.changeToTypeRep ?? string
        
        appDelegate.store.project.entities[row] = entity
    
        // in case string was changed
        if entity.typeRep != string { table.update() }
    }
    
}

// MARK: HGTableRowAppendable
extension EntityVC: HGTableRowAppendable {
    
    func hgtable(shouldAddRowToTable table: HGTable) -> Bool  {
        return true
    }
    
    func hgtable(willAddRowToTable table: HGTable) {
        var entity = Entity.new
        if let itr = entity.iteratedTypeRep(forArray: appDelegate.store.project.entities) { entity.typeRep = itr }
        appDelegate.store.project.entities.append(entity)
    }
    
    func hgtable(_ table: HGTable, shouldDeleteRows rows: [Int]) -> Option {
        
        for row in rows {
            let entity = appDelegate.store.project.entities[row]
            if entity.attributes.count > 0 || entity.relationships.count > 0 {
                return .askUser
            }
        }
        
        return .yes
    }
    
    func hgtable(_ table: HGTable, willDeleteRows rows: [Int]) {
        let _ = appDelegate.store.deleteEntities(atIndexes: rows)
    }
}


