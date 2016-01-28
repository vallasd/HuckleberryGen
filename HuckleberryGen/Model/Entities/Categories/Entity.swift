//
//  Entity.swift
//  HuckleberryGen
//
//  Created by David Vallas on 7/24/15.
//  Copyright © 2015 Phoenix Labs. All rights reserved.
//

import Cocoa

struct Entity {
    
    var name: String
    var attributes: [Attribute]
    var relationships: [Relationship]
    
    static func image(withName name: String) -> NSImage {
        return NSImage.image(named: "entityIcon", title: name)
    }
}

extension Entity: HGEncodable {
    
    static var new: Entity {
        return Entity(name: "New Entity", attributes: [], relationships: [])
    }
    
    var encode: AnyObject {
        var dict = HGDICT()
        dict["name"] = name
        dict["attributes"] = attributes.encode
        dict["relationships"] = relationships.encode
        return dict
    }
    
    static func decode(object object: AnyObject) -> Entity {
        let dict = hgdict(fromObject: object, decoderName: "Entity")
        let name = dict["name"].string
        let attributes = dict["attributes"].attributes
        let relationships = dict["relationships"].relationships
        return Entity(name: name, attributes: attributes, relationships: relationships)
    }
}


extension Entity: HGTypeRepresentable {
    
    func typeRep() -> String { return name.typeRepresentable }
}

extension Entity: HGVarRepresentable {
    
    func varRep() -> String { return name.lowerFirstLetter }
    func varArrayRep() -> String { return name.lowerFirstLetter.pluralized }
}


extension Entity: Hashable { var hashValue: Int { return name.hashValue } }
extension Entity: Equatable {}; func ==(lhs: Entity, rhs: Entity) -> Bool { return lhs.name == rhs.name }


