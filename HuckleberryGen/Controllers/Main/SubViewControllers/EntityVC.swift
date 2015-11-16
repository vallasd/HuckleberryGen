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
    
    let cellType: HGCellType = HGCellType.DefaultCell
    let hgtable: HGTable = HGTable()
    
    // MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hgtable.delegate = self
    }
    
}

// MARK: HGTableDisplayable
extension EntityVC: HGTableDisplayable {
    
    func tableview(fortable table: HGTable) -> HGTableView! {
        return tableview
    }
    
    func numberOfRows(fortable table: HGTable) -> Int {
        return HuckleberryGen.store.hgmodel.entities.count
    }
    
    func hgtable(table: HGTable, heightForRow row: Int) -> CGFloat {
        return 50.0
    }
    
    func hgtable(table: HGTable, cellForRow row: Int) -> HGCellType {
        return cellType
    }
    
    func hgtable(table: HGTable, dataForRow row: Int) -> HGCellData {
        let entity = HuckleberryGen.store.hgmodel.entities[row]
        return HGCellData.defaultCell(
            field0: HGFieldData(title: entity.name),
            field1: HGFieldData(title: ""),
            image0: HGImageData(title: "", image: NSImage(named: "entityIcon"))
        )
    }
}

// MARK: HGTableObservable
extension EntityVC: HGTableObservable {
    
    func observeNotification(fortable table: HGTable) -> String {
        return HGNotif.shared.notifEntityUpdate
    }
}

// MARK: HGTablePostable
extension EntityVC: HGTablePostable {
    
    func selectNotification(fortable table: HGTable) -> String {
        return HGNotif.shared.notifNewEntitySelected
    }
}

// MARK: HGTableRowSelectable
extension EntityVC: HGTableRowSelectable {
    
    func hgtable(table: HGTable, shouldSelectRow row: Int) -> Bool {
        return true
    }
}

// MARK: HGTableItemEditable
extension EntityVC: HGTableItemEditable {
    
    func hgtable(table: HGTable, shouldEditRow row: Int, tag: Int, type: HGCellItemType) -> HGOption {
        if type == .Field && tag == 0 { return .Yes } // Entity Name
        return .No
    }
    
    func hgtable(table: HGTable, didEditRow row: Int, tag: Int, withData data: HGCellItemData) {
        if tag == 0 && data is HGFieldData {
            var entity = HuckleberryGen.store.hgmodel.entities[row]
            entity.name = data.title
            HuckleberryGen.store.hgmodel.entities[row] = entity
        }
    }
}

// MARK: HGTableRowAppendable
extension EntityVC: HGTableRowAppendable {
    
    func hgtable(shouldAddRowToTable table: HGTable) -> Bool  {
        return true
    }
    
    func hgtable(willAddRowToTable table: HGTable) {
        HuckleberryGen.store.hgmodel.entities.append(Entity.new)
    }
    
    func hgtable(table: HGTable, shouldDeleteRows rows: [Int]) -> HGOption {
        
        for row in rows {
            let entity = HuckleberryGen.store.hgmodel.entities[row]
            if entity.attributes.count > 0 || entity.relationships.count > 0 {
                return .AskUser
            }
        }
        
        return .Yes
    }
    
    func hgtable(table: HGTable, willDeleteRows rows: [Int]) {
        HuckleberryGen.store.hgmodel.entities.removeIndexes(rows)
    }
}


