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
    case entityName2
    case isArray
    case deletionRule
}

struct EntityAttribute: HGEncodable {
    
    let name: String
    let entityName1: String
    let entityName2: String
    let isArray: Bool
    let deletionRule: DeletionRule
    
    fileprivate func update(name n: String?, entityName1 en1: String?, entityName2 en2: String?, isArray a: Bool?, deletionRule dr: DeletionRule?) -> EntityAttribute {
        let name = n == nil ? self.name : n!
        let entityName1 = en1 == nil ? self.entityName1 : en1!
        let entityName2 = en2 == nil ? self.entityName2 : en2!
        let isArray = a == nil ? self.isArray : a!
        let deletionRule = dr == nil ? self.deletionRule : dr!
        return EntityAttribute(name: name,
                            entityName1: entityName1,
                            entityName2: entityName2,
                            isArray: isArray,
                            deletionRule: deletionRule)
    }
    
    // MARK: - HGEncodable
    
    static var encodeError: EntityAttribute {
        let e = "Error"
        return EntityAttribute(name: e, entityName1: e, entityName2: e, isArray: false, deletionRule: .nullify)
    }
    
    var encode: Any {
        var dict = HGDICT()
        dict["name"] = name
        dict["entityName1"] = entityName1
        dict["entityName2"] = entityName2
        dict["isArray"] = isArray
        dict["deletionRule"] = deletionRule.encode
        return dict
    }
    
    static func decode(object: Any) -> EntityAttribute {
        let dict = HG.decode(hgdict: object, decoderName: "EntityAttribute")
        let name = dict["name"].string
        let entityName1 = dict["entityName1"].string
        let entityName2 = dict["entityName2"].string
        let isArray = dict["isArray"].bool
        let deletionRule = dict["deletionRule"].deletionRule
        return EntityAttribute(name: name,
                               entityName1: entityName1,
                               entityName2: entityName2,
                               isArray: isArray,
                               deletionRule: deletionRule)
    }
}

extension Set where Element == EntityAttribute {
    
    // this function is private because we dont want others just creating one entity, use create iterated
    fileprivate mutating func create(EntityAttribute r: EntityAttribute) -> EntityAttribute? {
        if insert(r).inserted == false {
            HGReport.shared.insertFailed(set: EntityAttribute.self, object: r)
            return nil
        }
        return r
    }
    
    // creates EntityAttribute and its inverse iterated if names already exist
    mutating func createIterated(entityName1 en1: String, entityName1 en2: String) -> EntityAttribute? {
        
        // create iterated versions of EntityAttributes names
        let name = iterated(name: en1, entityName1: en1)
        
        let entityAttribute = EntityAttribute(name: name,
                                              entityName1: en1,
                                              entityName2: en2,
                                              isArray: false,
                                              deletionRule: .nullify)
        
        return create(EntityAttribute: entityAttribute)
    }
    
    /// deletes All EntityAttributes with EntityName
    mutating func delete(entityName en: String) -> Bool {
        
        var deleted = false
        
        let entities1 = self.filter { $0.entityName1 == en }
        let entities2 = self.filter { $0.entityName2 == en }
        
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
            HGReport.shared.deleteFailed(set: EntityAttribute.self, object: en)
            return false
        }
        
        return true
    }
    
    /// deletes EntityAttribute
    mutating func delete(name n: String, entityName1 en1: String) -> Bool {
        
        guard let entityRelationship  = get(name: n, entityName1: en1) else {
            return false
        }
        
        if remove(entityRelationship) != nil {
            HGReport.shared.deleteFailed(set: EntityAttribute.self, object: entityRelationship)
            return false
        }
        
        return true
    }
    
    /// gets EntityAttribute
    func get(name n: String, entityName1 en1: String) -> EntityAttribute? {
        let entities = self.filter { $0.name == n && $0.entityName1 == en1 }
        if entities.count == 0 {
            HGReport.shared.getFailed(set: EntityAttribute.self, keys: ["name"], values: [n])
            return nil
        }
        return entities.first!
    }
    
    mutating func update(keys: [EntityAttributeKey], withValues vs: [Any], name n: String, entityName1 en1: String) -> EntityAttribute? {
        
        // if keys dont match values, return
        if keys.count != vs.count {
            HGReport.shared.updateFailedKeyMismatch(set: EntityAttribute.self)
            return nil
        }
        
        // get the entity that you want to update
        guard let oldEntityAttribute = get(name: n, entityName1: en1) else {
            return nil
        }
        
        // set key variables to nil
        var name: String?, entityName2: String?, isArray: Bool?, deletionRule: DeletionRule?
        
        // validate and assign properties
        var i = 0
        for key in keys {
            let v = vs[i]
            switch key {
            case .name: name = HGValidate.validate(value: v, key: key, decoder: EntityAttribute.self)
            case .entityName2: entityName2 = HGValidate.validate(value: v, key: key, decoder: EntityAttribute.self)
            case .isArray: isArray = HGValidate.validate(value: v, key: key, decoder: EntityAttribute.self)
            case .deletionRule: deletionRule = HGValidate.validate(value: v, key: key, decoder: EntityAttribute.self)
            }
            i += 1
        }
        
        // delete old EntityAttributes
        let _ = delete(name: oldEntityAttribute.name, entityName1: oldEntityAttribute.entityName1)
        
        // make new name iterated
        if name != nil { name = iterated(name: name!, entityName1: en1) }
        
        let updatedEntityAttribute = oldEntityAttribute.update(name: name,
                                                         entityName1: nil,
                                                         entityName2: entityName2,
                                                         isArray: isArray,
                                                         deletionRule: deletionRule)
        
        return create(EntityAttribute: updatedEntityAttribute)
    }
    
    fileprivate func iterated(name n: String, entityName1 en1: String) -> String {
        var name = n.varRepresentable
        let filtered = self.filter { $0.entityName1 == en1 }
        let names = filtered.map { $0.name }
        if names.contains(name) {
            let largestNum = names.largestNum(string: name)
            name = name + "\(largestNum + 1)"
        }
        return name
    }
}

extension EntityAttribute: Hashable { var hashValue: Int { return (name + entityName1).hashValue } }
extension EntityAttribute: Equatable {}; func ==(lhs: EntityAttribute, rhs: EntityAttribute) -> Bool {
    return lhs.name == rhs.name && lhs.entityName1 == rhs.entityName1
}
