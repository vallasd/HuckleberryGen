//
//  SBD_Entities.swift
//  HuckleberryGen
//
//  Created by David Vallas on 1/11/16.
//  Copyright © 2016 Phoenix Labs. All rights reserved.
//

import Foundation

/// context for a Selection Board of unique attributes
class SBD_Entities: SelectionBoardDelegate {
    
    /// reference to the selection board
    weak var selectionBoard: SelectionBoard?
    
    /// index of Entity to be updated
    let entityIndex: Int!
    
    /// index of Relationship to be updated
    let relationshipIndex: Int!
    
    /// reference to the cell type used
    let celltype = HGCellType.Image5Cell
    
    /// a list of strings of all attributes that can be assigned (AttributeTypes and Enums)
    let entities: [String] = appDelegate.store.project.entities.map { $0.name }
    
    /// initializes object with relationship and entity indexes
    init(entityIndex: Int, relationshipIndex: Int) {
        self.entityIndex = entityIndex
        self.relationshipIndex = relationshipIndex
    }
    
    /// creates an array of HGImageData for an array indexes in attribute
    func cellImageDatas(forAttributeIndexes indexes: [Int]) -> [HGImageData] {
        var imagedatas: [HGImageData] = []
        for index in indexes {
            let name = entities[index]
            let image = Enum.image(withName: name)
            let imagedata = HGImageData(title: name, image: image)
            imagedatas.append(imagedata)
        }
        return imagedatas
    }
    
    func selectionboard(sb: SelectionBoard, didChooseLocations locations: [HGCellLocation]) {
        let index = celltype.index(forlocation: locations[0])
        let entityString = entities[index]
        appDelegate.store.project.entities[entityIndex].relationships[relationshipIndex].entity = entityString
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
    
    func hgtable(table: HGTable, cellForRow row: Int) -> HGCellType {
        return celltype
    }
    
    func hgtable(table: HGTable, dataForRow row: Int) -> HGCellData {
        let imageIndexes = celltype.imageIndexes(forRow: row, imageCount: entities.count)
        let imagedatas = cellImageDatas(forAttributeIndexes: imageIndexes)
        return HGCellData.onlyImages(imagedatas)
    }
}

// MARK: HGTableItemEditable
extension SBD_Entities: HGTableItemEditable {
    
    func hgtable(table: HGTable, shouldEditRow row: Int, tag: Int, type: HGCellItemType) -> Bool {
        // TODO: EDIT
        return true
    }
    
    func hgtable(table: HGTable, didEditRow row: Int, tag: Int, withData data: HGCellItemData) {
        // DO NOTHING
    }
}




