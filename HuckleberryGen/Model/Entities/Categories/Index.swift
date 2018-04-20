//
//  Index.swift
//  HuckleberryGen
//
//  Created by David Vallas on 1/31/16.
//  Copyright © 2016 Phoenix Labs.
//
//  This file is part of HuckleberryGen.
//
//  HuckleberryGen is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  HuckleberryGen is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with HuckleberryGen.  If not, see <http://www.gnu.org/licenses/>.

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
        dict["varRep"] = varRep as AnyObject?
        dict["entity"] = entity.encode
        dict["byEntity"] = entity.encode
        return dict as AnyObject
    }
    
    static func decode(object: AnyObject) -> Index {
        let dict = hgdict(fromObject: object, decoderName: "Index")
        let varRep = dict["varRep"].string
        let entity = dict["entity"].entity
        return Index(varRep: varRep, entity: entity)
    }
}

extension Index: Hashable { var hashValue: Int { return varRep.hashValue } }
extension Index: Equatable {}; func ==(lhs: Index, rhs: Index) -> Bool { return lhs.varRep == rhs.varRep }
