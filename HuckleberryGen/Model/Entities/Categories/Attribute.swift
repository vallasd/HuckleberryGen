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

struct Attribute: HashRepresentable {
    
    var varRep: String
    let typeRep: String
    let decodeRep: String
    let isPrimitive: Bool
    var optional: Bool
    
    var isEntity: Bool { return false }
    
    init(varRep v: String, primitive p: Primitive) {
        varRep = v
        typeRep = p.typeRep
        decodeRep = p.varRep
        isPrimitive = true
        optional = false
    }
    
    init(primitive p: Primitive, oldAttribute o: Attribute) {
        varRep = o.varRep
        typeRep = p.typeRep
        decodeRep = p.varRep
        isPrimitive = true
        optional = o.optional
    }
    
    init(enuM e: Enum, oldAttribute o: Attribute) {
        varRep = o.varRep
        typeRep = e.typeRep
        decodeRep = e.varRep
        isPrimitive = false
        optional = o.optional
    }
    
    init(typeRep t: String, varRep v: String, decodeRep d: String, isPrimitive ip: Bool, optional o: Bool) {
        typeRep = t
        varRep = v
        decodeRep = d
        isPrimitive = ip
        optional = o
    }
    
    var image: NSImage {
        return NSImage.image(named: "attributeIcon", title: varRep)
    }
    
    var typeImage: NSImage {
        if isPrimitive {
            let prim = Primitive.create(string: typeRep)
            return prim.image
        }
        return NSImage.image(named: "enumIcon", title: typeRep)
    }
}

extension Attribute: Hashable { var hashValue: Int { return varRep.hashValue } }
extension Attribute: Equatable {}; func ==(lhs: Attribute, rhs: Attribute) -> Bool { return lhs.varRep == rhs.varRep }

extension Attribute: HGEncodable {
    
    static var new: Attribute {
        return Attribute(varRep: "newAttribute", primitive: ._int)
    }
    
    var encode: AnyObject {
        var dict = HGDICT()
        dict["typeRep"] = typeRep as AnyObject?
        dict["varRep"] = varRep as AnyObject?
        dict["decodeRep"] = decodeRep as AnyObject?
        dict["isPrimitive"] = isPrimitive as AnyObject?
        dict["optional"] = optional as AnyObject?
        return dict as AnyObject
    }
    
    static func decode(object: AnyObject) -> Attribute {
        let dict = hgdict(fromObject: object, decoderName: "Attribute")
        let typeRep = dict["typeRep"].string
        let varRep = dict["varRep"].string
        let decodeRep = dict["decodeRep"].string
        let isPrimitive = dict["isPrimitive"].bool
        let optional = dict["optional"].bool
        return Attribute(typeRep: typeRep, varRep: varRep, decodeRep: decodeRep, isPrimitive: isPrimitive, optional: optional)
    }
}
