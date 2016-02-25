//
//  SBD_Entities.swift
//  HuckleberryGen
//
//  Created by David Vallas on 1/11/16.
//  Copyright © 2016 Phoenix Labs.
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
    let celltype = CellType.Image5Cell
    
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
    
    func selectionboard(sb: SelectionBoard, didChooseLocations locations: [HGCellLocation]) {
        let index = celltype.index(forlocation: locations[0])
        let entity = entities[index]
        switch type {
        case 0: updateRelationship(forEntity: entity)
        case 1: updateIndex(forEntity: entity)
        default: HGReportHandler.shared.report("SBD_Entities: Did Not Update", type: .Error)
        }
    }
    
    func updateRelationship(forEntity e: Entity) {
        appDelegate.store.project.entities[index].relationships[index2].entity = e
        appDelegate.store.post(forNotifType: .RelationshipUpdated) // post notification so other classes are in the know
    }
    
    func updateIndex(forEntity e: Entity) {
        var i = appDelegate.store.getIndex(index: index)
        i.entity = e
        appDelegate.store.replaceIndex(atIndex: index, withIndex: i)
        appDelegate.store.post(forNotifType: .IndexUpdated) // post notification so other classes are in the know
    }
}

// MARK: HGTableDisplayable
extension SBD_Entities: HGTableDisplayable {
    
    func numberOfRows(fortable table: HGTable) -> Int {
        let numImages = entities.count
        let numRows = celltype.rows(forImagesWithCount: numImages)
        return numRows
    }
    
    func hgtable(table: HGTable, heightForRow row: Int) -> CGFloat {
        return celltype.rowHeightForTable(selectionBoard?.tableview)
    }
    
    func hgtable(table: HGTable, cellForRow row: Int) -> CellType {
        return celltype
    }
    
    func hgtable(table: HGTable, dataForRow row: Int) -> HGCellData {
        let imageIndexes = celltype.imageIndexes(forRow: row, imageCount: entities.count)
        let imagedatas = cellImageDatas(forEntityIndexes: imageIndexes)
        return HGCellData.onlyImages(imagedatas)
    }
}

extension SBD_Entities: HGTableItemSelectable {
    
    func hgtable(table: HGTable, shouldSelect row: Int, tag: Int, type: CellItemType) -> Bool {
        return true
    }
    
    func hgtable(table: HGTable, didSelectRow row: Int, tag: Int, type: CellItemType) {
        // Do Nothing
    }
}



