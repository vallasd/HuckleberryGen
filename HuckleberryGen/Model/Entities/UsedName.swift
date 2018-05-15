//
//  UsedNames.swift
//  HuckleberryGen
//
//  Created by David Vallas on 4/26/18.
//  Copyright © 2018 Phoenix Labs. All rights reserved.
//

import Foundation

struct UsedName: HGCodable, Hashable, Equatable {
    
    let name: String
    
    init(name n: String) {
        name = n
    }
    
    static var initialNames: Set<UsedName> {
        var set: Set<UsedName> = Set()
        let primitives = Primitive.names
        let system = ["in", "let", "func", "class"]
        let HGGen = ["HGError", "HGReport"]
        let allNames = primitives + system + HGGen
        for name in allNames {
            let usedname = UsedName(name: name)
            set.insert(usedname)
        }
        return set
    }
    
    // MARK: - HGCodable
    
    static var encodeError: UsedName {
        return UsedName(name: "***Error***")
    }
    
    var encode: Any {
        var dict = HGDICT()
        dict["name"] = name
        return dict
    }
    
    static func decode(object: Any) -> UsedName {
        let dict = HG.decode(hgdict: object, decoder: UsedName.self)
        let n = dict["name"].string
        return UsedName(name: n)
    }
    
    // MARK: - Hashable
    
    var hashValue: Int { return name.hashValue }
}

extension Set where Element == UsedName {
    
    mutating func create(name n: String) -> UsedName? {
        let name = UsedName(name: n)
        if !insert(name).inserted {
            HGReport.shared.insertFailed(set: UsedName.self, object: name)
            return nil
        }
        return name
    }
    
    mutating func delete(name n: String) -> Bool {
        let n = UsedName(name: n)
        let o = remove(n)
        if o == nil {
            HGReport.shared.deleteFailed(set: UsedName.self, object: n)
            return false
        }
        return true
    }
}

// MARK: Equatable
func ==(lhs: UsedName, rhs: UsedName) -> Bool { return lhs.name == rhs.name }
