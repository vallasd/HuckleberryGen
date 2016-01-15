//
//  SBD_Attributes.swift
//  HuckleberryGen
//
//  Created by David Vallas on 1/11/16.
//  Copyright © 2016 Phoenix Labs. All rights reserved.
//

import Foundation


import Foundation

/// context for a Selection Board of unique attributes
class SBD_Attributes: SelectionBoardDelegate {
    
    /// index of entity to be edited
    let entityIndex: Int
    
    /// inndex of attribute to be changed
    let attributeIndex: Int
    
    /// reference to the cell type used 
    let celltype = HGCellType.Image5Cell

    /// reference to the selection board
    weak var selectionBoard: SelectionBoard?
    
    init(entityIndex: Int, attributeIndex: Int) {
        self.entityIndex = entityIndex
        self.attributeIndex = attributeIndex
    }
    
    /// SelectionBoardDelegate function
    func selectionboard(sb: SelectionBoard, didChooseLocations locations: [HGCellLocation]) {
        let index = celltype.index(forlocation: locations[0])
        let attributeString = attributes[index]
        appDelegate.store.project.entities[entityIndex].attributes[attributeIndex].type = attributeString
        appDelegate.store.post(forNotifType: .AttributeUpdated) // post notification so other classes are in the know
    }
    
    /// a list of strings of all attributes that can be assigned (AttributeTypes and Enums)
    let attributes: [String] = Primitive.strings + appDelegate.store.project.enums.map { $0.name }
    
    /// last index of Attribute Type in the attributes array
    let firstEnumIndex = Primitive.strings.count
    
    /// creates an array of HGImageData for an array indexes in attribute
    func cellImageDatas(forAttributeIndexes indexes: [Int]) -> [HGImageData] {
        var imagedatas: [HGImageData] = []
        for index in indexes {
            let name = attributes[index]
            if name == "" {
                
            }
            let image = index < firstEnumIndex ? Primitive.create(string: name).image : Enum.image(withName: name)
            let imagedata = HGImageData(title: name, image: image)
            imagedatas.append(imagedata)
        }
        return imagedatas
    }
}

// MARK: HGTableDisplayable
extension SBD_Attributes: HGTableDisplayable {
    
    func numberOfRows(fortable table: HGTable) -> Int {
        let numImages = attributes.count
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
        let imageIndexes = celltype.imageIndexes(forRow: row, imageCount: attributes.count)
        let imagedatas = cellImageDatas(forAttributeIndexes: imageIndexes)
        return HGCellData.onlyImages(imagedatas)
    }
}

// MARK: HGTableItemEditable
extension SBD_Attributes: HGTableItemEditable {
    
    func hgtable(table: HGTable, shouldEditRow row: Int, tag: Int, type: HGCellItemType) -> Bool {
        return true
    }
    
    func hgtable(table: HGTable, didEditRow row: Int, tag: Int, withData data: HGCellItemData) {
        // DO NOTHING
    }
}




