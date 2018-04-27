//
//  Relationship.swift
//  HuckleberryGen
//
//  Created by David Vallas on 4/26/18.
//  Copyright © 2018 Phoenix Labs. All rights reserved.
//

import Foundation

enum RelationshipKey {
    case name
    case entityName
    case isArray
    case deletionRule
}

struct Relationship: HGEncodable {
    
    let name: String
    let entityName: String
    let inverseName: String
    let inverseEntityName: String
    let isArray: Bool
    let deletionRule: DeletionRule
    
    fileprivate func update(name n: String?, entityName en: String?, inverseName ivn: String?, inverseEntityName ien: String?, isArray a: Bool?, deletionRule dr: DeletionRule?) -> Relationship {
        let name = n == nil ? self.name : n!
        let entityName = en == nil ? self.entityName : en!
        let inverseName = ivn == nil ? self.inverseName : ivn!
        let inverseEntityName = ien == nil ? self.inverseEntityName : ien!
        let isArray = a == nil ? self.isArray : a!
        let deletionRule = dr == nil ? self.deletionRule : dr!
        return Relationship(name: name,
                            entityName: entityName,
                            inverseName: inverseName,
                            inverseEntityName: inverseEntityName,
                            isArray: isArray,
                            deletionRule: deletionRule)
    }
    
    // MARK: - HGEncodable
    
    static var encodeError: Relationship {
        let e = "Error"
        return Relationship(name: e, entityName: e, inverseName: e, inverseEntityName: e, isArray: false, deletionRule: .nullify)
    }
    
    var encode: Any {
        var dict = HGDICT()
        dict["name"] = name
        dict["entityName"] = entityName
        dict["inverseName"] = inverseName
        dict["inverseEntityName"] = inverseEntityName
        dict["isArray"] = isArray
        dict["deletionRule"] = deletionRule.encode
        return dict
    }
    
    static func decode(object: Any) -> Relationship {
        let dict = HG.decode(hgdict: object, decoderName: "Relationship")
        let n = dict["name"].string
        let en = dict["entityName"].string
        let i = dict["inverseName"].string
        let ien = dict["inverseEntityName"].string
        let a = dict["isArray"].bool
        let dr = dict["deletionRule"].deletionRule
        return Relationship(name: n, entityName: en, inverseName: i, inverseEntityName: ien, isArray: a, deletionRule: dr)
    }
}

extension Set where Element == Relationship {
    
    // this function is private because we dont want others just creating one entity, use create iterated
    fileprivate mutating func create(relationship r: Relationship) -> Relationship? {
        if insert(r).inserted == false {
            HGReport.shared.insertFailed(set: Relationship.self, object: r)
            return nil
        }
        return r
    }
    
    // creates relationship and its inverse iterated if names already exist
    mutating func createIterated(entityName en: String, inverseEntityName ien: String) -> [Relationship] {
        
        // create iterated versions of relationships names
        let name = iterated(name: en, entityName: en)
        let inverseName = iterated(name: ien, entityName: ien)
        
        let relationship = Relationship(name: name,
                                        entityName: en,
                                        inverseName: inverseName,
                                        inverseEntityName: ien,
                                        isArray: false,
                                        deletionRule: .nullify)
        
        let inverseRelationship = Relationship(name: inverseName,
                                               entityName: ien,
                                               inverseName: name,
                                               inverseEntityName: en,
                                               isArray: false,
                                               deletionRule: .nullify)
        
        var relationships: [Relationship] = []
        if let r1 = create(relationship: relationship) { relationships.append(r1) }
        if let r2 = create(relationship: inverseRelationship) { relationships.append(r2) }
        
        return relationships
    }
    
    /// deletes relationship and its inverse
    mutating func delete(name n: String, entityName en: String) -> Bool {
        
        guard let r1 = get(name: n, entityName: en) else {
            return false
        }
        
        guard let r2 = get(name: r1.inverseName, entityName: r1.inverseEntityName) else {
            return false
        }
        
        guard let _ = remove(r1) else {
            HGReport.shared.deleteFailed(set: Relationship.self, object: r1)
            return false
        }
        
        guard let _ = remove(r2) else {
            HGReport.shared.deleteFailed(set: Relationship.self, object: r2)
            return false
        }
        
        return true
    }
    
    /// gets relationship
    func get(name n: String, entityName en: String) -> Relationship? {
        let entities = self.filter { $0.name == n && $0.entityName == en }
        if entities.count == 0 {
            HGReport.shared.getFailed(set: Relationship.self, keys: ["name"], values: [n])
            return nil
        }
        return entities.first!
    }
    
    mutating func update(keys: [RelationshipKey], withValues vs: [Any], name n: String, entityName en: String) -> [Relationship] {
        
        // if keys dont match values, return
        if keys.count != vs.count {
            HGReport.shared.updateFailedKeyMismatch(set: Relationship.self)
            return []
        }
        
        // get old Relationship
        guard let oldRelationship = get(name: n, entityName: en) else {
            return []
        }
        
        // get old Inverse
        guard let oldInverse = get(name: oldRelationship.inverseName, entityName: oldRelationship.inverseEntityName) else {
            return []
        }
        
        // set key variables to nil
        var name: String?, entityName: String?, isArray: Bool?, deletionRule: DeletionRule?
        
        // validate and assign properties
        var i = 0
        for key in keys {
            let v = vs[i]
            switch key {
            case .name: name = HGValidate.validate(value: v, key: key, decoder: Relationship.self)
            case .entityName: entityName = HGValidate.validate(value: v, key: key, decoder: Relationship.self)
            case .isArray: isArray = HGValidate.validate(value: v, key: key, decoder: Relationship.self)
            case .deletionRule: deletionRule = HGValidate.validate(value: v, key: key, decoder: Relationship.self)
            }
            i += 1
        }
        
        // delete old relationships
        let _ = delete(name: oldRelationship.name, entityName: oldRelationship.entityName)
        
        // set new entityNames
        if entityName == nil  { entityName = oldRelationship.entityName }
        
        // make sure name is iterated, we are going to delete old record and add new
        if name != nil { name = iterated(name: name!, entityName: entityName!) }
        
        let updatedRelationship = oldRelationship.update(name: name,
                                                         entityName: entityName,
                                                         inverseName: nil,
                                                         inverseEntityName: nil,
                                                         isArray: isArray,
                                                         deletionRule: deletionRule)
        
        let updatedInverse = oldInverse.update(name: nil,
                                               entityName: nil,
                                               inverseName: name,
                                               inverseEntityName: entityName,
                                               isArray: nil,
                                               deletionRule: nil)
        
        // create the new relationships
        let u1 = create(relationship: updatedRelationship)
        let u2 = create(relationship: updatedInverse)
        
        let updated: [Relationship] = [u1,u2].filter { $0 != nil } as! [Relationship]
        
        return updated
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

extension Relationship: Hashable { var hashValue: Int { return (name + entityName).hashValue } }
extension Relationship: Equatable {}; func ==(lhs: Relationship, rhs: Relationship) -> Bool {
    return lhs.name == rhs.name && lhs.entityName == rhs.entityName
}
