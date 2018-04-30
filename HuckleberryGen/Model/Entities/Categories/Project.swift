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
    fileprivate(set) var enumAttributes: Set<EnumAttribute> // entity enum join
    fileprivate(set) var entityAttributes: Set<EntityAttribute> // enity entity join
    fileprivate(set) var usedNames: Set<UsedName>
    
    init(name: String, enums:Set<Enum>, entities: Set<Entity>, enumAttributes: Set<EnumAttribute>, entityAttributes: Set<EntityAttribute>, usedNames: Set<UsedName>) {
        self.name = name
        self.enums = enums
        self.entities = entities
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

extension Project: HGEncodable {
    
    static var new: Project {
        return Project(name: Project.newName, enums: [], entities: [], enumAttributes: [], entityAttributes: [], usedNames: UsedName.initialNames)
    }
    
    static var encodeError: Project {
        return Project(name: Project.newName, enums: [], entities: [], enumAttributes: [], entityAttributes: [], usedNames: [])
    }
    
    var encode: Any {
        var dict = HGDICT()
        dict["name"] = name
        dict["enums"] = enums.encode
        dict["entities"] = entities.encode
        dict["enumAttributs"] = enumAttributes.encode
        dict["entityAttributes"] = entityAttributes.encode
        dict["usedNames"] = usedNames.encode
        return dict as AnyObject
    }
    
    static func decode(object: Any) -> Project {
        let dict = HG.decode(hgdict: object, decoderName: "Project")
        let name = dict["name"].string
        let enums = dict["enums"].enumSet
        let entities = dict["entities"].entitySet
        let enumAttributes = dict["enumAttributes"].enumAttributeSet
        let entityAttributes = dict["entityAttributes"].entityAttributeSet
        let usedNames = dict["usedNames"].usedNameSet
        let project = Project(name: Project.newName,
                              enums: enums,
                              entities: entities,
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
            let _ = usedNames.delete(name: n)
            return true
        }
        return false
    }
    
    func updateEntity(keys: [EntityKey], withValues vs: [Any], name n: String) -> Entity? {
        
        if usedNameIn(values: vs) {
            return nil
        }
        
        return entities.update(keys: keys, withValues: vs, name: n)
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
        
        if usedNameIn(values: keyDict.map { $0.1 }) {
            return nil
        }
        
        return enums.update(keyDict: keyDict, name: n)
    }
    
    // Enum Case
    
    func createIteratedEnumCase(enumName: String) -> EnumCase? {
        if var enuM = enums.get(name: enumName) {
            return enuM.createIteratedEnumCase()
        }
        
        return nil
    }
    
    func deleteEnumCase(name n: String, enumName: String) -> Bool {
        if var enuM = enums.get(name: enumName) {
            return enuM.deleteEnumCase(name: n)
        }
        
        return false
    }
    
    func updateEnum(keysDict: EnumCaseKeyDict, name n: String, enumName: String) -> EnumCase? {
        if var enuM = enums.get(name: enumName) {
            return enuM.updateEnumCase(keyDict: keysDict, name: n)
        }
        
        return nil
    }
    
    
    // EntityAttributes
    
    func createIteratedEntityAttribute(entityName en: String, inverseEntityName ien: String) -> [EntityAttribute] {
        return entityAttributes.createIterated(entityName: en, inverseEntityName: ien)
    }
    
    func deleteEntityAttribute(name n: String, entityName en: String) -> Bool {
        return entityAttributes.delete(name: n, entityName: en)
    }
    
    func getEntityAttribute(name n: String, entityName en: String) -> EntityAttribute? {
        return entityAttributes.get(name: n, entityName: en)
    }
    
    func updateEntityAttribute(keys: [EntityAttributeKey], withValues vs: [Any], name n: String, entityName en: String) -> [EntityAttribute] {
        
        if usedNameIn(values: vs) {
            return []
        }
        
        return entityAttributes.update(keys: keys, withValues: vs, name: n, entityName: en)
    }
    
    fileprivate func usedNameIn(values: [Any]) -> Bool {
        let used = usedNames.map { $0.name }
        for value in values {
            if let string = value as? String {
                if used.contains(string) {
                    HGReport.shared.usedName(name: name, type: Project.self)
                    return true
                }
            }
        }
        return false
    }
}
