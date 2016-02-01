//
//  Project.swift
//  HuckleberryGen
//
//  Created by David Vallas on 11/19/15.
//  Copyright © 2015 Phoenix Labs. All rights reserved.
//

import Foundation

// MARK: struct Definition

final class Project {
    var name: String
    var indexes: [Index]
    var enums: [Enum]
    var entities: [Entity]
    
    init(name: String, indexes: [Index], enums:[Enum], entities: [Entity]) {
        self.name = name
        self.indexes = indexes
        self.enums = enums
        self.entities = entities
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

// MARK: Encoding

extension Project: HGEncodable {
    
    static var new: Project {
        return Project(name: Project.newName, indexes: [], enums: Enum.genericEnums(), entities: [])
    }
    
    var encode: AnyObject {
        var dict = HGDICT()
        dict["name"] = name
        dict["indexes"] = indexes.encode
        dict["enums"] = enums.encode
        dict["entities"] = entities.encode
        return dict
    }
    
    static func decode(object object: AnyObject) -> Project {
        let dict = hgdict(fromObject: object, decoderName: "Project")
        let name = dict["name"].string
        let indexes = dict["indexes"].indexes
        let enums = dict["enums"].enums
        let entities = dict["entities"].entities
        let project = Project(name: name, indexes: indexes, enums: enums, entities: entities)
        return project
    }
}

// MARK : Exporting

//struct EntityInfo {
//    
//    var 
//    var pathFromArrays: Int
//    var
//    
//    
//    entity:
//    
//    
//}

extension Project {
    
    // Determine Entities Top Indexes
    
    func createEntityInfo()  {
        
//        let totalEntities = entities.count
//        
//        var circularReferences: [
//        
//        for each entity in
        
        
        
    }
    
    
    
}
