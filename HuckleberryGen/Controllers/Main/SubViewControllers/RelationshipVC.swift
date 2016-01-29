////
////  RelationshipVC.swift
////  HuckleberryGen
////
////  Created by David Vallas on 8/17/15.
////  Copyright © 2015 Phoenix Labs. All rights reserved.
////
//
import Cocoa

class RelationshipVC: NSViewController {
    
    @IBOutlet weak var tableview: HGTableView!
    
    var  hgtable: HGTable!
    
    let celltype = CellType.MixedCell1
    
     // MARK: View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        hgtable = HGTable(tableview: tableview, delegate: self)
    }
}

// MARK: HGTableDisplayable
extension RelationshipVC: HGTableDisplayable {
    
    func tableview(fortable table: HGTable) -> HGTableView! {
        return tableview
    }
    
    func numberOfRows(fortable table: HGTable) -> Int {
        return table.parentRow == notSelected ? 0 : appDelegate.store.project.entities[table.parentRow].relationships.count
    }
    
    func hgtable(table: HGTable, heightForRow row: Int) -> CGFloat {
        return 65.0
    }
    
    func hgtable(table: HGTable, cellForRow row: Int) -> CellType {
        return celltype
    }
    
    func hgtable(table: HGTable, dataForRow row: Int) -> HGCellData {
        
        let relationship = appDelegate.store.project.entities[table.parentRow].relationships[row]
        
        return HGCellData.mixedCell1(
            field0: HGFieldData(title: relationship.name),
            field1: HGFieldData(title: "Entity:"),
            field2: HGFieldData(title: relationship.entity),
            field3: HGFieldData(title: "Deletion Rule:"),
            field4: HGFieldData(title: relationship.deletionRule.string),
            image0: HGImageData(title: "", image: relationship.type.image)
        )
    }
}

// MARK: HGTableObservable
extension RelationshipVC: HGTableObservable {
    
    func observeNotifications(fortable table: HGTable) -> [String] {
        return appDelegate.store.notificationNames(forNotifTypes: [.EntitySelected, .RelationshipUpdated])
    }
}

// MARK: HGTableRowSelectable
extension RelationshipVC: HGTableRowSelectable {
    
    func hgtable(table: HGTable, shouldSelectRow row: Int) -> Bool {
        return true
    }
}

// MARK: HGTableRowAppendable
extension RelationshipVC: HGTableRowAppendable {
    
    func hgtable(shouldAddRowToTable table: HGTable) -> Bool  {
        return table.parentRow != notSelected
    }
    
    func hgtable(willAddRowToTable table: HGTable) {
        appDelegate.store.project.entities[table.parentRow].relationships.append(Relationship.new)
    }
    
    func hgtable(table: HGTable, shouldDeleteRows rows: [Int]) -> Option {
        return .Yes
    }
    
    func hgtable(table: HGTable, willDeleteRows rows: [Int]) {
        appDelegate.store.project.entities[table.parentRow].relationships.removeIndexes(rows)
    }
}

// MARK: HGTableItemSelectable
extension RelationshipVC: HGTableItemSelectable {
    
    func hgtable(table: HGTable, shouldSelect row: Int, tag: Int, type: CellItemType) -> Bool {
        
        /// Select Relationship's Entity or Deletion Rule
        if type == .Field && ( tag == 2 || tag == 4 ) {
            return true
        }
        
        // Select Relationship's Type (Too Many or Too One)
        if type == .Image && tag == 0 {
           return true
            
        }
        
        return false
    }
    
    func hgtable(table: HGTable, didSelectRow row: Int, tag: Int, type: CellItemType) {
        
        /// Set Relationship's Type
        if type == .Image && tag == 0 {
            let context = SBD_RelationshipType(entityIndex: table.parentRow, relationshipIndex: row)
            let boarddata = SelectionBoard.boardData(withContext: context)
            appDelegate.mainWindowController.boardHandler.start(withBoardData: boarddata)
        }
        
        // Set Relationship's Entity
        if type == .Field && tag == 2 {
            let context = SBD_Entities(entityIndex: hgtable.parentRow, relationshipIndex: row)
            let boarddata = SelectionBoard.boardData(withContext: context)
            appDelegate.mainWindowController.boardHandler.start(withBoardData: boarddata)
        }
            
        // Set Relationship's Deletion Rule
        else if type == .Field && tag == 4 {
            let context = SBD_DeletionRules(entityIndex: hgtable.parentRow, relationshipIndex: row)
            let boarddata = SelectionBoard.boardData(withContext: context)
            appDelegate.mainWindowController.boardHandler.start(withBoardData: boarddata)
        }
    }
    
}

// MARK: HGTableFieldEditable
extension RelationshipVC: HGTableFieldEditable {
    
    func hgtable(table: HGTable, shouldEditRow row: Int, field: Int) -> Bool {
        
        // Edit Relationship's Name
        if field == 0 {
            return true
        }
        return false
    }
    
    func hgtable(table: HGTable, didEditRow row: Int, field: Int, withString string: String) {
        var relationship = appDelegate.store.project.entities[table.parentRow].relationships[row]
        relationship.name = string
        appDelegate.store.project.entities[table.parentRow].relationships[row] = relationship
    }

    
}




//// MARK: HGTableItemEditable
//extension RelationshipVC: HGTableItemEditable {
//    
//    func hgtable(table: HGTable, shouldEditRow row: Int, tag: Int, type: CellItemType) -> Bool {
//        // TODO: FIX LINES 2 / 3
//        if type == .Field && tag == 0 { return true } // Relationship Name
//        if type == .Field && (tag == 2 || tag == 4) { return true } // Entity or Deletion Rule
//        if type == .Image && tag == 0 {
//            // present a selection board for Relationship Type
//            let context = SBD_RelationshipType(entityIndex: table.parentRow, relationshipIndex: row)
//            let boarddata = SelectionBoard.boardData(withContext: context)
//            appDelegate.mainWindowController.boardHandler.start(withBoardData: boarddata)
//        
//        }
//        return false
//    }
//    
//    func hgtable(table: HGTable, didEditRow row: Int, tag: Int, withData data: HGCellItemData) {
//        if tag == 0 && data is HGFieldData {
//            var relationship = appDelegate.store.project.entities[table.parentRow].relationships[row]
//            relationship.name = data.title
//            appDelegate.store.project.entities[table.parentRow].relationships[row] = relationship
//        }
//    }
//}
//
//// MARK: HGTableItemOptionable
//extension RelationshipVC: HGTableItemOptionable {
//    
//    func hgtable(table: HGTable, didSelectRowForOption row: Int, tag: Int, type: CellItemType) {
//        
//        let boardHandler = appDelegate.mainWindowController.boardHandler
//        
//        // Set Relationship's Entity
//        if type == .Field && tag == 2 {
//            let context = SBD_Entities(entityIndex: hgtable.parentRow, relationshipIndex: row)
//            let boarddata = SelectionBoard.boardData(withContext: context)
//            boardHandler.start(withBoardData: boarddata)
//        }
//            
//        // Set Relationship's Deletion Rule
//        else if type == .Field && tag == 4 {
//            let context = SBD_DeletionRules(entityIndex: hgtable.parentRow, relationshipIndex: row)
//            let boarddata = SelectionBoard.boardData(withContext: context)
//            boardHandler.start(withBoardData: boarddata)
//        }
//    }
//}
