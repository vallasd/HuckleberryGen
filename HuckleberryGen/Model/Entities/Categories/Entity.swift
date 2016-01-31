//
//  Entity.swift
//  HuckleberryGen
//
//  Created by David Vallas on 7/24/15.
//  Copyright © 2015 Phoenix Labs. All rights reserved.
//

import Cocoa



struct Entity: TypeRepresentable {
    
    var typeRep: String
    var attributes: [Attribute]
    var relationships: [Relationship]
    
    init(typeRep: String, attributes: [Attribute], relationships: [Relationship]) {
        self.typeRep = typeRep
        self.attributes = attributes
        self.relationships = relationships
    }
    
    static func image(withName name: String) -> NSImage {
        return NSImage.image(named: "entityIcon", title: name)
    }
    
    func removeRelationships(forEntity entity: Entity) {
        //relationships = relationships.filter { $0.entity.typeRep != typeRep }
    }
}

extension Entity: HGEncodable {
    
    static var new: Entity {
        return Entity(typeRep: "NewEntity", attributes: [], relationships: [])
    }
    
    var encode: AnyObject {
        var dict = HGDICT()
        dict["typeRep"] = typeRep
        dict["attributes"] = attributes.encode
        dict["relationships"] = relationships.encode
        return dict
    }
    
    static func decode(object object: AnyObject) -> Entity {
        let dict = hgdict(fromObject: object, decoderName: "Entity")
        let typeRep = dict["typeRep"].string
        let attributes = dict["attributes"].attributes
        let relationships = dict["relationships"].relationships
        return Entity(typeRep: typeRep, attributes: attributes, relationships: relationships)
    }
}

extension Entity: VarRepresentable {
    
    var varRep: String { return typeRep.lowerFirstLetter }
    
}

extension Entity: Mutable {
    
    var mutable: Bool { return false }
}

extension Entity: Hashable { var hashValue: Int { return typeRep.hashValue } }
extension Entity: Equatable {};
func ==(lhs: Entity, rhs: Entity) -> Bool { return lhs.typeRep == rhs.typeRep }

extension Entity {
    
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




