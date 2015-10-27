//
//  HGModel.swift
//  HuckleberryGen
//
//  Created by David Vallas on 8/27/15.
//  Copyright © 2015 Phoenix Labs. All rights reserved.
//

import Foundation

struct HGModel {
    var name: String
    var enums: [Enum]
    var entities: [Entity]
    
    static var new: HGModel {
        return HGModel(name: "New Model", enums: [], entities: [])
    }
}

extension HGModel: HGEncodable {
    
    var encode: AnyObject {
        var dict = HGDICT()
        dict["name"] = name
        dict["enums"] = enums.encode
        dict["entities"] = entities.encode
        return dict
    }
    
    static func decode(object object: AnyObject) -> HGModel {
        let dict = hgdict(fromObject: object, decoderName: "HGModel")
        let name = dict["name"].string
        let enums = dict["enums"].enums
        let entities = dict["entities"].entities
        let hgmodel = HGModel(name: name, enums: enums, entities: entities)
        return hgmodel
    }
}