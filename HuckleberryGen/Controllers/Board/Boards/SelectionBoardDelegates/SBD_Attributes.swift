//
//  SBD_Attributes.swift
//  HuckleberryGen
//
//  Created by David Vallas on 1/11/16.
//  Copyright © 2016 Phoenix Labs.
//
//  All Rights Reserved.

import Foundation

/// context for a Selection Board of unique attributes
class SBD_Attributes: SelectionBoardDelegate {
    
    /// name of entity to be edited
    let entityName: String
    
    /// name of attribute name
    let name: String

    /// reference to the selection board
    weak var selectionBoard: SelectionBoard?
    
    /// a list of strings of all attributes types that can be assigned
    let typeNames: [String] = Primitive.names + project.enums.map { $0.name } + project.entities.map { $0.name }
    
    let firstEnumIndex = Primitive.names.count
    let firstEntityIndex = Primitive.names.count + project.enums.count
    
    init(entityName: String, name: String) {
        self.entityName = entityName
        self.name = name
    }
    
    /// SelectionBoardDelegate function
    func selectionboard(_ sb: SelectionBoard, didChooseLocation loc: HGTableLocation) {
        
        // get the name of the type and entity
        let typeName = typeNames[loc.index]
        let entity = project.entities.get(name: entityName)!
        
        // create attribute or update attribute
        if loc.index < firstEnumIndex {
            
            // object was an attribute, we just need to update its typeName
            let isAttribute = entity.attributes.filter { $0.name == name }.count > 0
            if isAttribute {
                let keyDict: AttributeKeyDict = [.typeName: typeName]
                let _ = project.updateAttribute(keyDict: keyDict, name: name, entityName: entityName)
                return
            }
            
            // delete enumAttribute or entityAttribute if they exist, we dont want to report error because one will not exist
            HGReport.shared.isOn = false
            let _ = project.deleteEnumAttribute(name: name, entityName: entityName)
            let _ = project.deleteEntityAttribute(name: name, entityName1: entityName)
            HGReport.shared.isOn = true
            
            // create
            let a = Attribute(name: name, typeName: typeName, isHash: false)
            let _ = project.createAttribute(attribute: a, entityName: entityName)
            return
        }
        
        // create enumAttribute or update enumAttribute
        if loc.index < firstEntityIndex {
            
            // object was an enumAttribute, we just need to update its enumName
            let isEnumAttribute = project.enumAttributes.filter { $0.name == name }.count > 0
            if isEnumAttribute {
                let keyDict: EnumAttributeKey = [.enumName: typeName]
                let _ = project.updateEnumAttribute(keyDict: keyDict, name: name, entityName: entityName)
                return
            }
            
            // delete attribute or entityAttribute if they exist, we dont want to report error because one will not exist
            HGReport.shared.isOn = false
            let _ = project.deleteAttribute(name: name, entityName: entityName)
            let _ = project.deleteEntityAttribute(name: name, entityName1: entityName)
            HGReport.shared.isOn = true
            
            // create
            let ea = EnumAttribute(name: name, entityName: entityName, enumName: typeName, isHash: false)
            let _ = project.createIteratedEnumAttribute(entityName1: <#T##String#>, entityName2: <#T##String#>)
            return
        }
        
        
        
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
        return typeNames.count
    }
    
    func cellType(fortable table: HGTable) -> CellType {
        return CellType.imageCell
    }
    
    func hgtable(_ table: HGTable, dataForIndex index: Int) -> HGCellData {
        let name = typeNames[index]
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



