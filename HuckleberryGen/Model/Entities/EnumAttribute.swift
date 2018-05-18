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
    case isArray
}

typealias EnumAttributeKeyDict = Dictionary<EnumAttributeKey, Any>

struct EnumAttribute: HGCodable {
    
    let name: String
    let holderName: String
    let enumName: String
    let isHash: Bool
    let isArray: Bool
    
    fileprivate func update(name n: String?, holderName hn: String?, enumName en: String?, isHash i: Bool?, isArray ia: Bool?) -> EnumAttribute {
        let name = n == nil ? self.name : n!
        let holderName = hn == nil ? self.holderName : hn!
        let enumName = en == nil ? self.enumName : en!
        let isHash = i == nil ? self.isHash : i!
        let isArray = ia == nil ? self.isArray : ia!
        return EnumAttribute(name: name,
                             holderName: holderName,
                             enumName: enumName,
                             isHash: isHash,
                             isArray: isArray)
    }
    
    // MARK: - HGCodable
    
    static var encodeError: EnumAttribute {
        let e = "Error"
        return EnumAttribute(name: e, holderName: e, enumName: e, isHash: false, isArray: false)
    }
    
    var encode: Any {
        var dict = HGDICT()
        dict["name"] = name
        dict["holderName"] = holderName
        dict["enumName"] = enumName
        dict["isHash"] = isHash
        dict["isArray"] = isArray
        return dict
    }
    
    static func decode(object: Any) -> EnumAttribute {
        let dict = HG.decode(hgdict: object, decoder: EnumAttribute.self)
        let name = dict["name"].string
        let holderName = dict["holderName"].string
        let enumName = dict["enumName"].string
        let isHash = dict["isHash"].bool
        let isArray = dict["isArray"].bool
        return EnumAttribute(name: name, holderName: holderName, enumName: enumName, isHash: isHash, isArray: isArray)
    }
}

extension Set where Element == EnumAttribute {
    
    mutating func create(enumAttribute r: EnumAttribute) -> EnumAttribute? {
        if insert(r).inserted == false {
            HGReport.shared.insertFailed(set: EnumAttribute.self, object: r)
            return nil
        }
        return r
    }
    
    // creates EnumAttribute and its inverse iterated if names already exist
    mutating func createIterated(holderName: String, enumName: String) -> EnumAttribute? {
        
        // create iterated versions of EnumAttributes names
        let name = iterated(name: enumName, holderName: holderName)
        
        let entityAttribute = EnumAttribute(name: name,
                                            holderName: holderName,
                                            enumName: enumName,
                                            isHash: false,
                                            isArray: false)
        
        return create(enumAttribute: entityAttribute)
    }
    
    /// deletes All EnumAttribute with EntityName
    mutating func delete(holderName: String) -> Bool {
        
        var deleted = false
        
        let holders = self.filter { $0.holderName == holderName }
        
        for holder in holders {
            if remove(holder) != nil {
                deleted = true
            }
        }
        
        if !deleted {
            HGReport.shared.deleteFailed(set: EnumAttribute.self, object: holderName)
            return false
        }
        
        return true
    }
    
    /// deletes All EnumAttribute with EnumName
    mutating func delete(enumName: String) -> Bool {
        
        var deleted = false
        
        let enums = self.filter { $0.enumName == enumName }
        
        for enuM in enums {
            if remove(enuM) != nil {
                deleted = true
            }
        }
        
        if !deleted {
            HGReport.shared.deleteFailed(set: EnumAttribute.self, object: enumName)
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
    func get(name: String, holderName: String) -> EnumAttribute? {
        let holders = self.filter { $0.name == name && $0.holderName == holderName }
        if holders.count == 0 {
            HGReport.shared.getFailed(set: EnumAttribute.self, keys: ["name"], values: [name])
            return nil
        }
        return holders.first!
    }
    
    mutating func update(keyDict: EnumAttributeKeyDict, name n: String, holderName hn: String) -> EnumAttribute? {
        
        // get the entity that you want to update
        guard let oldEnumAttribute = get(name: n, holderName: hn) else {
            return nil
        }
        
        // set key variables to nil
        var name: String?, enumName: String?, isHash: Bool?, isArray: Bool?
        
        // validate and assign properties
        for key in keyDict.keys {
            switch key {
            case .name: name = HGValidate.validate(value: keyDict[key]!, key: key, decoder: EnumAttribute.self)
            case .enumName: enumName = HGValidate.validate(value: keyDict[key]!, key: key, decoder: EnumAttribute.self)
            case .isHash: isHash = HGValidate.validate(value: keyDict[key]!, key: key, decoder: EnumAttribute.self)
            case .isArray: isArray = HGValidate.validate(value: keyDict[key]!, key: key, decoder: EnumAttribute.self)
            }
        }
        
        // delete old EnumAttributes
        let _ = delete(name: oldEnumAttribute.name, holderName: oldEnumAttribute.holderName)
        
        // make new name iterated
        if name != nil { name = iterated(name: name!, holderName: hn) }
        
        let updatedEnumAttribute = oldEnumAttribute.update(name: name,
                                                           holderName: nil,
                                                           enumName: enumName,
                                                           isHash: isHash,
                                                           isArray: isArray)
        
        return create(enumAttribute: updatedEnumAttribute)
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

extension EnumAttribute: Hashable { var hashValue: Int { return (name + holderName).hashValue } }
extension EnumAttribute: Equatable {};
func ==(lhs: EnumAttribute, rhs: EnumAttribute) -> Bool { return lhs.name == rhs.name && lhs.holderName == rhs.holderName }
