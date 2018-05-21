//
//  JoinAttribute.swift
//  HuckleberryGen
//
//  Created by David Vallas on 5/21/18.
//  Copyright © 2018 Phoenix Labs. All rights reserved.
//

import Foundation

enum JoinAttributeKey {
    case name
    case joinName
    case isArray
    case deletionRule
}

typealias JoinAttributeKeyDict = Dictionary<JoinAttributeKey, Any>

struct JoinAttribute: HGCodable {
    
    let name: String
    let holderName: String // name of object that owns this JoinAttribute, can be a join or entity
    let joinName: String
    let isArray: Bool
    let deletionRule: DeletionRule
    
    fileprivate func update(name n: String?, holderName hn: String?, joinName en: String?, isArray a: Bool?, deletionRule dr: DeletionRule?) -> JoinAttribute {
        let name = n == nil ? self.name : n!
        let holderName = hn == nil ? self.holderName : hn!
        let joinName = en == nil ? self.joinName : en!
        let isArray = a == nil ? self.isArray : a!
        let deletionRule = dr == nil ? self.deletionRule : dr!
        return JoinAttribute(name: name,
                               holderName: holderName,
                               joinName: joinName,
                               isArray: isArray,
                               deletionRule: deletionRule)
    }
    
    // MARK: - HGCodable
    
    static var encodeError: JoinAttribute {
        let e = "Error"
        return JoinAttribute(name: e, holderName: e, joinName: e, isArray: false, deletionRule: .nullify)
    }
    
    var encode: Any {
        var dict = HGDICT()
        dict["name"] = name
        dict["holderName"] = holderName
        dict["joinName"] = joinName
        dict["isArray"] = isArray
        dict["deletionRule"] = deletionRule.encode
        return dict
    }
    
    static func decode(object: Any) -> JoinAttribute {
        let dict = HG.decode(hgdict: object, decoder: JoinAttribute.self)
        let name = dict["name"].string
        let holderName = dict["holderName"].string
        let joinName = dict["joinName"].string
        let isArray = dict["isArray"].bool
        let deletionRule = dict["deletionRule"].deletionRule
        return JoinAttribute(name: name,
                               holderName: holderName,
                               joinName: joinName,
                               isArray: isArray,
                               deletionRule: deletionRule)
    }
}

extension Set where Element == JoinAttribute {
    
    // this function is private because we dont want others just creating one entity, use create iterated
    mutating func create(joinAttribute: JoinAttribute) -> JoinAttribute? {
        if insert(joinAttribute).inserted == false {
            HGReport.shared.insertFailed(set: JoinAttribute.self, object: joinAttribute)
            return nil
        }
        return joinAttribute
    }
    
    // creates JoinAttribute and its inverse iterated if names already exist
    mutating func createIterated(holderName: String, joinName: String) -> JoinAttribute? {
        
        // create iterated versions of JoinAttributes names
        let name = iterated(name: joinName, holderName: holderName)
        
        let joinAttribute = JoinAttribute(name: name,
                                              holderName: holderName,
                                              joinName: joinName,
                                              isArray: false,
                                              deletionRule: .nullify)
        
        return create(joinAttribute: joinAttribute)
    }
    
    /// deletes All JoinAttributes with either the HolderName or EntityName matching
    mutating func delete(name: String) -> Bool {
        
        var deleted = false
        
        let entities1 = self.filter { $0.holderName == name }
        let entities2 = self.filter { $0.joinName == name }
        
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
            HGReport.shared.deleteFailed(set: JoinAttribute.self, object: name)
            return false
        }
        
        return true
    }
    
    /// deletes JoinAttribute
    mutating func delete(name: String, holderName: String) -> Bool {
        
        guard let joinAttribute = get(name: name, holderName: holderName) else {
            return false
        }
        
        if remove(joinAttribute) != nil {
            HGReport.shared.deleteFailed(set: JoinAttribute.self, object: joinAttribute)
            return false
        }
        
        return true
    }
    
    /// gets JoinAttribute
    func get(name: String, holderName: String) -> JoinAttribute? {
        let entities = self.filter { $0.name == name && $0.holderName == holderName }
        if entities.count == 0 {
            HGReport.shared.getFailed(set: JoinAttribute.self, keys: ["name"], values: [name])
            return nil
        }
        return entities.first!
    }
    
    mutating func update(keyDict: JoinAttributeKeyDict, name n: String, holderName hn: String) -> JoinAttribute? {
        
        // get the entity that you want to update
        guard let oldJoinAttribute = get(name: n, holderName: hn) else {
            return nil
        }
        
        // set key variables to nil
        var name: String?, joinName: String?, isArray: Bool?, deletionRule: DeletionRule?
        
        // validate and assign properties
        for key in keyDict.keys {
            switch key {
            case .name: name = HGValidate.validate(value: keyDict[key]!, key: key, decoder: JoinAttribute.self)
            case .joinName: joinName = HGValidate.validate(value: keyDict[key]!, key: key, decoder: JoinAttribute.self)
            case .isArray: isArray = HGValidate.validate(value: keyDict[key]!, key: key, decoder: JoinAttribute.self)
            case .deletionRule: deletionRule = HGValidate.validate(value: keyDict[key]!, key: key, decoder: JoinAttribute.self)
            }
        }
        
        // delete old JoinAttributes
        let _ = delete(name: oldJoinAttribute.name, holderName: oldJoinAttribute.holderName)
        
        // make new name iterated
        if name != nil { name = iterated(name: name!, holderName: hn) }
        
        let updatedJoinAttribute = oldJoinAttribute.update(name: name,
                                                               holderName: nil,
                                                               joinName: joinName,
                                                               isArray: isArray,
                                                               deletionRule: deletionRule)
        
        return create(joinAttribute: updatedJoinAttribute)
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

extension JoinAttribute: Hashable { var hashValue: Int { return (name + holderName).hashValue } }
extension JoinAttribute: Equatable {}; func ==(lhs: JoinAttribute, rhs: JoinAttribute) -> Bool {
    return lhs.name == rhs.name && lhs.holderName == rhs.holderName
}

