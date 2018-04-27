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
    mutating func createIterated(name n: String) -> String {
        var name = n.typeRepresentable
        let t = UsedName(name: name)
        if self.contains(t) {
            let names = self.map { $0.name }
            let largestNum = names.largestNum(string: name)
            name = name + "\(largestNum + 1)"
        }
        let newname = UsedName(name: name)
        if !insert(newname).inserted {
            // we should never see this error
            HGReport.shared.insertFailed(set: UsedName.self, object: newname)
        }
        return n
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
    
    mutating func update(name: String, oldName: String) -> String {
        let _ = delete(name: oldName)
        return createIterated(name: name)
    }
}

// MARK: Equatable
func ==(lhs: UsedName, rhs: UsedName) -> Bool { return lhs.name == rhs.name }
