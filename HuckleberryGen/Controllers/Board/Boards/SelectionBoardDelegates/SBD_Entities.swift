//
//  SBD_Entities.swift
//  HuckleberryGen
//
//  Created by David Vallas on 1/11/16.
//  Copyright © 2016 Phoenix Labs.
//
//  All Rights Reserved.

import Foundation

/// context for a Selection Board of unique attributes
class SBD_Entities: SelectionBoardDelegate {
    
    /// reference to the selection board
    weak var selectionBoard: SelectionBoard?
    
    /// index of Entity to be updated
    let index: Int
    
    /// index of Relationship to be updated
    let index2: Int!
    
    // selection Object, hack to check selections, this should be clearer 0 handles a Relationship, 1 will hande an Index
    let type: Int

    /// reference to the cell type used
    let celltype = CellType.imageCell
    
    /// a list of strings of all attributes that can be assigned (AttributeTypes and Enums)
    let entities: [Entity] = appDelegate.store.project.entities
    
    /// initializes object with relationship and entity indexes
    init(entityIndex i1: Int, relationshipIndex i2: Int) {
        index = i1
        index2 = i2
        type = 0
    }
    
    init(indexIndex i1: Int) {
        index = i1
        index2 = -99
        type = 1
    }
    
    /// creates an array of HGImageData for an array indexes in attribute
    func cellImageDatas(forEntityIndexes indexes: [Int]) -> [HGImageData] {
        var imagedatas: [HGImageData] = []
        for index in indexes {
            let name = entities[index].typeRep
            let image = Entity.image(withName: name)
            let imagedata = HGImageData(title: name, image: image)
            imagedatas.append(imagedata)
        }
        return imagedatas
    }
    
    func selectionboard(_ sb: SelectionBoard, didChooseLocation location: HGTableLocation) {
        let index = celltype.index(forlocation: locations[0], inTable: sb.hgtable)
        let entity = entities[index]
        switch type {
        case 0: updateRelationship(forEntity: entity)
        case 1: updateIndex(forEntity: entity)
        default: HGReportHandler.shared.report("SBD_Entities: Did Not Update", type: .error)
        }
    }
    
    func updateRelationship(forEntity e: Entity) {
        appDelegate.store.project.entities[index].relationships[index2].entity = e
        appDelegate.store.post(forNotifType: .relationshipUpdated) // post notification so other classes are in the know
    }
    
    func updateIndex(forEntity e: Entity) {
        var i = appDelegate.store.getIndex(index: index)
        i.entity = e
        appDelegate.store.replaceIndex(atIndex: index, withIndex: i)
        appDelegate.store.post(forNotifType: .indexUpdated) // post notification so other classes are in the know
    }
}

// MARK: HGTableDisplayable
extension SBD_Entities: HGTableDisplayable {
    
    func numberOfItems(fortable table: HGTable) -> Int {
        return entities.count
    }
    
    func cellType(fortable table: HGTable) -> CellType {
        return celltype
    }
    
    func hgtable(_ table: HGTable, dataForIndex index: Int) -> HGCellData {
        let name = entities[index].typeRep
        let image = Entity.image(withName: name)
        let imagedata = HGImageData(title: name, image: image)
        let celldata = HGCellData.imageCell(image: imagedata)
        return celldata
    }
}

extension SBD_Entities: HGTableItemSelectable {
    
    func hgtable(_ table: HGTable, shouldSelect row: Int, tag: Int, type: CellItemType) -> Bool {
        return true
    }
    
    func hgtable(_ table: HGTable, didSelectRow row: Int, tag: Int, type: CellItemType) {
        // Do Nothing
    }
}



