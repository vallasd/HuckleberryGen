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
struct Entity {
    
    let name: String
    var attributes: [Attribute]
    let hashes: [Int]
    
    init(name n: String) {
        name = n
        attributes = []
        hashes = []
    }
    
    init(name n: String, attributes a: [Attribute], hashes h: [Int]) {
        name = n
        attributes = a
        hashes = h
    }
    
    var hashRep: String {
        
        if hashes.count == 0 {
            return "define #Hash"
        }
        
        return hashes.map { "#" + attributes[$0].name }.joined(separator: " ")
    }

    static func image(withName name: String) -> NSImage {
        return NSImage.image(named: "entityIcon", title: name)
    }
}

// MARK: Encoding

extension Entity: HGEncodable {
    
    static var encodeError: Entity {
        return Entity(name: "Error")
    }
    
    var encode: Any {
        var dict = HGDICT()
        dict["name"] = name
        dict["attributes"] = attributes.encode
        dict["hashes"] = hashes
        return dict as AnyObject
    }
    
    static func decode(object: Any) -> Entity {
        let dict = HG.decode(hgdict: object, decoderName: "Entity")
        let n = dict["name"].string
        let a = dict["attributes"].attributes
        let h = dict["hashes"].intArray
        return Entity(name: n, attributes: a, hashes: h)
    }
}

// MARK: Hashing

extension Entity: Hashable { var hashValue: Int { return name.hashValue } }
extension Entity: Equatable {};
func ==(lhs: Entity, rhs: Entity) -> Bool { return lhs.name == rhs.name }

// MARK: Storing

extension Entity {
    
    
    mutating func createAttribute() -> Attribute  {
        
        // create iterated name of Attribute
        let attributeNames = attributes.map { $0.name }
        let newName = attributeNames.varRep(string: "New Attribute")
        
        // create new Attribute
        let attribute = Attribute(name: newName)
        
        // add Attribute to self
        attributes.append(attribute)
        
        // return enum
        return attribute
    }
    
    mutating func deleteAttribute(atIndex i: Int) {
        
        // check if index is in bounds
        let maxIndex = attributes.count - 1
        if  i > maxIndex || i < 0 {
            HGReport.shared.report("Attribute DELETE index: |\(i)| for Entity |\(self)| is out of bounds", type: .error)
            return
        }
        
        // remove index
        attributes.remove(at: i)
    }
    
    
    mutating func updateAttribute(atIndex i: Int, withAttribute a: Attribute) {
        
        // check if index is in bounds
        let maxIndex = attributes.count - 1
        if  i > maxIndex || i < 0 {
            HGReport.shared.report("Attribute DELETE index: |\(i)| for Entity |\(self)| is out of bounds", type: .error)
            return
        }
        
        // update index
        attributes[i] = a
    }
}



