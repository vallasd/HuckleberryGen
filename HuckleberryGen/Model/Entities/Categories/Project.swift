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
    fileprivate(set) var primitiveAttributes: Set<PrimitiveAttribute>
    fileprivate(set) var enumAttributes: Set<EnumAttribute>
    fileprivate(set) var entityAttributes: Set<EntityAttribute>
    fileprivate(set) var joinAttributes: Set<JoinAttribute>
    fileprivate(set) var usedNames: Set<UsedName>
    
    init(name: String, enums:Set<Enum>, entities: Set<Entity>, joins: Set<Join>, primitiveAttributes: Set<PrimitiveAttribute>, enumAttributes: Set<EnumAttribute>, entityAttributes: Set<EntityAttribute>, joinAttributes: Set<JoinAttribute>, usedNames: Set<UsedName>) {
        self.name = name
        self.enums = enums
        self.entities = entities
        self.joins = joins
        self.primitiveAttributes = primitiveAttributes
        self.enumAttributes = enumAttributes
        self.entityAttributes = entityAttributes
        self.joinAttributes = joinAttributes
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
        return Project(name: Project.newName,
                       enums: [],
                       entities: [],
                       joins: [],
                       primitiveAttributes: [],
                       enumAttributes: [],
                       entityAttributes: [],
                       joinAttributes: [],
                       usedNames: UsedName.initialNames)
    }
    
    static var encodeError: Project {
        return Project(name: Project.newName,
                       enums: [],
                       entities: [],
                       joins: [],
                       primitiveAttributes: [],
                       enumAttributes: [],
                       entityAttributes: [],
                       joinAttributes: [],
                       usedNames: [])
    }
    
    var encode: Any {
        var dict = HGDICT()
        dict["name"] = name
        dict["enums"] = enums.encode
        dict["entities"] = entities.encode
        dict["joins"] = joins.encode
        dict["primitiveAttributes"] = primitiveAttributes.encode
        dict["enumAttributs"] = enumAttributes.encode
        dict["entityAttributes"] = entityAttributes.encode
        dict["joinAttributes"] = joinAttributes.encode
        dict["usedNames"] = usedNames.encode
        return dict
    }
    
    static func decode(object: Any) -> Project {
        let dict = HG.decode(hgdict: object, decoder: Project.self)
        let name = dict["name"].string
        let enums = dict["enums"].enumSet
        let entities = dict["entities"].entitySet
        let joins = dict["joins"].joinSet
        let primitiveAttributes = dict["primitiveAttributes"].primitiveAttributeSet
        let enumAttributes = dict["enumAttributes"].enumAttributeSet
        let entityAttributes = dict["entityAttributes"].entityAttributeSet
        let joinAttributes = dict["joinAttributes"].joinAttributeSet
        let usedNames = dict["usedNames"].usedNameSet
        let project = Project(name: Project.newName,
                              enums: enums,
                              entities: entities,
                              joins: joins,
                              primitiveAttributes: primitiveAttributes,
                              enumAttributes: enumAttributes,
                              entityAttributes: entityAttributes,
                              joinAttributes: joinAttributes,
                              usedNames: usedNames)
        return project
    }
}

extension Project {
    
    // MARK: - Entities
    
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
            let js = joins.filter { $0.holder1 == n || $0.holder2 == n }
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
    
    // MARK: - Joins
    
    func createIteratedJoin() -> Join? {
        
        if entities.count == 0 {
            HGReport.shared.noEntities(decoder: Join.self)
            return nil
        }
        
        let e = entities.sorted { $0.name < $1.name }
        
        let en1 = e.first!.name
        let en2 = e.last!.name
        
        if let join = joins.createIterated(holder1: en1, holder2: en2) {
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
    
    // MARK: - Enums
    
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
    
    // MARK: - Enum Cases
    
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
    
    // MARK: - PrimitiveAttributes
    
    func createPrimitiveAttribute(primitiveAttribute: PrimitiveAttribute) -> PrimitiveAttribute? {
        
        let values = [primitiveAttribute.name]
        if usedNameIn(values: values) {
            return nil
        }
        
        return primitiveAttributes.create(primitiveAttribute: primitiveAttribute)
    }
    
    func createIteratedPrimitiveAttribute(holderName: String, primitiveName: String) -> PrimitiveAttribute? {
        return primitiveAttributes.createIterated(holderName: holderName, primitiveName: primitiveName)
    }
    
    func deletePrimitiveAttribute(holderName: String) -> Bool {
        return primitiveAttributes.delete(holderName: holderName)
    }
    
    func deletePrimitiveAttribute(primitiveName: String) -> Bool {
        return primitiveAttributes.delete(primitiveName: primitiveName)
    }
    
    func deletePrimitiveAttribute(name: String, holderName: String) -> Bool {
        return primitiveAttributes.delete(name: name, holderName: holderName)
    }
    
    func updatePrimitiveAttribute(keyDict: PrimitiveAttributeKeyDict, name: String, holderName: String) -> PrimitiveAttribute? {
        
        if usedNameIn(values: keyDict.map { $0.1 }) {
            return nil
        }
        
        return primitiveAttributes.update(keyDict: keyDict, name: name, holderName: holderName)
    }
    
    // MARK: - EnumAttributes
    
    func createEnumAttribute(enumAttribute: EnumAttribute) -> EnumAttribute? {
        
        let values = [enumAttribute.name]
        if usedNameIn(values: values) {
            return nil
        }
        
        return enumAttributes.create(enumAttribute: enumAttribute)
    }
    
    func createIteratedEnumAttribute(holderName: String, enumName: String) -> EnumAttribute? {
        return enumAttributes.createIterated(holderName: holderName, enumName: enumName)
    }
    
    func deleteEnumAttribute(holderName: String) -> Bool {
        return enumAttributes.delete(holderName: holderName)
    }
    
    func deleteEnumAttribute(enumName: String) -> Bool {
        return enumAttributes.delete(enumName: enumName)
    }
    
    func deleteEnumAttribute(name: String, holderName: String) -> Bool {
        return enumAttributes.delete(name: name, holderName: holderName)
    }
    
    func updateEnumAttribute(keyDict: EnumAttributeKeyDict, name: String, holderName: String) -> EnumAttribute? {
        
        if usedNameIn(values: keyDict.map { $0.1 }) {
            return nil
        }
        
        return enumAttributes.update(keyDict: keyDict, name: name, holderName: holderName)
    }
    
    // MARK: - EntityAttributes
    
    func createEntityAttribute(entityAttribute: EntityAttribute) -> EntityAttribute? {
        
        let values = [entityAttribute.name]
        if usedNameIn(values: values) {
            return nil
        }
        
        return entityAttributes.create(entityAttribute: entityAttribute)
    }
    
    func createIteratedEntityAttribute(holderName: String, entityName: String) -> EntityAttribute? {
        return entityAttributes.createIterated(holderName: holderName, entityName: entityName)
    }
    
    func deleteEntityAttribute(name: String) -> Bool {
        return entityAttributes.delete(name: name)
    }
    
    func deleteEntityAttribute(name: String, holderName: String) -> Bool {
        return entityAttributes.delete(name: name, holderName: holderName)
    }
    
    func updateEntityAttribute(keyDict: EntityAttributeKeyDict, name: String, holderName: String) -> EntityAttribute? {
        
        // check if key values contain a usedName
        if usedNameIn(values: keyDict.map { $0.1 }) {
            return nil
        }
        
        return entityAttributes.update(keyDict: keyDict, name: name, holderName: holderName)
    }
    
    // MARK: - JoinAttributes
    
    func createJoinAttribute(joinAttribute: JoinAttribute) -> JoinAttribute? {
        
        let values = [joinAttribute.name]
        if usedNameIn(values: values) {
            return nil
        }
        
        return joinAttributes.create(joinAttribute: joinAttribute)
    }
    
    func createIteratedJoinAttribute(holderName: String, joinName: String) -> JoinAttribute? {
        return joinAttributes.createIterated(holderName: holderName, joinName: joinName)
    }
    
    func deleteJoinAttribute(name: String) -> Bool {
        return joinAttributes.delete(name: name)
    }
    
    func deleteJoinAttribute(name: String, holderName: String) -> Bool {
        return joinAttributes.delete(name: name, holderName: holderName)
    }
    
    func updateJoinAttribute(keyDict: JoinAttributeKeyDict, name: String, holderName: String) -> JoinAttribute? {
        
        // check if key values contain a usedName
        if usedNameIn(values: keyDict.map { $0.1 }) {
            return nil
        }
        
        return joinAttributes.update(keyDict: keyDict, name: name, holderName: holderName)
    }
}
