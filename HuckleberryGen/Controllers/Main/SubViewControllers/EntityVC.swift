//
//  EntityVC.swift
//  HuckleberryGen
//
//  Created by David Vallas on 7/23/15.
//  Copyright © 2015 Phoenix Labs.
//
//  This file is part of HuckleberryGen.
//
//  HuckleberryGen is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  HuckleberryGen is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with HuckleberryGen.  If not, see <http://www.gnu.org/licenses/>.

import Cocoa

class EntityVC: NSViewController {

    // MARK: Public Variables
    
    @IBOutlet weak var tableview: HGTableView!
    
    let cellType = CellType.defaultCell
    
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
    
    func hgtable(_ table: HGTable, heightForRow row: Int) -> CGFloat {
        return 50.0
    }
    
    func hgtable(_ table: HGTable, cellForRow row: Int) -> CellType {
        return cellType
    }
    
    func hgtable(_ table: HGTable, dataForRow row: Int) -> HGCellData {
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
        return appDelegate.store.notificationNames(forNotifTypes: [.entityUpdated])
    }
}

// MARK: HGTablePostable
extension EntityVC: HGTablePostable {
    
    func selectNotification(fortable table: HGTable) -> String {
        return appDelegate.store.notificationName(forNotifType: .entitySelected)
    }
}

// MARK: HGTableRowSelectable
extension EntityVC: HGTableRowSelectable {
    
    func hgtable(_ table: HGTable, shouldSelectRow row: Int) -> Bool {
        return true
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

// MARK: HGTableItemSelectable
extension EntityVC: HGTableItemSelectable {
    
    func hgtable(_ table: HGTable, shouldSelect row: Int, tag: Int, type: CellItemType) -> Bool {
        
        /// select hash field
        if tag == 1 {
            return true
        }
        
        return false
    }
    
    func hgtable(_ table: HGTable, didSelectRow row: Int, tag: Int, type: CellItemType) {
        
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
        
        appDelegate.store.deleteEntities(atIndexes: rows)
    }
}


