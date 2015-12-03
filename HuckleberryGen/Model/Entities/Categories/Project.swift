//
//  Project.swift
//  HuckleberryGen
//
//  Created by David Vallas on 11/19/15.
//  Copyright © 2015 Phoenix Labs. All rights reserved.
//

import Foundation

import Foundation

struct Project {
    var name: String
    var enums: [Enum]
    var entities: [Entity]
    
    static var new: Project {
        return Project(name: "New Project", enums: [], entities: [])
    }
}

extension Project: HGEncodable {
    
    var encode: AnyObject {
        var dict = HGDICT()
        dict["name"] = name
        dict["enums"] = enums.encode
        dict["entities"] = entities.encode
        return dict
    }
    
    static func decode(object object: AnyObject) -> Project {
        let dict = hgdict(fromObject: object, decoderName: "Project")
        let name = dict["name"].string
        let enums = dict["enums"].enums
        let entities = dict["entities"].entities
        let project = Project(name: name, enums: enums, entities: entities)
        return project
    }
}