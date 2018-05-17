//
//  Enum.swift
//  HuckleberryGen
//
//  Created by David Vallas on 8/19/15.
//  Copyright © 2015 Phoenix Labs.
//
//  All Rights Reserved.


import Cocoa

enum EnumKey {
    case name
    case value1Name
    case value1String
    case value2Name
    case value2String
    case cases
}

typealias EnumKeyDict = Dictionary<EnumKey, Any>

struct Enum {
    
    let name: String
    let value1Name: String
    let value1String: Bool
    let value2Name: String
    let value2String: Bool
    fileprivate(set) var cases: Set<EnumCase>
    
    fileprivate func update(name n: String?, value1Name v1n: String?, value1String v1s: Bool?, value2Name v2n: String?, value2String v2s: Bool?, cases c: Set<EnumCase>?) -> Enum {
        let name = n == nil ? self.name : n!
        let value1Name = v1n == nil ? self.value1Name : v1n!
        let value1String = v1s == nil ? self.value1String : v1s!
        let value2Name = v2n == nil ? self.value2Name : v2n!
        let value2String = v2s == nil ? self.value2String : v2s!
        let cases = c == nil ? self.cases : c!
        return Enum(name: name,
                    value1Name: value1Name,
                    value1String: value1String,
                    value2Name: value2Name,
                    value2String: value2String,
                    cases: cases)
    }
    
    static func image(withName name: String) -> NSImage {
        return NSImage.image(named: "enumIcon", title: name)
    }
    
    mutating func createIteratedEnumCase() -> EnumCase? {
        return cases.createIterated()
    }
    
    mutating func deleteEnumCase(name n: String) -> Bool {
        return cases.delete(name: n)
    }
    
    mutating func updateEnumCase(keyDict: EnumCaseKeyDict, name n: String) -> EnumCase? {
        return cases.update(keyDict: keyDict, name: n)
    }
}

extension Enum: HGCodable {
    
    static var encodeError: Enum {
        return Enum(name: "Error",
                    value1Name: "",
                    value1String: true,
                    value2Name: "",
                    value2String: true,
                    cases: [])
    }
    
    var encode: Any {
        var dict = HGDICT()
        dict["name"] = name
        dict["value1Name"] = value1Name
        dict["value1String"] = value1String
        dict["value2Name"] = value2Name
        dict["value2String"] = value2String
        dict["cases"] = cases.encode
        return dict as AnyObject
    }
    
    static func decode(object: Any) -> Enum {
        let dict = HG.decode(hgdict: object, decoder: Enum.self)
        let name = dict["name"].string
        let value1Name = dict["value1Name"].string
        let value1String = dict["value1String"].bool
        let value2Name = dict["value2Name"].string
        let value2String = dict["value2String"].bool
        let cases = dict["cases"].enumCaseSet
        return Enum(name: name,
                    value1Name: value1Name,
                    value1String: value1String,
                    value2Name: value2Name,
                    value2String: value2String,
                    cases: cases)
    }
}

extension Set where Element == Enum {
    
    mutating func create(Enum e: Enum) -> Enum? {
        if !insert(e).inserted {
            HGReport.shared.insertFailed(set: Enum.self, object: e)
            return nil
        }
        return e
    }
    
    mutating func createIterated() -> Enum? {
        let name = map { $0.name }.iteratedTypeRepresentable(string: "New Enum")
        let e = Enum(name: name,
                     value1Name: "",
                     value1String: true,
                     value2Name: "",
                     value2String: true,
                     cases: [])
        return create(Enum: e)
    }
    
    mutating func delete(name n: String) -> Bool {
        let e = Enum(name: n,
                     value1Name: "",
                     value1String: true,
                     value2Name: "",
                     value2String: true,
                     cases: [])
        if remove(e) == nil {
            HGReport.shared.deleteFailed(set: Enum.self, object: n)
            return false
        }
        return true
    }
    
    func get(name n: String) -> Enum? {
        let enums = self.filter { $0.name == n }
        if enums.count == 0 {
            HGReport.shared.getFailed(set: Enum.self, keys: ["name"], values: [enums])
            return nil
        }
        return enums.first!
    }
    
    mutating func update(keyDict: EnumKeyDict, name n: String) -> Enum? {
        
        // get the Enum from the set
        guard let oldEnum = get(name: n) else {
            return nil
        }
        
        // set key variables to nil
        var name: String?, value1Name: String?, value1String: Bool?, value2Name: String?, value2String: Bool?, cases: Set<EnumCase>?
        
        // validate and assign properties
        for key in keyDict.keys {
            switch key {
            case .name: name = HGValidate.validate(value: keyDict[key]!, key: key, decoder: Enum.self)
            case .value1Name: value1Name = HGValidate.validate(value: keyDict[key]!, key: key, decoder: Enum.self)
            case .value1String: value1String = HGValidate.validate(value: keyDict[key]!, key: key, decoder: Enum.self)
            case .value2Name: value2Name = HGValidate.validate(value: keyDict[key]!, key: key, decoder: Enum.self)
            case .value2String: value2String = HGValidate.validate(value: keyDict[key]!, key: key, decoder: Enum.self)
            case .cases: cases = HGValidate.validate(value: keyDict[key]!, key: key, decoder: Enum.self)
            }
        }
        
        // make sure name is iterated, we are going to delete old record and add new
        if name != nil {
            name = self.map { $0.name }.iteratedTypeRepresentable(string: name!)
        }
        
        // make sure valueNames are var Representable
        value1Name = value1Name?.varRepresentable
        value2Name = value2Name?.varRepresentable
        
        // use traditional update
        let newEnum = oldEnum.update(name: name,
                                     value1Name: value1Name,
                                     value1String: value1String,
                                     value2Name: value2Name,
                                     value2String: value2String,
                                     cases: cases)
        let _ = delete(name: oldEnum.name)
        let updated = create(Enum: newEnum)
        
        return updated
    }
}

extension Enum: Hashable { var hashValue: Int { return name.hashValue } }
extension Enum: Equatable {}; func ==(lhs: Enum, rhs: Enum) -> Bool { return lhs.name == rhs.name }
