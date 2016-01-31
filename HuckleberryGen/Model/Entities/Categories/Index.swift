//
//  Index.swift
//  HuckleberryGen
//
//  Created by David Vallas on 1/31/16.
//  Copyright © 2016 Phoenix Labs. All rights reserved.
//

import Cocoa

struct Index: VarRepresentable {
    
    var varRep: String
    var entity: Entity
    
    var byAttribute: Attribute?
    
    init(varRep: String, entity: Entity) {
        self.varRep = varRep
        self.entity = entity
    }
    
    // creates and image of var reps Entity
    var entityImage: NSImage {
        return NSImage.image(named: "entityIcon", title: entity.typeRep)
    }
}

extension Index: HGEncodable {
    
    static var new: Index {
        let entity = appDelegate.store.getEntity(index: 0)
        return Index(varRep: "newIndex", entity: entity)
    }
    
    var encode: AnyObject {
        var dict = HGDICT()
        dict["varRep"] = varRep
        dict["entity"] = entity.encode
        dict["byEntity"] = entity.encode
        return dict
    }
    
    static func decode(object object: AnyObject) -> Index {
        let dict = hgdict(fromObject: object, decoderName: "Index")
        let varRep = dict["varRep"].string
        let entity = dict["entity"].entity
        return Index(varRep: varRep, entity: entity)
    }
}

extension Index: Hashable { var hashValue: Int { return varRep.hashValue } }
extension Index: Equatable {}; func ==(lhs: Index, rhs: Index) -> Bool { return lhs.varRep == rhs.varRep }