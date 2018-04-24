//
//  SBD_Attributes.swift
//  HuckleberryGen
//
//  Created by David Vallas on 1/11/16.
//  Copyright © 2016 Phoenix Labs.
//
//  All Rights Reserved.

import Foundation


import Foundation

/// context for a Selection Board of unique attributes
class SBD_Attributes: SelectionBoardDelegate {
    
    /// index of entity to be edited
    let entityIndex: Int
    
    /// index of attribute to be changed
    let attributeIndex: Int
    
    /// reference to the cell type used 
    let celltype = CellType.imageCell

    /// reference to the selection board
    weak var selectionBoard: SelectionBoard?
    
    init(entityIndex: Int, attributeIndex: Int) {
        self.entityIndex = entityIndex
        self.attributeIndex = attributeIndex
    }
    
    /// SelectionBoardDelegate function
    func selectionboard(_ sb: SelectionBoard, didChooseLocation location: HGTableLocation) {
        let index = celltype.index(forlocation: locations[0], inTable: sb.hgtable)
        let o = appDelegate.store.project.entities[entityIndex].attributes[attributeIndex]
        let newAttribute = attribute(fromIndex: index, oldAttribute: o)
        appDelegate.store.project.entities[entityIndex].attributes[attributeIndex] = newAttribute
        appDelegate.store.post(forNotifType: .attributeUpdated) // post notification so other classes are in the know
    }
    
    func attribute(fromIndex i: Int, oldAttribute o: Attribute) -> Attribute {
        
        // check if index held primitive
        let isPrimitive = i < firstEnumIndex ? true : false
        
        // return attribute from primitive
        if isPrimitive {
            let primitive = Primitive.create(int: i)
            return Attribute(primitive: primitive, oldAttribute: o)
        }
        
        // return attribute from enum
        let index = i - firstEnumIndex
        let enuM = appDelegate.store.getEnum(index: index)
        return Attribute(enuM: enuM, oldAttribute: o)
    }
    
    /// a list of strings of all attributes types that can be assigned
    let types: [String] = Primitive.array.map { $0.varRep } + appDelegate.store.project.enums.map { $0.typeRep }
    
    /// last index of Attribute Type in the attributes array
    let firstEnumIndex = Primitive.array.count
    
    /// creates an array of HGImageData for an array indexes in attribute
    func cellImageDatas(forAttributeIndexes indexes: [Int]) -> [HGImageData] {
        var imagedatas: [HGImageData] = []
        for index in indexes {
            let name = types[index]
            let image = index < firstEnumIndex ? Primitive.create(string: name).image : Enum.image(withName: name)
            let imagedata = HGImageData(title: name, image: image)
            imagedatas.append(imagedata)
        }
        return imagedatas
    }
}

// MARK: HGTableDisplayable
extension SBD_Attributes: HGTableDisplayable {
    
    func numberOfItems(fortable table: HGTable) -> Int {
        return types.count
    }
    
    func cellType(fortable table: HGTable) -> CellType {
        return celltype
    }
    
    func hgtable(_ table: HGTable, dataForIndex index: Int) -> HGCellData {
        let name = types[index]
        let image = index < firstEnumIndex ? Primitive.create(string: name).image : Enum.image(withName: name)
        let imagedata = HGImageData(title: name, image: image)
        let cellData = HGCellData.imageCell(image: imagedata)
        return cellData
    }
}

// MARK: HGTableItemSelectable
extension SBD_Attributes: HGTableItemSelectable {
    
    func hgtable(_ table: HGTable, shouldSelect row: Int, tag: Int, type: CellItemType) -> Bool {
        return true
    }
    
    func hgtable(_ table: HGTable, didSelectRow row: Int, tag: Int, type: CellItemType) {
        // Do Nothing
    }
}



