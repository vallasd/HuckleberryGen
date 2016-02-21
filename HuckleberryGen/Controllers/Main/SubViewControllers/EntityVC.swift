//
//  EntityVC.swift
//  HuckleberryGen
//
//  Created by David Vallas on 7/23/15.
//  Copyright © 2015 Phoenix Labs. All rights reserved.
//

import Cocoa

class EntityVC: NSViewController {

    // MARK: Public Variables
    
    @IBOutlet weak var tableview: HGTableView!
    
    let cellType = CellType.DefaultCell
    
    var hgtable: HGTable!
    
    // MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hgtable = HGTable(tableview: tableview, delegate: self)
    }
    
}

// MARK: HGTableDisplayable
extension EntityVC: HGTableDisplayable {
    
    func tableview(fortable table: HGTable) -> HGTableView! {
        return tableview
    }
    
    func numberOfRows(fortable table: HGTable) -> Int {
        return appDelegate.store.project.entities.count
    }
    
    func hgtable(table: HGTable, heightForRow row: Int) -> CGFloat {
        return 50.0
    }
    
    func hgtable(table: HGTable, cellForRow row: Int) -> CellType {
        return cellType
    }
    
    func hgtable(table: HGTable, dataForRow row: Int) -> HGCellData {
        let entity = appDelegate.store.project.entities[row]
        return HGCellData.defaultCell(
            field0: HGFieldData(title: entity.typeRep),
            field1: HGFieldData(title: entity.hashRep),
            image0: HGImageData(title: "", image: NSImage(named: "entityIcon"))
        )
    }
}

// MARK: HGTableObservable
extension EntityVC: HGTableObservable {
    
    func observeNotifications(fortable table: HGTable) -> [String] {
        return appDelegate.store.notificationNames(forNotifTypes: [.EntityUpdated])
    }
}

// MARK: HGTablePostable
extension EntityVC: HGTablePostable {
    
    func selectNotification(fortable table: HGTable) -> String {
        return appDelegate.store.notificationName(forNotifType: .EntitySelected)
    }
}

// MARK: HGTableRowSelectable
extension EntityVC: HGTableRowSelectable {
    
    func hgtable(table: HGTable, shouldSelectRow row: Int) -> Bool {
        return true
    }
}

// MARK: HGTableFieldEditable
extension EntityVC: HGTableFieldEditable {
    
    func hgtable(table: HGTable, shouldEditRow row: Int, field: Int) -> Bool {
        if field == 0 { return true }
        return false
    }
    
    func hgtable(table: HGTable, didEditRow row: Int, field: Int, withString string: String) {
        
        var entity = appDelegate.store.project.entities[row]
        
        entity.typeRep = string.changeToTypeRep ?? string
        
        appDelegate.store.project.entities[row] = entity
    
        // in case string was changed
        if entity.typeRep != string { table.update() }
    }
    
}

// MARK: HGTableItemSelectable
extension EntityVC: HGTableItemSelectable {
    
    func hgtable(table: HGTable, shouldSelect row: Int, tag: Int, type: CellItemType) -> Bool {
        
        /// select hash field
        if tag == 1 {
            return true
        }
        
        return false
    }
    
    func hgtable(table: HGTable, didSelectRow row: Int, tag: Int, type: CellItemType) {
        
        /// set hash
        let entity = appDelegate.store.getEntity(index: row)
        let hashes = appDelegate.store.project.hashables(forEntity: entity)
        let context = SBD_Hash(entityIndex: row, hashes: hashes)
        let boarddata = SelectionBoard.boardData(withContext: context)
        appDelegate.mainWindowController.boardHandler.start(withBoardData: boarddata)
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
    
    func hgtable(table: HGTable, shouldDeleteRows rows: [Int]) -> Option {
        
        for row in rows {
            let entity = appDelegate.store.project.entities[row]
            if entity.attributes.count > 0 || entity.relationships.count > 0 {
                return .AskUser
            }
        }
        
        return .Yes
    }
    
    func hgtable(table: HGTable, willDeleteRows rows: [Int]) {
        
        appDelegate.store.deleteEntities(atIndexes: rows)
    }
}


