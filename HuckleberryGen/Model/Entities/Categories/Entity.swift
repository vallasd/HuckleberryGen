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
struct Entity: HashRepresentable {
    
    var typeRep: String
    var attributes: [Attribute]
    
    var attributeHash: HashObject?
    var entityHashes: [HashObject]
    
    init(typeRep t: String) {
        typeRep = t
        attributes = []
        attributeHash = nil
        entityHashes = []
    }
    
    init(typeRep t: String, attributes a: [Attribute], attributeHash at: HashObject?, entityHashes e: [HashObject]) {
        typeRep = t
        attributes = a
        attributeHash = at
        entityHashes = e
    }
    
    var hashes: [HashObject] {
        return attributeHash == nil ? entityHashes : entityHashes + [attributeHash!]
    }
    
    var hashRep: String {
        
        if hashes.count == 0 {
            return "define #Hash"
        }
        
        let aString = attributeHash == nil ? "" : "\(attributeHash!.varRep) "
        let eString = entityHashes.map { "#" + $0.varRep }.joined(separator: " ")
        return aString + eString
    }
    
    var isEntity: Bool { return true }
    
    var specialAttributeTypes: [SpecialAttribute] {
        var specialAttributes: [SpecialAttribute] = []
        for attribute in attributes {
            if let st = SpecialAttribute.specialTypeFrom(varRep: attribute.varRep) { specialAttributes.append(st) }
        }
        return specialAttributes
    }
    
    static func image(withName name: String) -> NSImage {
        return NSImage.image(named: "entityIcon", title: name)
    }
}

// MARK: Encoding

extension Entity: HGEncodable {
    
    static var new: Entity {
        return Entity(typeRep: "NewEntity", attributes: [], attributeHash: nil, entityHashes: [])
    }
    
    var encode: AnyObject {
        var dict = HGDICT()
        dict["typeRep"] = typeRep as AnyObject?
        dict["attributes"] = attributes.encode as AnyObject
        dict["hashes"] = hashes.encode as AnyObject
        return dict as AnyObject
    }
    
    static func decode(object: AnyObject) -> Entity {
        let dict = hgdict(fromObject: object, decoderName: "Entity")
        let t = dict["typeRep"].string
        let a = dict["attributes"].attributes
        let h = dict["hashes"].hashes
        let aHashes = h.filter { $0.isEntity == false }
        let attributeHash: HashObject? = aHashes.count > 0 ? aHashes[0] : nil
        let entityHashes = h.filter { $0.isEntity == true }
        return Entity(typeRep: t, attributes: a, attributeHash: attributeHash, entityHashes: entityHashes)
    }
}

extension Entity: VarRepresentable {
    
    var varRep: String { return typeRep.lowerFirstLetter }
    
}

// MARK: Hashing

extension Entity: Hashable { var hashValue: Int { return typeRep.hashValue } }
extension Entity: Equatable {};
func ==(lhs: Entity, rhs: Entity) -> Bool { return lhs.typeRep == rhs.typeRep }

// MARK: Storing

extension Entity {
    
    static func newEntity(withTypeRep t: String, fromEntity e: Entity) -> Entity {
        var newEntity = Entity.new
        newEntity.typeRep = t.typeRepresentable
        return newEntity
    }
    
    mutating func createAttribute() -> Attribute  {
        
        // create new Attribute
        var att = Attribute.new
        
        // make iterated version of Enum if necessary
        if let itr = att.iteratedVarRep(forArray: self.attributes) { att.varRep = itr }
        
        // add Enum to store
        attributes.append(att)
        
        // return enum
        return att
    }
    
    mutating func deleteAttribute(atIndex i: Int) {
        
        // check if index is in bounds
        let maxIndex = attributes.count - 1
        if  i > maxIndex || i < 0 {
            HGReportHandler.shared.report("Attribute DELETE index: |\(i)| for Entity |\(self)| is out of bounds", type: .error)
            return
        }
        
        // remove index
        attributes.remove(at: i)
    }
    
    
    mutating func updateAttribute(atIndex i: Int, withAttribute a: Attribute) {
        
        // check if index is in bounds
        let maxIndex = attributes.count - 1
        if  i > maxIndex || i < 0 {
            HGReportHandler.shared.report("Attribute DELETE index: |\(i)| for Entity |\(self)| is out of bounds", type: .error)
            return
        }
        
        // update index
        attributes[i] = a
    }
    
}

// MARK: Exporting

extension Entity {
    
    
    
}



