//
//  EntityAttribute.swift
//  HuckleberryGen
//
//  Created by David Vallas on 4/26/18.
//  Copyright © 2018 Phoenix Labs. All rights reserved.
//

import Foundation

enum EntityAttributeKey {
    case name
    case entityName
    case isArray
    case deletionRule
}

typealias EntityAttributeKeyDict = Dictionary<EntityAttributeKey, Any>

struct EntityAttribute: HGCodable {
    
    let name: String
    let holderName: String // name of object that owns this EntityAttribute, can be a join or entity
    let entityName: String
    let isArray: Bool
    let deletionRule: DeletionRule
    
    fileprivate func update(name n: String?, holderName hn: String?, entityName en: String?, isArray a: Bool?, deletionRule dr: DeletionRule?) -> EntityAttribute {
        let name = n == nil ? self.name : n!
        let holderName = hn == nil ? self.holderName : hn!
        let entityName = en == nil ? self.entityName : en!
        let isArray = a == nil ? self.isArray : a!
        let deletionRule = dr == nil ? self.deletionRule : dr!
        return EntityAttribute(name: name,
                            holderName: holderName,
                            entityName: entityName,
                            isArray: isArray,
                            deletionRule: deletionRule)
    }
    
    // MARK: - HGCodable
    
    static var encodeError: EntityAttribute {
        let e = "Error"
        return EntityAttribute(name: e, holderName: e, entityName: e, isArray: false, deletionRule: .nullify)
    }
    
    var encode: Any {
        var dict = HGDICT()
        dict["name"] = name
        dict["holderName"] = holderName
        dict["entityName"] = entityName
        dict["isArray"] = isArray
        dict["deletionRule"] = deletionRule.encode
        return dict
    }
    
    static func decode(object: Any) -> EntityAttribute {
        let dict = HG.decode(hgdict: object, decoder: EntityAttribute.self)
        let name = dict["name"].string
        let holderName = dict["holderName"].string
        let entityName = dict["entityName"].string
        let isArray = dict["isArray"].bool
        let deletionRule = dict["deletionRule"].deletionRule
        return EntityAttribute(name: name,
                               holderName: holderName,
                               entityName: entityName,
                               isArray: isArray,
                               deletionRule: deletionRule)
    }
}

extension Set where Element == EntityAttribute {
    
    // this function is private because we dont want others just creating one entity, use create iterated
    mutating func create(entityAttribute: EntityAttribute) -> EntityAttribute? {
        if insert(entityAttribute).inserted == false {
            HGReport.shared.insertFailed(set: EntityAttribute.self, object: entityAttribute)
            return nil
        }
        return entityAttribute
    }
    
    // creates EntityAttribute and its inverse iterated if names already exist
    mutating func createIterated(holderName: String, entityName: String) -> EntityAttribute? {
        
        // create iterated versions of EntityAttributes names
        let name = iterated(name: entityName, holderName: holderName)
        
        let entityAttribute = EntityAttribute(name: name,
                                              holderName: holderName,
                                              entityName: entityName,
                                              isArray: false,
                                              deletionRule: .nullify)
        
        return create(entityAttribute: entityAttribute)
    }
    
    /// deletes All EntityAttributes with either the HolderName or EntityName matching
    mutating func delete(name: String) -> Bool {
        
        var deleted = false
        
        let entities1 = self.filter { $0.holderName == name }
        let entities2 = self.filter { $0.entityName == name }
        
        for entity in entities1 {
            if remove(entity) != nil {
                deleted = true
            }
        }
        
        for entity in entities2 {
            if remove(entity) != nil {
                deleted = true
            }
        }
        
        if !deleted {
            HGReport.shared.deleteFailed(set: EntityAttribute.self, object: name)
            return false
        }
        
        return true
    }
    
    /// deletes EntityAttribute
    mutating func delete(name: String, holderName: String) -> Bool {
        
        guard let entityAttribute = get(name: name, holderName: holderName) else {
            return false
        }
        
        if remove(entityAttribute) != nil {
            HGReport.shared.deleteFailed(set: EntityAttribute.self, object: entityAttribute)
            return false
        }
        
        return true
    }
    
    /// gets EntityAttribute
    func get(name: String, holderName: String) -> EntityAttribute? {
        let entities = self.filter { $0.name == name && $0.holderName == holderName }
        if entities.count == 0 {
            HGReport.shared.getFailed(set: EntityAttribute.self, keys: ["name"], values: [name])
            return nil
        }
        return entities.first!
    }
    
    mutating func update(keyDict: EntityAttributeKeyDict, name n: String, holderName hn: String) -> EntityAttribute? {
        
        // get the entity that you want to update
        guard let oldEntityAttribute = get(name: n, holderName: hn) else {
            return nil
        }
        
        // set key variables to nil
        var name: String?, entityName: String?, isArray: Bool?, deletionRule: DeletionRule?
        
        // validate and assign properties
        for key in keyDict.keys {
            switch key {
            case .name: name = HGValidate.validate(value: keyDict[key]!, key: key, decoder: EntityAttribute.self)
            case .entityName: entityName = HGValidate.validate(value: keyDict[key]!, key: key, decoder: EntityAttribute.self)
            case .isArray: isArray = HGValidate.validate(value: keyDict[key]!, key: key, decoder: EntityAttribute.self)
            case .deletionRule: deletionRule = HGValidate.validate(value: keyDict[key]!, key: key, decoder: EntityAttribute.self)
            }
        }
        
        // delete old EntityAttributes
        let _ = delete(name: oldEntityAttribute.name, holderName: oldEntityAttribute.holderName)
        
        // make new name iterated
        if name != nil { name = iterated(name: name!, holderName: hn) }
        
        let updatedEntityAttribute = oldEntityAttribute.update(name: name,
                                                               holderName: nil,
                                                               entityName: entityName,
                                                               isArray: isArray,
                                                               deletionRule: deletionRule)
        
        return create(entityAttribute: updatedEntityAttribute)
    }
    
    fileprivate func iterated(name n: String, holderName hn: String) -> String {
        var name = n.varRepresentable
        let filtered = self.filter { $0.holderName == hn }
        let names = filtered.map { $0.name }
        if names.contains(name) {
            let largestNum = names.largestNum(string: name)
            name = name + "\(largestNum + 1)"
        }
        return name
    }
}

extension EntityAttribute: Hashable { var hashValue: Int { return (name + holderName).hashValue } }
extension EntityAttribute: Equatable {}; func ==(lhs: EntityAttribute, rhs: EntityAttribute) -> Bool {
    return lhs.name == rhs.name && lhs.holderName == rhs.holderName
}
