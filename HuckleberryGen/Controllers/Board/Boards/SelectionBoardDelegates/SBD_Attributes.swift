//
//  SBD_Attributes.swift
//  HuckleberryGen
//
//  Created by David Vallas on 1/11/16.
//  Copyright © 2016 Phoenix Labs.
//
//  All Rights Reserved.

import Cocoa

protocol SBD_AttributeDelegate: AnyObject {
    func sbd_attribute(_: SBD_Attributes, didUpdateType: HGType)
}

/// context for a Selection Board of unique attributes
class SBD_Attributes: SelectionBoardDelegate {
    
    /// delegate for SBD_Attributes
    weak var delegate: SBD_AttributeDelegate?
    
    /// name of holder to be edited
    let holderName: String
    
    /// name of attribute name
    let name: String

    /// reference to the selection board
    weak var selectionBoard: SelectionBoard?
    
    /// a list of strings of all attributes types that can be assigned
    let typeNames: [String]
    let firstEnumIndex: Int
    let firstEntityIndex: Int
    let firstJoinIndex: Int
    
    func image(forIndex index: Int) -> NSImage {
        let name = typeNames[index]
        if index < firstEnumIndex { return NSImage.image(named: "typeIcon", title: name) }
        if index < firstEntityIndex  { return NSImage.image(named: "enumIcon", title: name) }
        if index < firstJoinIndex { return NSImage.image(named: "entityIcon", title: name) }
        return NSImage.image(named: "relationshipIcon", title: name)
    }
    
    init(holderName: String, name: String) {
        self.holderName = holderName
        self.name = name
        let primitives = Primitive.names.sorted { $0 < $1 }
        let enums = project.enums.map { $0.name }.sorted { $0 < $1 }
        let entities = project.entities.map { $0.name }.sorted { $0 < $1 }
        let joins = project.joins.map { $0.name }.sorted { $0 < $1 }
        typeNames = primitives + enums + entities + joins
        firstEnumIndex = primitives.count
        firstEntityIndex = primitives.count + enums.count
        firstJoinIndex = primitives.count + enums.count + entities.count
    }
    
    /// SelectionBoardDelegate function
    func selectionboard(_ sb: SelectionBoard, didChooseLocation loc: HGTableLocation) {
        
        // get the name of the type and entity
        let typeName = typeNames[loc.index]
        
        // create primitiveAttribute or update primitiveAttribute
        if loc.index < firstEnumIndex {
            
            // object was an primitiveAttribute, we just need to update its typeName
            let isPrimitiveAttribute = project.primitiveAttributes.filter { $0.name == name }.count > 0
            if isPrimitiveAttribute {
                let keyDict: PrimitiveAttributeKeyDict = [.primitiveName: typeName]
                let _ = project.updatePrimitiveAttribute(keyDict: keyDict, name: name, holderName: holderName)
                delegate?.sbd_attribute(self, didUpdateType: .primitive)
                return
            }
            
            // delete enumAttribute or entityAttribute if they exist, we dont want to report error because one will not exist
            HGReport.shared.isOn = false
            let _ = project.deleteEnumAttribute(name: name, holderName: holderName)
            let _ = project.deleteEntityAttribute(name: name, holderName: holderName)
            let _ = project.deleteJoinAttribute(name: name, holderName: holderName)
            HGReport.shared.isOn = true
            
            // create attribute
            let pa = PrimitiveAttribute(name: name, holderName: holderName, primitiveName: typeName, isHash: false, isArray: false)
            let _ = project.createPrimitiveAttribute(primitiveAttribute: pa)
            delegate?.sbd_attribute(self, didUpdateType: .primitive)
            return
        }
        
        // create enumAttribute or update enumAttribute
        if loc.index < firstEntityIndex {
            
            // object was an enumAttribute, we just need to update its enumName
            let isEnumAttribute = project.enumAttributes.filter { $0.name == name }.count > 0
            if isEnumAttribute {
                let keyDict: EnumAttributeKeyDict = [.enumName: typeName]
                let _ = project.updateEnumAttribute(keyDict: keyDict, name: name, holderName: holderName)
                delegate?.sbd_attribute(self, didUpdateType: .enuM)
                return
            }
            
            // delete attribute or entityAttribute if they exist, we dont want to report error because one will not exist
            HGReport.shared.isOn = false
            let _ = project.deletePrimitiveAttribute(name: name, holderName: holderName)
            let _ = project.deleteEntityAttribute(name: name, holderName: holderName)
            let _ = project.deleteJoinAttribute(name: name, holderName: holderName)
            HGReport.shared.isOn = true
            
            // create enumAttribute
            let ea = EnumAttribute(name: name, holderName: holderName, enumName: typeName, isHash: false, isArray: false)
            let _ = project.createEnumAttribute(enumAttribute: ea)
            delegate?.sbd_attribute(self, didUpdateType: .enuM)
            return
        }
        
        // create entityAttribute or update entityAttribute
        if loc.index < firstJoinIndex {
            
            // object was an entityAttribute, we just need to update its entityName
            let isEntityAttribute = project.entityAttributes.filter { $0.name == name }.count > 0
            if isEntityAttribute {
                let keyDict: EntityAttributeKeyDict = [.entityName: typeName]
                let _ = project.updateEntityAttribute(keyDict: keyDict, name: name, holderName: holderName)
                delegate?.sbd_attribute(self, didUpdateType: .entity)
                return
            }
            
            // delete attribute or entityAttribute if they exist, we dont want to report error because one will not exist
            HGReport.shared.isOn = false
            let _ = project.deletePrimitiveAttribute(name: name, holderName: holderName)
            let _ = project.deleteEnumAttribute(name: name, holderName: holderName)
            let _ = project.deleteJoinAttribute(name: name, holderName: holderName)
            HGReport.shared.isOn = true
            
            // create entityAttribute
            let ea = EntityAttribute(name: name, holderName: holderName, entityName: typeName, isArray: false, deletionRule: .nullify)
            let _ = project.createEntityAttribute(entityAttribute: ea)
            delegate?.sbd_attribute(self, didUpdateType: .entity)
            return
        }
        
        // create joinAttribute or update joinAttribute
        // object was an joinAttribute, we just need to update its joinName
        let isJoinAttribute = project.joinAttributes.filter { $0.name == name }.count > 0
        if isJoinAttribute {
            let keyDict: JoinAttributeKeyDict = [.joinName: typeName]
            let _ = project.updateJoinAttribute(keyDict: keyDict, name: name, holderName: holderName)
            delegate?.sbd_attribute(self, didUpdateType: .entity)
            return
        }
        
        // delete attribute or entityAttribute if they exist, we dont want to report error because one will not exist
        HGReport.shared.isOn = false
        let _ = project.deletePrimitiveAttribute(name: name, holderName: holderName)
        let _ = project.deleteEnumAttribute(name: name, holderName: holderName)
        let _ = project.deleteEntityAttribute(name: name, holderName: holderName)
        HGReport.shared.isOn = true
        
        // create enumAttribute
        let ja = JoinAttribute(name: name, holderName: holderName, joinName: typeName, isArray: false, deletionRule: .nullify)
        let _ = project.createJoinAttribute(joinAttribute: ja)
        delegate?.sbd_attribute(self, didUpdateType: .join)
        return
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
        let i = image(forIndex: index)
        let imagedata = HGImageData(title: name, image: i)
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



