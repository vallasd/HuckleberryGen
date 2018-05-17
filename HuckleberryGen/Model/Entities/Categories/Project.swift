//
//  Project.swift
//  HuckleberryGen
//
//  Created by David Vallas on 11/19/15.
//  Copyright © 2015 Phoenix Labs.
//
//  All Rights Reserved.

import Foundation

// MARK: struct Definition

final class Project {
    
    var name: String
    fileprivate(set) var enums: Set<Enum>
    fileprivate(set) var entities: Set<Entity>
    fileprivate(set) var joins: Set<Join>
    fileprivate(set) var enumAttributes: Set<EnumAttribute> // entity enum join
    fileprivate(set) var entityAttributes: Set<EntityAttribute> // enity entity join
    fileprivate(set) var usedNames: Set<UsedName>
    
    init(name: String, enums:Set<Enum>, entities: Set<Entity>, joins: Set<Join>, enumAttributes: Set<EnumAttribute>, entityAttributes: Set<EntityAttribute>, usedNames: Set<UsedName>) {
        self.name = name
        self.enums = enums
        self.entities = entities
        self.joins = joins
        self.enumAttributes = enumAttributes
        self.entityAttributes = entityAttributes
        self.usedNames = usedNames
    }
    
    static var newName = "New Project"
    
    var isNew: Bool { return name == Project.newName ? true : false }
    
    func saveKey(withUniqID uniqId: String) -> String {
        return uniqId + "__*_|||_*__" + name
    }
    
    static func saveKey(withUniqID uniqId: String, name: String) -> String {
        return uniqId + "__*_|||_*__" + name
    }
}

// MARK: Encoding

extension Project: HGCodable {
    
    static var new: Project {
        return Project(name: Project.newName, enums: [], entities: [], joins: [], enumAttributes: [], entityAttributes: [], usedNames: UsedName.initialNames)
    }
    
    static var encodeError: Project {
        return Project(name: Project.newName, enums: [], entities: [], joins: [], enumAttributes: [], entityAttributes: [], usedNames: [])
    }
    
    var encode: Any {
        var dict = HGDICT()
        dict["name"] = name
        dict["enums"] = enums.encode
        dict["entities"] = entities.encode
        dict["enumAttributs"] = enumAttributes.encode
        dict["entityAttributes"] = entityAttributes.encode
        dict["joins"] = joins.encode
        dict["usedNames"] = usedNames.encode
        return dict as AnyObject
    }
    
    static func decode(object: Any) -> Project {
        let dict = HG.decode(hgdict: object, decoder: Project.self)
        let name = dict["name"].string
        let enums = dict["enums"].enumSet
        let entities = dict["entities"].entitySet
        let joins = dict["joins"].joinSet
        let enumAttributes = dict["enumAttributes"].enumAttributeSet
        let entityAttributes = dict["entityAttributes"].entityAttributeSet
        let usedNames = dict["usedNames"].usedNameSet
        let project = Project(name: Project.newName,
                              enums: enums,
                              entities: entities,
                              joins: joins,
                              enumAttributes: enumAttributes,
                              entityAttributes: entityAttributes,
                              usedNames: usedNames)
        return project
    }
}

extension Project {
    
    // Entities
    
    func createIteratedEntity() -> Entity? {
        if let entity = entities.createIterated() {
            let _ = usedNames.create(name: entity.name)
            return entity
        }
        return nil
    }
    
    func deleteEntity(name n: String) -> Bool {
        if entities.delete(name: n) {
        
            // delete the Entity from usedNames
            let _ = usedNames.delete(name: n)
            
            // delete joins with EntityName
            let js = joins.filter { $0.entityName1 == n || $0.entityName2 == n }
            for join in js {
                let _ = project.deleteJoin(name: join.name)
            }
            
            return true
        }
        return false
    }
    
    func updateEntity(keyDict: EntityKeyDict, name n: String) -> Entity? {
        
        // check if key values contain a usedName
        if usedNameIn(values: keyDict.map { $0.1 }) {
            return nil
        }
        
        let entity = entities.update(keyDict: keyDict, name: n)
        
        // replace names in usedName if we changed a name
        if keyDict.keys.contains(.name), let e = entity {
            let _ = usedNames.delete(name: n)
            let _ = usedNames.create(name: e.name)
        }
        
        return entity
    }
    
    // Joins
    
    func createIteratedJoin() -> Join? {
        
        if entities.count == 0 {
            HGReport.shared.noEntities(decoder: Join.self)
            return nil
        }
        
        let e = entities.sorted { $0.name < $1.name }
        
        let en1 = e.first!.name
        let en2 = e.last!.name
        
        if let join = joins.createIterated(entityName1: en1, entityName2: en2) {
            let _ = usedNames.create(name: join.name)
            return join
        }
        
        return nil
    }
    
    func deleteJoin(name n: String) -> Bool {
        if joins.delete(name: n) {
            let _ = usedNames.delete(name: n)
            return true
        }
        return false
    }
    
    func updateJoin(keyDict: JoinKeyDict, name n: String) -> Join? {
        
        // check if key values contain a usedName
        if usedNameIn(values: keyDict.map { $0.1 }) {
            return nil
        }
        
        let join = joins.update(keyDict: keyDict, name: n)
        
        // replace names in usedName if we changed a name
        if keyDict.keys.contains(.name), let j = join {
            let _ = usedNames.delete(name: n)
            let _ = usedNames.create(name: j.name)
        }
        
        return join
    }
    
    // EntityAttributes
    
    func createEntityAttribute(entityAttribute: EntityAttribute) -> EntityAttribute? {
        
        let values = [entityAttribute.name]
        if usedNameIn(values: values) {
            return nil
        }
        
        return entityAttributes.create(entityAttribute: entityAttribute)
    }
    
    func createIteratedEntityAttribute(entityName1 en1: String, entityName2 en2: String) -> EntityAttribute? {
        return entityAttributes.createIterated(entityName1: en1, entityName1: en2)
    }
    
    func deleteEntityAttribute(entityName en: String) -> Bool {
        return entityAttributes.delete(entityName: en)
    }
    
    func deleteEntityAttribute(name n: String, entityName1 en1: String) -> Bool {
        return entityAttributes.delete(name: n, entityName1: en1)
    }
    
    func updateEntityAttribute(keyDict: EntityAttributeKeyDict, name n: String, entityName en: String) -> EntityAttribute? {
        
        // check if key values contain a usedName
        if usedNameIn(values: keyDict.map { $0.1 }) {
            return nil
        }
        
        return entityAttributes.update(keyDict: keyDict, name: n, entityName1: en)
    }
    
    // Attribute
    
    func createAttribute(attribute a: Attribute, entityName: String) -> Attribute? {
        
        
        let values = [a.name]
        if usedNameIn(values: values) {
            return nil
        }
        
        if var entity = entities.get(name: entityName) {
            let attribute = entity.createAttribute(attribute: a)
            let keyDict: EntityKeyDict = [.attributes: entity.attributes]
            if entities.update(keyDict: keyDict, name: entityName) != nil {
                return attribute
            }
        }
        
        return nil
    }
    
    func createIteratedAttribute(entityName: String) -> Attribute? {
        
        if var entity = entities.get(name: entityName) {
            let attribute = entity.createIteratedAttribute()
            let keyDict: EntityKeyDict = [.attributes: entity.attributes]
            if entities.update(keyDict: keyDict, name: entityName) != nil {
                return attribute
            }
        }
        
        return nil
    }
    
    func deleteAttribute(name n: String, entityName: String) -> Bool {
        
        if var entity = entities.get(name: entityName) {
            let deleted = entity.deleteAttribute(name: n)
            let keyDict: EntityKeyDict = [.attributes: entity.attributes]
            if entities.update(keyDict: keyDict, name: entityName) != nil {
                return deleted
            }
        }
        
        return false
    }
    
    func updateAttribute(keyDict: AttributeKeyDict, name n: String, entityName: String) -> Attribute? {
        
        //
        
        if var entity = entities.get(name: entityName) {
            let updatedAttribute = entity.updateAttribute(keyDict: keyDict, name: n)
            let keyDict: EntityKeyDict = [.attributes: entity.attributes]
            if entities.update(keyDict: keyDict, name: entityName) != nil {
                return updatedAttribute
            }
        }
        
        return nil
    }
    
    // EnumAttributes
    
    func createEnumAttribute(enumAttribute: EnumAttribute) -> EnumAttribute? {
        
        let values = [enumAttribute.name]
        if usedNameIn(values: values) {
            return nil
        }
        
        return enumAttributes.create(enumAttribute: enumAttribute)
    }
    
    func createIteratedEnumAttribute(entityName1 en1: String, entityName2 en2: String) -> EnumAttribute? {
        return enumAttributes.createIterated(entityName: en1, enumName: en2)
    }
    
    func deleteEnumAttribute(entityName en: String) -> Bool {
        return enumAttributes.delete(entityName: en)
    }
    
    func deleteEnumAttribute(enumName en: String) -> Bool {
        return enumAttributes.delete(enumName: en)
    }
    
    func deleteEnumAttribute(name n: String, entityName en: String) -> Bool {
        return enumAttributes.delete(name: n, entityName: en)
    }
    
    func updateEnumAttribute(keyDict: EnumAttributeKeyDict, name n: String, entityName en: String) -> EnumAttribute? {
        
        if usedNameIn(values: keyDict.map { $0.1 }) {
            return nil
        }
        
        return enumAttributes.update(keyDict: keyDict, name: n, entityName: en)
    }
    
    // Enums
    
    func createIteratedEnum() -> Enum? {
        if let enuM = enums.createIterated() {
            let _ = usedNames.create(name: enuM.name)
            return enuM
        }
        return nil
    }
    
    func deleteEnum(name n: String) -> Bool {
        if enums.delete(name: n) {
            let _ = usedNames.delete(name: n)
            return true
        }
        return false
    }
    
    func updateEnum(keyDict: EnumKeyDict, name n: String) -> Enum? {
        
        // check if key values contain a usedName
        if usedNameIn(values: keyDict.map { $0.1 }) {
            return nil
        }
        
        let enuM = enums.update(keyDict: keyDict, name: n)
        
        // replace names in usedName if we changed a name
        if keyDict.keys.contains(.name), let e = enuM {
            let _ = usedNames.delete(name: n)
            let _ = usedNames.create(name: e.name)
        }
        
        return enuM
    }
    
    // Enum Case
    
    func createIteratedEnumCase(enumName: String) -> EnumCase? {
        
        if var enuM = enums.get(name: enumName) {
            let enuMCase = enuM.createIteratedEnumCase()
            let keyDict: EnumKeyDict = [.cases : enuM.cases]
            if enums.update(keyDict: keyDict, name: enumName) != nil {
                return enuMCase
            }
        }
        
        return nil
    }
    
    func deleteEnumCase(name n: String, enumName: String) -> Bool {
        
        if var enuM = enums.get(name: enumName) {
            let deleted = enuM.deleteEnumCase(name: n)
            let keyDict: EnumKeyDict = [.cases : enuM.cases]
            if enums.update(keyDict: keyDict, name: enumName) != nil {
                return deleted
            }
        }
        
        return false
    }
    
    func updateEnumCase(keysDict: EnumCaseKeyDict, name n: String, enumName: String) -> EnumCase? {
        
        if var enuM = enums.get(name: enumName) {
            let updatedEnumCase = enuM.updateEnumCase(keyDict: keysDict, name: n)
            let keyDict: EnumKeyDict = [.cases : enuM.cases]
            if enums.update(keyDict: keyDict, name: enumName) != nil {
                return updatedEnumCase
            }
        }
        
        return nil
    }
    
    fileprivate func usedNameIn(values: [Any]) -> Bool {
        let used = usedNames.map { $0.name }
        for value in values {
            if let string = value as? String {
                if used.contains(string) {
                    HGReport.shared.usedName(decoder: Project.self, name: name)
                    return true
                }
            }
        }
        return false
    }
}
