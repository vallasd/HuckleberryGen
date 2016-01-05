//
//  Project.swift
//  HuckleberryGen
//
//  Created by David Vallas on 11/19/15.
//  Copyright © 2015 Phoenix Labs. All rights reserved.
//

import Foundation

struct Project {
    var name: String?
    var enums: [Enum]
    var entities: [Entity]
    
    func saveKey(withUniqID uniqId: String) -> String? {
        if name == nil { return nil }
        return uniqId + "__*_|||_*__" + name!
    }
    
    static func saveKey(withUniqID uniqId: String, name: String) -> String {
        return uniqId + "__*_|||_*__" + name
    }
    
}

extension Project: HGEncodable {
    
    static var new: Project {
        return Project(name: nil, enums: [], entities: [])
    }
    
    var encode: AnyObject {
        var dict = HGDICT()
        if let n = name { dict["name"] = n }
        dict["enums"] = enums.encode
        dict["entities"] = entities.encode
        return dict
    }
    
    static func decode(object object: AnyObject) -> Project {
        let dict = hgdict(fromObject: object, decoderName: "Project")
        let name = dict["name"].optionalString
        let enums = dict["enums"].enums
        let entities = dict["entities"].entities
        let project = Project(name: name, enums: enums, entities: entities)
        return project
    }
}