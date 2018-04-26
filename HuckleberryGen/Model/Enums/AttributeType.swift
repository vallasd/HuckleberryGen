//
//  AttributeType.swift
//  HuckleberryGen
//
//  Created by David Vallas on 4/25/18.
//  Copyright © 2018 Phoenix Labs. All rights reserved.
//

import Cocoa

struct AttributeType: HGEncodable  {
    
    let name: String
    let type: HGType
    
    init(name n: String, type t: HGType) {
        name = n
        type = t
    }
    
    init(primitive: Primitive) {
        name = primitive.name
        type = .primitive
    }
    
    init(enun e: Enum) {
        name = e.name
        type = .enuM
    }
    
    init(entity: Entity) {
        name = entity.name
        type = .entity
    }
    
    var image: NSImage {
        switch type {
        case .primitive: return NSImage.image(named: "typeIcon", title: name)
        case .enuM: return NSImage.image(named: "enumIcon", title: name)
        case .entity: return NSImage.image(named: "entityIcon", title: name)
        }
    }
    
    // MARK: - HGEncodable
    
    static var new: AttributeType {
        return AttributeType(name: Primitive._int.name, type: .primitive)
    }
    
    static var encodeError: AttributeType {
        return AttributeType(name: "Error", type: .enuM)
    }
    
    var encode: Any {
        var dict = HGDICT()
        dict["name"] = name
        dict["type"] = type.encode
        return dict
    }
    
    static func decode(object: Any) -> AttributeType {
        let dict = HG.decode(hgdict: object, decoderName: "Attribute")
        let name = dict["name"].string
        let type = dict["type"].hGtype
        return Attribute(name: name, type: type)
    }
}
