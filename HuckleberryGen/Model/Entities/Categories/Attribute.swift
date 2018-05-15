//
//  Attribute.swift
//  HuckleberryGen
//
//  Created by David Vallas on 4/26/18.
//  Copyright © 2018 Phoenix Labs. All rights reserved.
//

import Foundation

enum AttributeKey {
    case name
    case typeName
    case isHash
}

typealias AttributeKeyDict = Dictionary<AttributeKey, Any>

struct Attribute: HGCodable {
    
    let name: String
    let typeName: String
    let isHash: Bool
    
    init(name n: String, typeName tn: String, isHash h: Bool) {
        name = n
        typeName = tn
        isHash = h
    }
    
    init(name n: String) {
        name = n
        typeName = Primitive._int.name
        isHash = false
    }
    
    fileprivate func update(name n: String?, typeName tn: String?, isHash i: Bool?) -> Attribute {
        let name = n == nil ? self.name : n!
        let typeName = tn == nil ? self.typeName : tn!
        let isHash = i == nil ? self.isHash : i!
        return Attribute(name: name, typeName: typeName, isHash: isHash)
    }
    
    // MARK: - HGCodable
    
    static var encodeError: Attribute {
        let e = "Error"
        return Attribute(name: e, typeName: e, isHash: false)
    }
    
    var encode: Any {
        var dict = HGDICT()
        dict["name"] = name
        dict["typeName"] = typeName
        dict["isHash"] = isHash
        return dict
    }
    
    static func decode(object: Any) -> Attribute {
        let dict = HG.decode(hgdict: object, decoder: Attribute.self)
        let n = dict["name"].string
        let tn = dict["typeName"].string
        let i = dict["isHash"].bool
        return Attribute(name: n, typeName: tn, isHash: i)
    }
}

extension Set where Element == Attribute {
    
    mutating func create(attribute a: Attribute) -> Attribute? {
        if insert(a).inserted == false {
            HGReport.shared.insertFailed(set: Attribute.self, object: a)
            return nil
        }
        return a
    }
    
    mutating func createIterated() -> Attribute? {
        let name = self.map { $0.name }.iteratedTypeRepresentable(string: "New Attribute")
        let a = Attribute(name: name)
        return create(attribute: a)
    }
    
    mutating func delete(name n: String) -> Bool {
        let a = Attribute(name: n)
        let o = remove(a)
        if o == nil {
            HGReport.shared.deleteFailed(set: Attribute.self, object: a)
            return false
        }
        return true
    }
    
    func get(name n: String) -> Attribute? {

        let attributes = self.filter { $0.name == n }
        if attributes.count == 0 {
            HGReport.shared.getFailed(set: Attribute.self, keys: ["name"], values: [n])
            return nil
        }
        
        return attributes.first!
    }
    
    mutating func update(keyDict: AttributeKeyDict, name n: String) -> Attribute? {
        
        // get the entity from the set
        guard let oldAttribute = get(name: n) else {
            return nil
        }
        
        // set key variables to nil
        var name: String?, typeName: String?, isHash: Bool?
        
        // validate and assign properties
        for key in keyDict.keys {
            switch key {
            case .name: name = HGValidate.validate(value: keyDict[key]!, key: key, decoder: Attribute.self)
            case .typeName: typeName = HGValidate.validate(value: keyDict[key]!, key: key, decoder: Attribute.self)
            case .isHash: isHash = HGValidate.validate(value: keyDict[key]!, key: key, decoder: Attribute.self)
            }
        }
        
        // make sure name is iterated, we are going to delete old record and add new
        if name != nil { name = self.map { $0.name }.iteratedVarRepresentable(string: name!) }
        
        // use traditional update
        let newAttribute = oldAttribute.update(name: name,
                                               typeName: typeName,
                                               isHash: isHash)
        let _ = delete(name: oldAttribute.name)
        let updated = create(attribute: newAttribute)
        
        return updated
    }
}

extension Attribute: Hashable { var hashValue: Int { return name.hashValue } }
extension Attribute: Equatable {}; func ==(lhs: Attribute, rhs: Attribute) -> Bool { return lhs.name == rhs.name }

