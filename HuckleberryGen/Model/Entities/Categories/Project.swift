//
//  Project.swift
//  HuckleberryGen
//
//  Created by David Vallas on 11/19/15.
//  Copyright © 2015 Phoenix Labs.
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

// MARK: Exporting

class ProjectMap {
    
    var entityInfos: [EntityInfo]
    
    init(entityInfos ei: [EntityInfo]) {
        entityInfos = ei
    }
    
    func printMap() {
        for info in entityInfos {
            info.printInfo()
        }
    }
}

class EntityInfo {
    
    var entity: Entity
    var specialAttributes: [SpecialAttribute]
    var isEndPoint: Bool = false
    var isCrossPoint: Bool = false
    var isSinglePoint: Bool = false
    var hashPath: String = ""

    init(entity e: Entity) {
        entity = e
        specialAttributes = e.specialAttributeTypes
    }
    
    func printInfo() {
        print("--------------\n entity: \(entity.typeRep)\n specialAttributes: \(specialAttributes)\n isEndPoint: \(isEndPoint)\n isCrossPoint: \(isCrossPoint)\n isSinglePoint: \(isSinglePoint)\n hashPath: \(hashPath)")
    }
}

extension Project {
    
    func addEntitiesFromSpecialAttributes(map: ProjectMap) {
        
        var newInfos: [EntityInfo] = []
        
        for info in map.entityInfos {
            var entity = info.entity
            for attribute in entity.attributes {
                if let specialAttribute = SpecialAttribute.specialTypeFrom(varRep: attribute.varRep) {
                    // create Entities from Select Special Type
                    switch specialAttribute {
                    case .TimeRange:
                        let typeRep = entity.typeRep + "DateIndex"
                        let newEntity = Entity.newEntity(withTypeRep: typeRep, fromEntity: entity, relType: .TooMany)
                        let newHash = newEntity.decodeHash
                        entity.entityHashes.append(newHash)
                        info.entity = entity
                        info.specialAttributes = [.IsSpecial, .TimeRange]
                        let newInfo = EntityInfo(entity: newEntity)
                        newInfos.append(newInfo)
                    case .FirstLetter:
                        let typeRep = entity.typeRep + "FirstLetterIndex"
                        let newEntity = Entity.newEntity(withTypeRep: typeRep, fromEntity: entity, relType: .TooMany)
                        let newHash = newEntity.decodeHash
                        entity.entityHashes.append(newHash)
                        info.entity = entity
                        info.specialAttributes = [.IsSpecial, .FirstLetter]
                        let newInfo = EntityInfo(entity: newEntity)
                        newInfos.append(newInfo)
                    case .EnumAttribute:
                        let typeRep = entity.typeRep + attribute.varRep.capitalizedString + "Index"
                        let newEntity = Entity.newEntity(withTypeRep: typeRep, fromEntity: entity, relType: .TooMany)
                        let newHash = newEntity.decodeHash
                        entity.entityHashes.append(newHash)
                        info.entity = entity
                        info.specialAttributes = [.IsSpecial, .EnumAttribute]
                        let newInfo = EntityInfo(entity: newEntity)
                        newInfos.append(newInfo)
                    default: break
                    }
                }
            }
        }
        
        map.entityInfos.appendContentsOf(newInfos)
    }
    
    // returns the hashed entity if it exists
    func hasEntity(forHashes hashes: [HashObject]) -> Entity?  {
        
        for entity in entities {
            for hash in hashes {
                if entity.varRep == hash.varRep { return entity }
            }
        }
        
        return nil
    }
    
    // Determine Entities Top Indexes
    func createEntityInfo()  {
        
        let infos = entities.map { EntityInfo(entity: $0) }
        let pMap = ProjectMap(entityInfos: infos)
        
        addEntitiesFromSpecialAttributes(pMap)
        updateInfo(pMap)
        
        
        pMap.printMap()
    }
    
    func updateInfo(pMap: ProjectMap) {
        
        for info in pMap.entityInfos {
            info.hashPath = goDownHashPath(forEntity: info.entity, count: 0, pathString: "")
            info.isEndPoint = info.entity.isEndPoint
            info.isCrossPoint = info.entity.isCrossPoint
            info.isSinglePoint = info.entity.isSinglePoint
        }
    }
    
    func goDownHashPath(forEntity e: Entity, count: Int, pathString: String) -> String {
        
        // bail out if we are too deep, we are most likely in a recursive loop
        if count > ( entities.count * 2 ) {
            return "recursiveLoop"
        }
        
        // add self to string
        var newPathString = pathString + e.typeRep
        
        // 
        if let entity = self.hasEntity(forHashes: e.hashes) {
            newPathString += "->"
            newPathString = goDownHashPath(forEntity: entity, count: count+1, pathString: newPathString)
        }
        
        return newPathString
    }
    
//    func specialAttributes(forEntityInfos infos: [EntityInfo]) -> EntityInfo {
//
//        
//        
//    }
    
    
}
