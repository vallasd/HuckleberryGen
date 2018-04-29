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
    
    /// name of entity to be edited
    let entityName: String
    
    /// name of attribute or relationship
    let name: String

    /// reference to the selection board
    weak var selectionBoard: SelectionBoard?
    
    /// a list of strings of all attributes types that can be assigned
    let types: [String] = Primitive.names + project.enums.map { $0.name } + project.entities.map { $0.name }
    
    let firstEnumIndex = Primitive.names.count
    
    let lastEnumIndex = Primitive.names.count + project.enums.count
    
    init(entityName: String, name: String) {
        self.entityName = entityName
        self.name = name
    }
    
    
    /// SelectionBoardDelegate function
    func selectionboard(_ sb: SelectionBoard, didChooseLocation loc: HGTableLocation) {
        let e = project.getEntity(name: entityName)
        let o = appDelegate.store.project.entities[entityIndex].attributes[attributeIndex]
        let newAttribute = attribute(fromIndex: loc.index, oldAttribute: o)
        appDelegate.store.project.entities[entityIndex].attributes[attributeIndex] = newAttribute
        appDelegate.store.post(forNotifType: .attributeUpdated) // post notification so other classes are in the know
    }
    
    func attribute(fromIndex i: Int, oldAttribute o: Attribute) -> Attribute {
        
        // check if index held primitive
        let isPrimitive = i < firstEnumIndex ? true : false
        
        // return attribute from primitive
        if isPrimitive {
            return o.update(name: nil, typeName: Primitive.names[i], type: .primitive, isHash: nil)
        }
        
        // return attribute from enum
        let index = i - firstEnumIndex
        let enuM = appDelegate.store.getEnum(index: index)
        return o.update(name: nil, typeName: enuM.name, type: .enuM, isHash: nil)
    }
    
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
        return CellType.imageCell
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
extension SBD_Attributes: HGTableLocationSelectable {
    
    func hgtable(_ table: HGTable, shouldSelectLocation loc: HGTableLocation) -> Bool {
        
        if loc.type == .image {
            return true
        }
        
        return false
    }
    
    func hgtable(_ table: HGTable, didSelectLocation loc: HGTableLocation) {
        // do nothing
    }
}



