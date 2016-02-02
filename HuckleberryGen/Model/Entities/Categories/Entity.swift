//
//  Entity.swift
//  HuckleberryGen
//
//  Created by David Vallas on 7/24/15.
//  Copyright © 2015 Phoenix Labs. All rights reserved.
//

import Cocoa

// MARK: Struct Definition

/// a struct that represents a model entity
struct Entity: HashRepresentable {
    
    var typeRep: String
    var attributes: [Attribute]
    var relationships: [Relationship]
    
    var hashes: [HashObject]
    
    var hashRep: String {
        
        if hashes.count == 0 {
            return "define #Hash"
        }
        
        return hashes.map { $0.varRep }.joinWithSeparator(", ")
    }
    
    var specialAttributeTypes: [SpecialAttribute] {
        var specialAttributes: [SpecialAttribute] = []
        for attribute in attributes {
            if let st = SpecialAttribute.specialTypeFrom(varRep: attribute.varRep) { specialAttributes.append(st) }
        }
        return specialAttributes
    }
    
    var isEndPoint: Bool {
        return relationships.count == 1 ? true : false
    }
    
    var isSinglePoint: Bool {
        return relationships.count == 0 ? true : false
    }
    
    var isCrossPoint: Bool {
        return relationships.count > 1 ? true : false
    }

    var manyRelationships: [Relationship] {
        let tooMany = RelationshipType.TooMany
        return relationships.filter { $0.relType == tooMany }
    }
    
    var singleRelationships: [Relationship] {
        let tooOne = RelationshipType.TooOne
        return relationships.filter { $0.relType == tooOne }
    }
    
    init(typeRep: String, attributes: [Attribute], relationships: [Relationship], hashes: [HashObject]) {
        self.typeRep = typeRep
        self.attributes = attributes
        self.relationships = relationships
        self.hashes = hashes
    }
    
    static func image(withName name: String) -> NSImage {
        return NSImage.image(named: "entityIcon", title: name)
    }
}

// MARK: Encoding

extension Entity: HGEncodable {
    
    static var new: Entity {
        return Entity(typeRep: "NewEntity", attributes: [], relationships: [], hashes: [])
    }
    
    var encode: AnyObject {
        var dict = HGDICT()
        dict["typeRep"] = typeRep
        dict["attributes"] = attributes.encode
        dict["relationships"] = relationships.encode
        dict["hashes"] = hashes.encode
        return dict
    }
    
    static func decode(object object: AnyObject) -> Entity {
        let dict = hgdict(fromObject: object, decoderName: "Entity")
        let typeRep = dict["typeRep"].string
        let attributes = dict["attributes"].attributes
        let relationships = dict["relationships"].relationships
        let hashes = dict["hashes"].hashes
        return Entity(typeRep: typeRep, attributes: attributes, relationships: relationships, hashes: hashes)
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
    
    static func newEntity(withTypeRep t: String, fromEntity e: Entity, relType r: RelationshipType) -> Entity {
        var newEntity = Entity.new
        newEntity.typeRep = t.typeRepresentable
        
        var relationship = Relationship.new
        relationship.entity = e
        relationship.relType = r
        
        newEntity.relationships.append(relationship)
        return newEntity
    }
    
    mutating func createRelationship() -> Relationship  {
        
        // create new relationship
        var relationship = Relationship.new
        
        // assign self to relationship
        relationship.entity = self
        
        // make iterated version of Enum if necessary
        //if let itr = relationship.iteratedTypeRep(forArray: relationships) { relationship.typeRep = itr }
        
        // add relationship to relationships
        relationships.append(relationship)
        
        return relationship
    }
    
    mutating func deleteRelationship(forEntity e: Entity) {
        
        relationships = relationships.filter { $0.entity != e }
    }
    
    mutating func deleteRelationship(atIndex i: Int) {
        
        // check if index is in bounds
        let maxIndex = relationships.count - 1
        if  i > maxIndex || i < 0 {
            HGReportHandler.shared.report("Attribute DELETE index: |\(i)| for Entity |\(self)| is out of bounds", type: .Error)
            return
        }
        
        // remove index
        relationships.removeAtIndex(i)
    }
    
    mutating func updateRelationship(withRelationship r: Relationship) {
        
        deleteRelationship(forEntity: self)
        
        relationships.append(r)
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
            HGReportHandler.shared.report("Attribute DELETE index: |\(i)| for Entity |\(self)| is out of bounds", type: .Error)
            return
        }
        
        // remove index
        attributes.removeAtIndex(i)
    }
    
    
    mutating func updateAttribute(atIndex i: Int, withAttribute a: Attribute) {
        
        // check if index is in bounds
        let maxIndex = attributes.count - 1
        if  i > maxIndex || i < 0 {
            HGReportHandler.shared.report("Attribute DELETE index: |\(i)| for Entity |\(self)| is out of bounds", type: .Error)
            return
        }
        
        // update index
        attributes[i] = a
    }
    
}

// MARK: Exporting

extension Entity {
    
    
    
}



