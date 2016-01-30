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
    
    static func image(withName name: String) -> NSImage {
        return NSImage.image(named: "entityIcon", title: name)
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
func ==(lhs: Entity, rhs: String) -> Bool { return lhs.typeRep == rhs.typeRepresentable }


