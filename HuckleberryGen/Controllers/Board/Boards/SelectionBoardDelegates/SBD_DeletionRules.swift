//
//  SBD_DeletionRules.swift
//  HuckleberryGen
//
//  Created by David Vallas on 1/12/16.
//  Copyright © 2016 Phoenix Labs.
//
//  All Rights Reserved.

import Foundation

/// context for a Selection Board of unique attributes
class SBD_DeletionRules: SelectionBoardDelegate {
    
    /// reference to the selection board
    weak var selectionBoard: SelectionBoard?
    
    /// index of Entity to be updated
    let entityIndex: Int!
    
    /// index of Relationship to be updated
    let relationshipIndex: Int!
    
    /// reference to the cell type used
    let celltype = CellType.fieldCell1
    
    /// a list of strings of all attributes that can be assigned (AttributeTypes and Enums)
    let deletionRules: [DeletionRule] = DeletionRule.set
    
    /// initializes object with relationship and entity indexes
    init(entityIndex: Int, relationshipIndex: Int) {
        self.entityIndex = entityIndex
        self.relationshipIndex = relationshipIndex
    }
    
    func selectionboard(_ sb: SelectionBoard, didChooseLocation location: HGTableLocation) {
        let index = celltype.index(forlocation: locations[0], inTable: sb.hgtable)
        let deletionrule = DeletionRule.create(int: index)
        appDelegate.store.project.entities[entityIndex].relationships[relationshipIndex].deletionRule = deletionrule
        appDelegate.store.post(forNotifType: .relationshipUpdated) // post notification so other classes are in the know
    }
}

// MARK: HGTableDisplayable
extension SBD_DeletionRules: HGTableDisplayable {
    
    func numberOfItems(fortable table: HGTable) -> Int {
        return deletionRules.count
    }
    
    func cellType(fortable table: HGTable) -> CellType {
        return celltype
    }
    
    func hgtable(_ table: HGTable, dataForIndex index: Int) -> HGCellData {
        let rule = deletionRules[index]
        let fieldData = HGFieldData(title: rule.string)
        return HGCellData.fieldCell1(field0: fieldData)
    }
}

extension SBD_DeletionRules: HGTableRowSelectable {
    
    func hgtable(_ table: HGTable, shouldSelectRow row: Int) -> Bool {
        return true
    }
    
}
