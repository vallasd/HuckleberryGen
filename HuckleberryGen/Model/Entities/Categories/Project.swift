//
//  Project.swift
//  HuckleberryGen
//
//  Created by David Vallas on 11/19/15.
//  Copyright © 2015 Phoenix Labs. All rights reserved.
//

import Foundation

final class Project {
    var name: String
    var types: [HGType]
    var enums: [Enum]
    var entities: [Entity]
    
    init(name: String, types: [HGType], enums:[Enum], entities: [Entity]) {
        self.name = name
        self.enums = enums
        self.entities = entities
        self.types = types
    }
    
    static var newName = "New Project"
    
    var isNew: Bool { return name == Project.newName ? true : false }
    
    func saveKey(withUniqID uniqId: String) -> String {
        return uniqId + "__*_|||_*__" + name
    }
    
    static func saveKey(withUniqID uniqId: String, name: String) -> String {
        return uniqId + "__*_|||_*__" + name
    }
}

extension Project: HGEncodable {
    
    static var new: Project {
        return Project(name: Project.newName, types: HGType.genericTypes(), enums: Enum.genericEnums(), entities: [])
    }
    
    var encode: AnyObject {
        var dict = HGDICT()
        dict["name"] = name
        dict["enums"] = enums.encode
        dict["entities"] = entities.encode
        dict["types"] = types.encode
        return dict
    }
    
    static func decode(object object: AnyObject) -> Project {
        let dict = hgdict(fromObject: object, decoderName: "Project")
        let name = dict["name"].string
        let enums = dict["enums"].enums
        let entities = dict["entities"].entities
        let types = dict["types"].hgtypes
        let project = Project(name: name, types: types, enums: enums, entities: entities)
        return project
    }
}