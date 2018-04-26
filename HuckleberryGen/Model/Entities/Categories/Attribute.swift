//
//  Attribute.swift
//  HuckleberryGen
//
//  Created by David Vallas on 7/11/15.
//  Copyright © 2015 Phoenix Labs.
//
//  All Rights Reserved.

import CoreData
import AppKit
import Cocoa

struct Attribute {
    
    var name: String
    var type: AttributeType
    
    init(name n: String) {
        name = n
        type = AttributeType.new
    }
    
    init(name n: String, type t: AttributeType) {
        name = n
        type = t
    }
    
    init(primitive p: Primitive, attribute a: Attribute) {
        name = a.name
        type = AttributeType(primitive: p)
    }
    
    init(enum e: Enum, attribute a: Attribute) {
        name = a.name
        type = AttributeType(enum: e)
    }
    
    var image: NSImage {
        return NSImage.image(named: "attributeIcon", title: name)
    }
}

extension Attribute: Hashable { var hashValue: Int { return name.hashValue } }
extension Attribute: Equatable {}; func ==(lhs: Attribute, rhs: Attribute) -> Bool { return lhs.name == rhs.name }

extension Attribute: HGEncodable {
    
    static var new: Attribute {
        let type = AttributeType.new
        return Attribute(name: "New Attribute", type: type)
    }
    
    static var encodeError: Attribute {
        let type = AttributeType.encodeError
        return Attribute(name: "Error", type: type)
    }
    
    var encode: Any {
        var dict = HGDICT()
        dict["name"] = name
        dict["type"] = type.name
        return dict
    }
    
    static func decode(object: Any) -> Attribute {
        let dict = HG.decode(hgdict: object, decoderName: "Attribute")
        let name = dict["name"].string
        let type = dict["type"].attributeType
        return Attribute(name: name, type: type)
    }
}
