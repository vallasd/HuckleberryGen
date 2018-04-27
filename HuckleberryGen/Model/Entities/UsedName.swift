//
//  UsedNames.swift
//  HuckleberryGen
//
//  Created by David Vallas on 4/26/18.
//  Copyright © 2018 Phoenix Labs. All rights reserved.
//

import Foundation

struct UsedName: HGEncodable, Hashable, Equatable {
    
    let name: String
    
    init(name n: String) {
        name = n
    }
    
    static var initialNames: Set<UsedName> {
        var set: Set<UsedName> = Set()
        let primitives = ["Int", "Int16", "Int32", "Double", "Float", "String", "Bool", "Date", "Date", "String"]
        let HGGen = ["HGError"]
        let allNames = primitives + HGGen
        for name in allNames {
            let usedname = UsedName(name: name)
            set.insert(usedname)
        }
        return set
    }
    
    // MARK: - HGEncodable
    
    static var encodeError: UsedName {
        return UsedName(name: "***Error***")
    }
    
    var encode: Any {
        return name
    }
    
    static func decode(object: Any) -> UsedName {
        guard let name = object as? String else {
            HGReport.shared.decode(object, type: UsedName.self)
            return encodeError
        }
        return UsedName(name: name)
    }
    
    // MARK: - Hashable
    
    var hashValue: Int { return name.hashValue }
}

extension Set where Element == UsedName {
    
    /// inserts name into used names, if name is not typeRepresentable or is already in usedNames, updates text and iterates.  Returns correct iterated value that was inserted into the set.
    mutating func insert(name n: String) -> String {
        var name = n.typeRepresentable
        let t = UsedName(name: name)
        if self.contains(t) {
            let names = self.map { $0.name }
            let largestNum = names.largestNum(string: name)
            name = name + "\(largestNum + 1)"
        }
        let usedname = UsedName(name: name)
        self.insert(usedname)
        return n
    }
}

// MARK: Equatable
func ==(lhs: UsedName, rhs: UsedName) -> Bool { return lhs.name == rhs.name }
