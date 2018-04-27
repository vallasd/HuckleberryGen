//
//  Attribute2.swift
//  HuckleberryGen
//
//  Created by David Vallas on 4/26/18.
//  Copyright © 2018 Phoenix Labs. All rights reserved.
//

import Foundation

enum Attribute2KeyPath {
    case name
    case entityName
    case typeName
    case type
}

struct Attribute2 {
    
    let name: String
    let entityName: String
    let typeName: String
    let type: HGType
    
    init(name n: String, entityName en: String, typeName tn: String, type t: HGType) {
        name = n
        entityName = en
        typeName = tn
        type = t
    }
    
    init(name n: String, entityName en: String) {
        name = n
        entityName = en
        typeName = Primitive._int.name
        type = .primitive
    }
    
    func update(name n: String?, entityName en: String?, typeName tn: String?, type t: HGType?) -> Attribute2 {
        let name = n == nil ? self.name : n!
        let entityName = en == nil ? self.entityName : en!
        let typeName = tn == nil ? self.typeName : tn!
        let type = t == nil ? self.type : t!
        return Attribute2(name: name, entityName: entityName, typeName: typeName, type: type)
    }
    
    // MARK: - HGEncodable
    
    static var encodeError: Attribute2 {
        return Attribute2(name: "Error", entityName: "Error", typeName: "Error", type: .primitive)
    }
    
    var encode: Any {
        var dict = HGDICT()
        dict["name"] = name
        dict["entityName"] = entityName
        dict["typeName"] = typeName
        dict["type"] = type.rawValue
        return dict
    }
    
    static func decode(object: Any) -> Attribute2 {
        let dict = HG.decode(hgdict: object, decoderName: "Attribute2")
        let n = dict["name"].string
        let en = dict["entityName"].string
        let tn = dict["typeName"].string
        let t = dict["type"].hGtype
        return Attribute2(name: n, entityName: en, typeName: tn, type: t)
    }
}

extension Set where Element == Attribute2 {
    
    
    
    mutating func create(attribute a: Attribute2) -> Attribute2? {
        if insert(a).inserted == false {
            HGReport.shared.insertFailed(set: Attribute2.self, object: a)
            return nil
        }
        return a
    }
    
    mutating func create(entityName: String) -> Attribute2? {
        let name = iteratedName(name: "New Attribute", entityName: entityName)
        let a = Attribute2(name: name, entityName: entityName)
        return create(attribute: a)
    }
    
    mutating func delete(name n: String, entityName en: String) -> Bool {
        let a = Attribute2(name: n, entityName: en)
        let o = remove(a)
        if o == nil {
            HGReport.shared.deleteFailed(set: Attribute2.self, object: a)
            return false
        }
        return true
    }
    
    func get(name n: String, entityName en: String) -> Attribute2? {

        let attributes = self.filter { $0.name == n && $0.entityName == en }
        if attributes.count == 0 {
            HGReport.shared.getFailed(set: Attribute2.self, keys: ["name", "entityName"], values: [n,en])
            return nil
        }
        
        return attributes.first!
    }
    
    mutating func update(keys: [Attribute2KeyPath], withValues vs: [Any], name n: String, entityName en: String) -> Attribute2? {
        
        // if keys dont match values, return
        if keys.count != vs.count {
            HGReport.shared.updateFailedKeyMismatch(set: Attribute2.self)
            return nil
        }
        
        // get the entity from the set
        guard let oa = get(name: n, entityName: en) else {
            return nil
        }
        
        // set key variables to nil
        var name: String?, entityName: String?, typeName: String?, type: HGType?
        
        // validate and assign properties
        var i = 0
        for key in keys {
            let v = vs[i]
            switch key {
            case .name: name = HGValidate.validate(value: v, key: key, decoder: Attribute2.self)
            case .entityName: entityName = HGValidate.validate(value: v, key: key, decoder: Attribute2.self)
            case .typeName: typeName = HGValidate.validate(value: v, key: key, decoder: Attribute2.self)
            case .type: type = HGValidate.validate(value: v, key: key, decoder: Attribute2.self)
            }
            i += 1
        }
        
        // make sure name is iterated, we are going to delete old record and add new
        if name != nil || entityName != nil {
            if name == nil { name = oa.name }
            if entityName == nil { entityName = oa.entityName }
            name = iteratedName(name: name!, entityName: entityName!)
            let _ = delete(name: oa.name, entityName: oa.entityName)
            let newAttribute = oa.update(name: name, entityName: entityName, typeName: typeName, type: type)
            let new = create(attribute: newAttribute)
            return new
        }
        
        // use traditional update
        let newAttribute = oa.update(name: name, entityName: entityName, typeName: typeName, type: type)
        let updatedEntity = update(with: newAttribute)
        if updatedEntity == nil {
            HGReport.shared.updateFailedGeneric(set: Attribute2.self)
        }
        
        return updatedEntity
    }

    fileprivate func iteratedName(name n: String, entityName en: String) -> String {
        var name = n.varRepresentable
        let a = Attribute2(name: name, entityName: en)
        if self.contains(a) {
            let filtered = self.filter { $0.entityName == en }
            let names = filtered.map { $0.name }
            let largestNum = names.largestNum(string: name)
            name = name + "\(largestNum + 1)"
        }
        return name
    }
}

extension Attribute2: Hashable { var hashValue: Int { return (name + entityName).hashValue } }
extension Attribute2: Equatable {}; func ==(lhs: Attribute2, rhs: Attribute2) -> Bool {
    return lhs.name == rhs.name && lhs.entityName == rhs.entityName
}

