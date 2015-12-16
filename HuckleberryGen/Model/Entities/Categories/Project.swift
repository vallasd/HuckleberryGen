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
    
}

extension Project: HGEncodable {
    
    static var new: Project {
        let time = NSDate().mmddyymmss
        let projectName = "New Project \(time)"
        return Project(name: projectName, enums: [], entities: [])
    }
    
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