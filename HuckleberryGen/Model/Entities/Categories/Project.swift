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
    var enums: [Enum]
    fileprivate(set) var entities: Set<Entity>
    fileprivate(set) var relationships: Set<Relationship>
    fileprivate(set) var usedNames: Set<UsedName>
    
    init(name: String, enums:[Enum], entities: Set<Entity>, relationships: Set<Relationship>, usedNames: Set<UsedName>) {
        self.name = name
        self.enums = enums
        self.entities = entities
        self.relationships = relationships
        self.usedNames = usedNames
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
        return Project(name: Project.newName, enums: [], entities: [], relationships: [], usedNames: UsedName.initialNames)
    }
    
    static var encodeError: Project {
        return Project(name: Project.newName, enums: [], entities: [], relationships: [], usedNames: [])
    }
    
    var encode: Any {
        var dict = HGDICT()
        dict["name"] = name
        dict["enums"] = enums.encode
        dict["entities"] = entities.encode
        dict["relationships"] = relationships.encode
        dict["usedNames"] = usedNames.encode
        return dict as AnyObject
    }
    
    static func decode(object: Any) -> Project {
        let dict = HG.decode(hgdict: object, decoderName: "Project")
        let name = dict["name"].string
        let enums = dict["enums"].enums
        let entities = dict["entities"].entitySet
        let relationships = dict["relationships"].relationshipSet
        let usedNames = dict["usedNames"].usedNameSet
        let project = Project(name: name, enums: enums, entities: entities, relationships: relationships, usedNames: usedNames)
        return project
    }
}

// MARK: Handle

extension Project {
    
    // Entities
    
    
    // MARK: Attributes
    
//    func updateAttribute(keys: [AttributeKey], withValues vs: [Any], name n: String, entityName en: String) -> Attribute? {
//        
//        
//        
//    }
    
    
}



// MARK: Hashing


extension Project {
    
    // returns a list of objects that can be selected as a hash for the specific entity
    func hashables(forEntity e: Entity) -> [Attribute] {
        var hashables: [Attribute] = []
        let usedIndexes = e.hashes
        for index in 0..<e.attributes.count {
            if usedIndexes.contains(index) {
                let attribute = e.attributes[index]
                let type = attribute.type
                if type == .primitive || type == .enuM {
                    hashables.append(attribute)
                }
            }
        }
        return hashables
    }
}
