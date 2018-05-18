//
//  EntityEnumJoin.swift
//  HuckleberryGen
//
//  Created by David Vallas on 4/29/18.
//  Copyright © 2018 Phoenix Labs. All rights reserved.
//

import Foundation

enum PrimitiveAttributeKey {
    case name
    case primitiveName
    case isHash
    case isArray
}

typealias PrimitiveAttributeKeyDict = Dictionary<PrimitiveAttributeKey, Any>

struct PrimitiveAttribute: HGCodable {
    
    let name: String
    let holderName: String
    let primitiveName: String
    let isHash: Bool
    let isArray: Bool
    
    fileprivate func update(name n: String?, holderName hn: String?, primitiveName pn: String?, isHash i: Bool?, isArray ia: Bool?) -> PrimitiveAttribute {
        let name = n == nil ? self.name : n!
        let holderName = hn == nil ? self.holderName : hn!
        let primitiveName = pn == nil ? self.primitiveName : pn!
        let isHash = i == nil ? self.isHash : i!
        let isArray = ia == nil ? self.isArray : ia!
        return PrimitiveAttribute(name: name,
                                  holderName: holderName,
                                  primitiveName: primitiveName,
                                  isHash: isHash,
                                  isArray: isArray)
    }
    
    // MARK: - HGCodable
    
    static var encodeError: PrimitiveAttribute {
        let e = "Error"
        return PrimitiveAttribute(name: e,
                                  holderName: e,
                                  primitiveName: e,
                                  isHash: false,
                                  isArray: false)
    }
    
    var encode: Any {
        var dict = HGDICT()
        dict["name"] = name
        dict["holderName"] = holderName
        dict["primitiveName"] = primitiveName
        dict["isHash"] = isHash
        dict["isArray"] = isArray
        return dict
    }
    
    static func decode(object: Any) -> PrimitiveAttribute {
        let dict = HG.decode(hgdict: object, decoder: EnumAttribute.self)
        let name = dict["name"].string
        let holderName = dict["holderName"].string
        let primitiveName = dict["primitiveName"].string
        let isHash = dict["isHash"].bool
        let isArray = dict["isArray"].bool
        return PrimitiveAttribute(name: name,
                                  holderName: holderName,
                                  primitiveName: primitiveName,
                                  isHash: isHash,
                                  isArray: isArray)
    }
}

extension Set where Element == PrimitiveAttribute {
    
    mutating func create(primitiveAttribute: PrimitiveAttribute) -> PrimitiveAttribute? {
        if insert(primitiveAttribute).inserted == false {
            HGReport.shared.insertFailed(set: PrimitiveAttribute.self, object: primitiveAttribute)
            return nil
        }
        return primitiveAttribute
    }
    
    // creates PrimitiveAttribute and its inverse iterated if names already exist
    mutating func createIterated(holderName: String, primitiveName: String) -> PrimitiveAttribute? {
        
        // create iterated versions of PrimitiveAttribute names
        let name = iterated(name: primitiveName, holderName: holderName)
        
        let primitiveAttribute = PrimitiveAttribute(name: name,
                                                    holderName: holderName,
                                                    primitiveName: primitiveName,
                                                    isHash: false,
                                                    isArray: false)
        
        return create(primitiveAttribute: primitiveAttribute)
    }
    
    /// deletes All PrimitiveAttribute with HolderName
    mutating func delete(holderName: String) -> Bool {
        
        var deleted = false
        
        let holders = self.filter { $0.holderName == holderName }
        
        for holder in holders {
            if remove(holder) != nil {
                deleted = true
            }
        }
        
        if !deleted {
            HGReport.shared.deleteFailed(set: PrimitiveAttribute.self, object: holderName)
            return false
        }
        
        return true
    }
    
    /// deletes All PrimitiveAttribute with PrimitiveName
    mutating func delete(primitiveName: String) -> Bool {
        
        var deleted = false
        
        let enums = self.filter { $0.primitiveName == primitiveName }
        
        for enuM in enums {
            if remove(enuM) != nil {
                deleted = true
            }
        }
        
        if !deleted {
            HGReport.shared.deleteFailed(set: EnumAttribute.self, object: primitiveName)
            return false
        }
        
        return true
    }
    
    /// deletes EnumAttribute with name and enityName
    mutating func delete(name: String, holderName: String) -> Bool {
        
        guard let enumAttribute  = get(name: name, holderName: holderName) else {
            return false
        }
        
        if remove(enumAttribute) != nil {
            HGReport.shared.deleteFailed(set: EnumAttribute.self, object: enumAttribute)
            return false
        }
        
        return true
    }
    
    /// gets EnumAttribute
    func get(name: String, holderName: String) -> PrimitiveAttribute? {
        let holders = self.filter { $0.name == name && $0.holderName == holderName }
        if holders.count == 0 {
            HGReport.shared.getFailed(set: EnumAttribute.self, keys: ["name"], values: [name])
            return nil
        }
        return holders.first!
    }
    
    mutating func update(keyDict: PrimitiveAttributeKeyDict, name n: String, holderName hn: String) -> PrimitiveAttribute? {
        
        // get the entity that you want to update
        guard let oldPrimitiveAttribute = get(name: n, holderName: hn) else {
            return nil
        }
        
        // set key variables to nil
        var name: String?, primitiveName: String?, isHash: Bool?, isArray: Bool?
        
        // validate and assign properties
        for key in keyDict.keys {
            switch key {
            case .name: name = HGValidate.validate(value: keyDict[key]!, key: key, decoder: PrimitiveAttribute.self)
            case .primitiveName: primitiveName = HGValidate.validate(value: keyDict[key]!, key: key, decoder: PrimitiveAttribute.self)
            case .isHash: isHash = HGValidate.validate(value: keyDict[key]!, key: key, decoder: PrimitiveAttribute.self)
            case .isArray: isArray = HGValidate.validate(value: keyDict[key]!, key: key, decoder: PrimitiveAttribute.self)
            }
        }
        
        // delete old EnumAttributes
        let _ = delete(name: oldPrimitiveAttribute.name, holderName: oldPrimitiveAttribute.holderName)
        
        // make new name iterated
        if name != nil { name = iterated(name: name!, holderName: hn) }
        
        let updatedPrimitiveAttribute = oldPrimitiveAttribute.update(name: name,
                                                                     holderName: nil,
                                                                     primitiveName: primitiveName,
                                                                     isHash: isHash,
                                                                     isArray: isArray)
        
        return create(primitiveAttribute: updatedPrimitiveAttribute)
    }
    
    fileprivate func iterated(name n: String, holderName: String) -> String {
        var name = n.varRepresentable
        let filtered = self.filter { $0.holderName == holderName }
        let names = filtered.map { $0.name }
        if names.contains(name) {
            let largestNum = names.largestNum(string: name)
            name = name + "\(largestNum + 1)"
        }
        return name
    }
}

// MARK: Hashing

extension PrimitiveAttribute: Hashable { var hashValue: Int { return (name + holderName).hashValue } }
extension PrimitiveAttribute: Equatable {};
func ==(lhs: PrimitiveAttribute, rhs: PrimitiveAttribute) -> Bool { return lhs.name == rhs.name && lhs.holderName == rhs.holderName }
