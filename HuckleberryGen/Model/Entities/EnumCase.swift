//
//  EnumCase.swift
//  HuckleberryGen
//
//  Created by David Vallas on 4/28/18.
//  Copyright © 2018 Phoenix Labs. All rights reserved.
//

import Foundation

enum EnumCaseKey {
    case name
    case value1
    case value2
}

typealias EnumCaseKeyDict = Dictionary<EnumCaseKey, Any>

struct EnumCase: HGCodable {
    let name: String
    let value1: String
    let value2: String
    
    fileprivate func update(name n: String?, value1 v1: String?, value2 v2: String?) -> EnumCase {
        let name = n == nil ? self.name : n!
        let value1 = v1 == nil ? self.value1 : v1!
        let value2 = v2 == nil ? self.value2 : v2!
        return EnumCase(name: name, value1: value1, value2: value2)
    }
    
    // HGCodable
    
    static var encodeError: EnumCase {
        return EnumCase(name: "Error", value1: "", value2: "")
    }
    
    var encode: Any {
        var dict = HGDICT()
        dict["name"] = name
        dict["value1"] = value1
        dict["value2"] = value2
        return dict
    }
    
    static func decode(object: Any) -> EnumCase {
        let dict = HG.decode(hgdict: object, decoder: EnumCase.self)
        let name = dict["name"].string
        let value1 = dict["value1"].string
        let value2 = dict["value2"].string
        return EnumCase(name: name, value1: value1, value2: value2)
    }
}

extension Set where Element == EnumCase {
    
    mutating func create(EnumCase e: EnumCase) -> EnumCase? {
        if !insert(e).inserted {
            HGReport.shared.insertFailed(set: EnumCase.self, object: e)
            return nil
        }
        return e
    }
    
    mutating func createIterated() -> EnumCase? {
        let name = map { $0.name }.iteratedVarRepresentable(string: "New Enum Case")
        let e = EnumCase(name: name, value1: "", value2: "")
        return create(EnumCase: e)
    }
    
    mutating func delete(name n: String) -> Bool {
        let enumCase = EnumCase(name: n, value1: "", value2: "")
        let o = remove(enumCase)
        if o == nil {
            HGReport.shared.deleteFailed(set: EnumCase.self, object: enumCase)
            return false
        }
        return true
    }
    
    func get(name n: String) -> EnumCase? {
        let enumCases = self.filter { $0.name == n }
        if enumCases.count == 0 {
            HGReport.shared.getFailed(set: EnumCase.self, keys: ["name"], values: [n])
            return nil
        }
        return enumCases.first!
    }
    
    mutating func update(keyDict: EnumCaseKeyDict, name n: String) -> EnumCase? {
        
        // get the EnumCase from the set
        guard let oldEnumCase = get(name: n) else {
            return nil
        }
        
        // set key variables to nil
        var name: String?, value1: String?, value2: String?
        
        // validate and assign properties
        for key in keyDict.keys {
            switch key {
            case .name: name = HGValidate.validate(value: keyDict[key]!, key: key, decoder: EnumCase.self)
            case .value1: value1 = HGValidate.validate(value: keyDict[key]!, key: key, decoder: EnumCase.self)
            case .value2: value2 = HGValidate.validate(value: keyDict[key]!, key: key, decoder: EnumCase.self)
            }
        }
        
        // make sure name is iterated, we are going to delete old record and add new
        if name != nil { name = self.map { $0.name }.iteratedVarRepresentable(string: name!) }
        
        // use traditional update
        let newEnumCase = oldEnumCase.update(name: name,
                                             value1: value1,
                                             value2: value2)
        let _ = delete(name: oldEnumCase.name)
        let updated = create(EnumCase: newEnumCase)
        
        return updated
    }
}

extension EnumCase: Hashable { var hashValue: Int { return name.hashValue } }
extension EnumCase: Equatable {};
func ==(lhs: EnumCase, rhs: EnumCase) -> Bool { return lhs.name == rhs.name }
