//
//  Entity.swift
//  HuckleberryGen
//
//  Created by David Vallas on 7/24/15.
//  Copyright © 2015 Phoenix Labs.
//
//  All Rights Reserved.

import Cocoa

// MARK: Struct Definition

/// a struct that represents a model entity
struct Entity2: HGEncodable {
    
    let name: String
    let attributes: Set<Attribute>
    
    init(name n: String, attributes a: Set<Attribute>) {
        name = n
        attributes = a
    }
    
    static func image(withName name: String) -> NSImage {
        return NSImage.image(named: "entityIcon", title: name)
    }
    
    // MARK: HGEcodable
    
    static var encodeError: Entity2 {
        return Entity2(name: "Error", attributes: [])
    }
    
    var encode: Any {
        var dict = HGDICT()
        dict["name"] = name
        dict["attributes"] = attributes.encode
        return dict as AnyObject
    }
    
    static func decode(object: Any) -> Entity2 {
        let dict = HG.decode(hgdict: object, decoderName: "Entity")
        let n = dict["name"].string
        let a = dict["attributes"].attributeSet
        return Entity2(name: n, attributes: a)
    }
}

extension Set where Element == Entity2 {
    
    mutating func create(name n: String) -> String? {
        let entity = Entity2(name: n, attributes: [])
        if !insert(entity).inserted {
            HGReport.shared.insertFailed(set: Entity2.self, object: entity)
            return nil
        }
        return n
    }
    
    mutating func create(name n: String) -> String? {
        let entity = Entity2(name: n, attributes: [])
        if !insert(entity).inserted {
            HGReport.shared.insertFailed(set: Entity2.self, object: entity)
            return nil
        }
        return n
    }
    
    mutating func delete(name n: String) -> Bool {
        let entity = Entity2(name: n, attributes: [])
        let o = remove(entity)
        if o == nil {
            HGReport.shared.deleteFailed(set: Entity2.self, object: entity)
            return false
        }
        return true
    }
    
    mutating func update(name: String, oldName: String) -> String? {
        let _ = delete(name: oldName)
        return create(name: name)
    }
    
    fileprivate func iteratedName(name n: String) -> String {
        var name = n.typeRepresentable
        let names = self.map { $0.name }
        if names.contains(name) {
            let names = self.map { $0.name }
            let largestNum = names.largestNum(string: name)
            name = name + "\(largestNum + 1)"
        }
        return name
    }
}


// MARK: Hashing

extension Entity2: Hashable { var hashValue: Int { return name.hashValue } }
extension Entity2: Equatable {};
func ==(lhs: Entity2, rhs: Entity2) -> Bool { return lhs.name == rhs.name }



