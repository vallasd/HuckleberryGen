////
////  RelationshipVC.swift
////  HuckleberryGen
////
////  Created by David Vallas on 8/17/15.
////  Copyright © 2015 Phoenix Labs.
//
//  All Rights Reserved.//
//
import Cocoa

class RelationshipVC: NSViewController {
    
    @IBOutlet weak var tableview: HGTableView!
    
    var  hgtable: HGTable!
    
    let celltype = CellType.mixedCell1
    
     // MARK: View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        hgtable = HGTable(tableview: tableview, delegate: self)
    }
}

// MARK: HGTableDisplayable
extension RelationshipVC: HGTableDisplayable {
    
    func numberOfItems(fortable table: HGTable) -> Int {
        return table.parentRow == notSelected ? 0 : appDelegate.store.project.entities[table.parentRow].relationships.count
    }
    
    func cellType(fortable table: HGTable) -> CellType {
        return celltype
    }
    
    func hgtable(_ table: HGTable, dataForIndex index: Int) -> HGCellData {
        
        let relationship = appDelegate.store.project.entities[table.parentRow].relationships[index]
        
        return HGCellData.mixedCell1(
            field0: HGFieldData(title: relationship.varRep),
            field1: HGFieldData(title: "Entity:"),
            field2: HGFieldData(title: relationship.typeRep),
            field3: HGFieldData(title: "Deletion Rule:"),
            field4: HGFieldData(title: relationship.deletionRule.string),
            image0: HGImageData(title: "", image: relationship.relType.image)
        )
    }
}

extension RelationshipVC: HGTableObservable {
    
    func observeNotifications(fortable table: HGTable) -> [String] {
        return appDelegate.store.notificationNames(forNotifTypes: [.entitySelected, .relationshipUpdated])
    }
}

extension RelationshipVC: HGTableLocationSelectable {
    
    func hgtable(_ table: HGTable, shouldSelectLocation loc: HGTableLocation) -> Bool {
        
        if loc.type == .row {
            return true
        }
        
        /// Select Relationship's Entity or Deletion Rule
        if loc.type == .field && ( loc.tag == 1 || loc.tag == 4 ) {
            return true
        }
        
        // Select Relationship's Type (Too Many or Too One)
        if loc.type == .image && loc.tag == 0 {
            return true
        }
        
        return false
    }
    
    func hgtable(_ table: HGTable, didSelectLocation loc: HGTableLocation) {
        
        /// Set Relationship's Type
        if loc.type == .image && loc.tag == 0 {
            let context = SBD_RelationshipType(entityIndex: table.parentRow, relationshipIndex: loc.index)
            let boarddata = SelectionBoard.boardData(withContext: context)
            appDelegate.mainWindowController.boardHandler.start(withBoardData: boarddata)
        }
        
        // Set Relationship's Entity
        if loc.type == .field && loc.tag == 2 {
            let context = SBD_Entities(entityIndex: hgtable.parentRow, relationshipIndex: loc.index)
            let boarddata = SelectionBoard.boardData(withContext: context)
            appDelegate.mainWindowController.boardHandler.start(withBoardData: boarddata)
        }
            
            // Set Relationship's Deletion Rule
        else if loc.type == .field && loc.tag == 4 {
            let context = SBD_DeletionRules(entityIndex: hgtable.parentRow, relationshipIndex: loc.index)
            let boarddata = SelectionBoard.boardData(withContext: context)
            appDelegate.mainWindowController.boardHandler.start(withBoardData: boarddata)
        }
    }
    
}

extension RelationshipVC: HGTableRowAppendable {
    
    func hgtable(shouldAddRowToTable table: HGTable) -> Bool  {
        return table.parentRow != notSelected
    }
    
    func hgtable(willAddRowToTable table: HGTable) {
        appDelegate.store.project.entities[table.parentRow].relationships.append(Relationship.new)
    }
    
    func hgtable(_ table: HGTable, shouldDeleteRows rows: [Int]) -> Option {
        return .yes
    }
    
    func hgtable(_ table: HGTable, willDeleteRows rows: [Int]) {
        appDelegate.store.project.entities[table.parentRow].relationships.removeIndexes(rows)
    }
}
