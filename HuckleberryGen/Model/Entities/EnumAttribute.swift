//
//  EntityEnumJoin.swift
//  HuckleberryGen
//
//  Created by David Vallas on 4/29/18.
//  Copyright © 2018 Phoenix Labs. All rights reserved.
//

import Foundation

enum EnumAttributeKey {
    case name
    case enumName
    case isHash
}

typealias EnumAttributeKeyDict = Dictionary<EnumAttributeKey, Any>

// this is an Entity Enum Join Record
struct EnumAttribute: HGEncodable {
    
    let name: String
    let entityName: String
    let enumName: String
    let isHash: Bool
    
    fileprivate func update(name n: String?, entityName en: String?, enumName enn: String?, isHash i: Bool?) -> EnumAttribute {
        let name = n == nil ? self.name : n!
        let entityName = en == nil ? self.entityName : en!
        let enumName = enn == nil ? self.enumName : enn!
        let isHash = i == nil ? self.isHash : i!
        return EnumAttribute(name: name, entityName: entityName, enumName: enumName, isHash: isHash)
    }
    
    // MARK: - HGEncodable
    
    static var encodeError: EnumAttribute {
        let e = "Error"
        return EnumAttribute(name: e, entityName: e, enumName: e, isHash: false)
    }
    
    var encode: Any {
        var dict = HGDICT()
        dict["name"] = name
        dict["entityName"] = entityName
        dict["enumName"] = enumName
        dict["isHash"] = isHash
        return dict
    }
    
    static func decode(object: Any) -> EnumAttribute {
        let dict = HG.decode(hgdict: object, decoderName: "Attribute")
        let name = dict["name"].string
        let entityName = dict["entityName"].string
        let enumName = dict["enumName"].string
        let isHash = dict["isHash"].bool
        return EnumAttribute(name: name, entityName: entityName, enumName: enumName, isHash: isHash)
    }
}

extension Set where Element == EnumAttribute {
    
    // this function is private because we dont want others just creating one entity, use create iterated
    fileprivate mutating func create(EnumAttribute r: EnumAttribute) -> EnumAttribute? {
        if insert(r).inserted == false {
            HGReport.shared.insertFailed(set: EnumAttribute.self, object: r)
            return nil
        }
        return r
    }
    
    // creates EnumAttribute and its inverse iterated if names already exist
    mutating func createIterated(entityName en1: String, enumName en2: String) -> EnumAttribute? {
        
        // create iterated versions of EnumAttributes names
        let name = iterated(name: en1, entityName: en1)
        
        let entityAttribute = EnumAttribute(name: name,
                                            entityName: en1,
                                            enumName: en2,
                                            isHash: false)
        
        return create(EnumAttribute: entityAttribute)
    }
    
    /// deletes All EnumAttribute with EntityName
    mutating func delete(entityName en: String) -> Bool {
        
        var deleted = false
        
        let entities = self.filter { $0.entityName == en }
        
        for entity in entities {
            if remove(entity) != nil {
                deleted = true
            }
        }
        
        if !deleted {
            HGReport.shared.deleteFailed(set: EnumAttribute.self, object: en)
            return false
        }
        
        return true
    }
    
    /// deletes All EnumAttribute with EnumName
    mutating func delete(enumName en: String) -> Bool {
        
        var deleted = false
        
        let enums = self.filter { $0.enumName == en }
        
        for enuM in enums {
            if remove(enuM) != nil {
                deleted = true
            }
        }
        
        if !deleted {
            HGReport.shared.deleteFailed(set: EnumAttribute.self, object: en)
            return false
        }
        
        return true
    }
    
    /// deletes EnumAttribute with name and enityName
    mutating func delete(name n: String, entityName en: String) -> Bool {
        
        guard let entityRelationship  = get(name: n, entityName: en) else {
            return false
        }
        
        if remove(entityRelationship) != nil {
            HGReport.shared.deleteFailed(set: EnumAttribute.self, object: entityRelationship)
            return false
        }
        
        return true
    }
    
    /// gets EnumAttribute
    func get(name n: String, entityName en: String) -> EnumAttribute? {
        let entities = self.filter { $0.name == n && $0.entityName == en }
        if entities.count == 0 {
            HGReport.shared.getFailed(set: EnumAttribute.self, keys: ["name"], values: [n])
            return nil
        }
        return entities.first!
    }
    
    mutating func update(keyDict: EnumAttributeKeyDict, name n: String, entityName en: String) -> EnumAttribute? {
        
        // get the entity that you want to update
        guard let oldEnumAttribute = get(name: n, entityName: en) else {
            return nil
        }
        
        // set key variables to nil
        var name: String?, enumName: String?, isHash: Bool?
        
        // validate and assign properties
        for key in keyDict.keys {
            switch key {
            case .name: name = HGValidate.validate(value: keyDict[key]!, key: key, decoder: EnumAttribute.self)
            case .enumName: enumName = HGValidate.validate(value: keyDict[key]!, key: key, decoder: EnumAttribute.self)
            case .isHash: isHash = HGValidate.validate(value: keyDict[key]!, key: key, decoder: EnumAttribute.self)
            }
        }
        
        // delete old EnumAttributes
        let _ = delete(name: oldEnumAttribute.name, entityName: oldEnumAttribute.entityName)
        
        // make new name iterated
        if name != nil { name = iterated(name: name!, entityName: en) }
        
        let updatedEnumAttribute = oldEnumAttribute.update(name: name,
                                                           entityName: nil,
                                                           enumName: enumName,
                                                           isHash: isHash)
        
        return create(EnumAttribute: updatedEnumAttribute)
    }
    
    fileprivate func iterated(name n: String, entityName en: String) -> String {
        var name = n.varRepresentable
        let filtered = self.filter { $0.entityName == en }
        let names = filtered.map { $0.name }
        if names.contains(name) {
            let largestNum = names.largestNum(string: name)
            name = name + "\(largestNum + 1)"
        }
        return name
    }
}

// MARK: Hashing

extension EnumAttribute: Hashable { var hashValue: Int { return (name + entityName).hashValue } }
extension EnumAttribute: Equatable {};
func ==(lhs: EnumAttribute, rhs: EnumAttribute) -> Bool { return lhs.name == rhs.name && lhs.entityName == rhs.entityName}
