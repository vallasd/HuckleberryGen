//
//  SBD_RelationshipType.swift
//  HuckleberryGen
//
//  Created by David Vallas on 1/12/16.
//  Copyright © 2016 Phoenix Labs.
//
//  All Rights Reserved.

import Cocoa

/// context for a Selection Board of unique attributes
class SBD_RelationshipType: SelectionBoardDelegate {
    
    /// reference to the selection board
    weak var selectionBoard: SelectionBoard?
    
    /// index of Entity to be updated
    let entityIndex: Int
    
    /// index of Relationship to be updated
    let relationshipIndex: Int
    
    /// reference to the cell type used
    let celltype = CellType.imageCell
    
    /// a list of strings of all attributes that can be assigned (AttributeTypes and Enums)
    let relationshipTypes: [RelationshipType] = RelationshipType.set
    
    /// initializes object with relationship and entity indexes
    init(entityIndex: Int, relationshipIndex: Int) {
        self.entityIndex = entityIndex
        self.relationshipIndex = relationshipIndex
    }
    
    /// creates an array of HGImageData for an array indexes in attribute
    func cellImageDatas(forAttributeIndexes indexes: [Int]) -> [HGImageData] {
        var imagedatas: [HGImageData] = []
        for index in indexes {
            let type = relationshipTypes[index]
            let image = type.image
            let imagedata = HGImageData(title: "", image: image)
            imagedatas.append(imagedata)
        }
        return imagedatas
    }
    
    func selectionboard(_ sb: SelectionBoard, didChooseLocation location: HGTableLocation) {
        let index = celltype.index(forlocation: locations[0], inTable: sb.hgtable)
        let relationshiptype = RelationshipType.create(int: index)
        appDelegate.store.project.entities[entityIndex].relationships[relationshipIndex].relType = relationshiptype
        appDelegate.store.post(forNotifType: .relationshipUpdated) // post notification so other classes are in the know
    }
}

// MARK: HGTableDisplayable
extension SBD_RelationshipType: HGTableDisplayable {
    
    func numberOfItems(fortable table: HGTable) -> Int {
        return relationshipTypes.count
    }
    
    func cellType(fortable table: HGTable) -> CellType {
        return celltype
    }
    
    func hgtable(_ table: HGTable, dataForIndex index: Int) -> HGCellData {
        let type = relationshipTypes[index]
        let image = type.image
        let imagedata = HGImageData(title: "", image: image)
        let celldata = HGCellData.imageCell(image: imagedata)
        return celldata
    }
}

extension SBD_RelationshipType: HGTableItemSelectable {
    
    func hgtable(_ table: HGTable, shouldSelect row: Int, tag: Int, type: CellItemType) -> Bool {
        return true
    }
    
    func hgtable(_ table: HGTable, didSelectRow row: Int, tag: Int, type: CellItemType) {
        // Do Nothing
    }
}
