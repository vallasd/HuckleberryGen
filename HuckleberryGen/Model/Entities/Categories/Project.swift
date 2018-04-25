//
//  Project.swift
//  HuckleberryGen
//
//  Created by David Vallas on 11/19/15.
//  Copyright © 2015 Phoenix Labs.
//
//  All Rights Reserved.

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
        dict["name"] = name as AnyObject?
        dict["indexes"] = indexes.encode as AnyObject
        dict["enums"] = enums.encode as AnyObject
        dict["entities"] = entities.encode as AnyObject
        return dict as AnyObject
    }
    
    static func decode(object: AnyObject) -> Project {
        let dict = hgdict(fromObject: object, decoderName: "Project")
        let name = dict["name"].string
        let indexes = dict["indexes"].indexes
        let enums = dict["enums"].enums
        let entities = dict["entities"].entities
        let project = Project(name: name, indexes: indexes, enums: enums, entities: entities)
        return project
    }
}

// MARK: Hashing


extension Project {
    
    var hashableEntities: [HashObject] {
        return entities.filter { $0.attributeHash != nil }.map { $0.decodeHash }
    }
    
    // returns a list of objects that can be selected as a hash for the specific entity
    func hashables(forEntity e: Entity) -> [HashObject] {
        let duplicateHashes = [e.decodeHash] + e.entityHashes
        let okHashes = e.attributeHash == nil ? hashableEntities + e.attributes.decodeHashes : hashableEntities
        let hashables = okHashes.filter { !duplicateHashes.contains($0) }
        return hashables
    }
}
