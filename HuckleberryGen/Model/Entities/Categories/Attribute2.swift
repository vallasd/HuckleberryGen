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
    case typeName
    case type
    case isHash
}

struct Attribute2: HGEncodable {
    
    let name: String
    let typeName: String
    let type: HGType
    let isHash: Bool
    
    init(name n: String, typeName tn: String, type t: HGType, isHash h: Bool) {
        name = n
        typeName = tn
        type = t
        isHash = h
    }
    
    init(name n: String) {
        name = n
        typeName = Primitive._int.name
        type = .primitive
        isHash = false
    }
    
    func update(name n: String?, typeName tn: String?, type t: HGType?, isHash i: Bool?) -> Attribute2 {
        let name = n == nil ? self.name : n!
        let typeName = tn == nil ? self.typeName : tn!
        let type = t == nil ? self.type : t!
        let isHash = i == nil ? self.isHash : i!
        return Attribute2(name: name, typeName: typeName, type: type, isHash: isHash)
    }
    
    // MARK: - HGEncodable
    
    static var encodeError: Attribute2 {
        let e = "Error"
        return Attribute2(name: e, typeName: e, type: .primitive, isHash: false)
    }
    
    var encode: Any {
        var dict = HGDICT()
        dict["name"] = name
        dict["typeName"] = typeName
        dict["type"] = type.rawValue
        dict["isHash"] = isHash
        return dict
    }
    
    static func decode(object: Any) -> Attribute2 {
        let dict = HG.decode(hgdict: object, decoderName: "Attribute2")
        let n = dict["name"].string
        let tn = dict["typeName"].string
        let t = dict["type"].hGtype
        let i = dict["isHash"].bool
        return Attribute2(name: n, typeName: tn, type: t, isHash: i)
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
    
    mutating func createIterated() -> Attribute2? {
        let name = iteratedName(name: "New Attribute")
        let a = Attribute2(name: name)
        return create(attribute: a)
    }
    
    mutating func delete(name n: String) -> Bool {
        let a = Attribute2(name: n)
        let o = remove(a)
        if o == nil {
            HGReport.shared.deleteFailed(set: Attribute2.self, object: a)
            return false
        }
        return true
    }
    
    func get(name n: String) -> Attribute2? {

        let attributes = self.filter { $0.name == n }
        if attributes.count == 0 {
            HGReport.shared.getFailed(set: Attribute2.self, keys: ["name"], values: [n])
            return nil
        }
        
        return attributes.first!
    }
    
    mutating func update(keys: [Attribute2KeyPath], withValues vs: [Any], name n: String) -> Attribute2? {
        
        // if keys dont match values, return
        if keys.count != vs.count {
            HGReport.shared.updateFailedKeyMismatch(set: Attribute2.self)
            return nil
        }
        
        // get the entity from the set
        guard let oldAttribute = get(name: n) else {
            return nil
        }
        
        // set key variables to nil
        var name: String?, typeName: String?, type: HGType?, isHash: Bool?
        
        // validate and assign properties
        var i = 0
        for key in keys {
            let v = vs[i]
            switch key {
            case .name: name = HGValidate.validate(value: v, key: key, decoder: Attribute2.self)
            case .typeName: typeName = HGValidate.validate(value: v, key: key, decoder: Attribute2.self)
            case .type: type = HGValidate.validate(value: v, key: key, decoder: Attribute2.self)
            case .isHash: isHash = HGValidate.validate(value: v, key: key, decoder: Attribute2.self)
            }
            i += 1
        }
        
        // make sure name is iterated, we are going to delete old record and add new
        if name != nil {
            name = iteratedName(name: name!)
            let _ = delete(name: oldAttribute.name)
            let newAttribute = oldAttribute.update(name: name, typeName: typeName, type: type, isHash: isHash)
            let new = create(attribute: newAttribute)
            return new
        }
        
        // use traditional update
        let newAttribute = oldAttribute.update(name: name, typeName: typeName, type: type, isHash: isHash)
        let updated = update(with: newAttribute)
        if updated == nil {
            HGReport.shared.updateFailedGeneric(set: Attribute2.self)
        }
        
        return updated
    }

    fileprivate func iteratedName(name n: String) -> String {
        var name = n.varRepresentable
        let a = Attribute2(name: name)
        if self.contains(a) {
            let names = self.map { $0.name }
            let largestNum = names.largestNum(string: name)
            name = name + "\(largestNum + 1)"
        }
        return name
    }
}

extension Attribute2: Hashable { var hashValue: Int { return name.hashValue } }
extension Attribute2: Equatable {}; func ==(lhs: Attribute2, rhs: Attribute2) -> Bool { return lhs.name == rhs.name }

