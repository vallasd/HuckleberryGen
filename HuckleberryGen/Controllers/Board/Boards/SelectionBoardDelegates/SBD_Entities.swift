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
    
    /// a list of strings of all attributes that can be assigned (AttributeTypes and Enums)
    let entities: [Entity] = appDelegate.store.project.entities
    
    init(indexIndex i: Int) {
        index = i
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
    
    func selectionboard(_ sb: SelectionBoard, didChooseLocation loc: HGTableLocation) {
        let entity = entities[loc.index]
        updateIndex(forEntity: entity)
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
        return CellType.imageCell
    }
    
    func hgtable(_ table: HGTable, dataForIndex index: Int) -> HGCellData {
        let name = entities[index].typeRep
        let image = Entity.image(withName: name)
        let imagedata = HGImageData(title: name, image: image)
        let celldata = HGCellData.imageCell(image: imagedata)
        return celldata
    }
}

extension SBD_Entities: HGTableLocationSelectable {
    
    func hgtable(_ table: HGTable, shouldSelectLocation loc: HGTableLocation) -> Bool {
        return true
    }
    
    func hgtable(_ table: HGTable, didSelectLocation loc: HGTableLocation) {
        // do nothing
    }
}



