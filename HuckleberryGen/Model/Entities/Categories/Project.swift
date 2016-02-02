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
                        entity.hashes.append(newHash)
                        info.entity = entity
                        info.specialAttributes = [.IsSpecial, .TimeRange]
                        let newInfo = EntityInfo(entity: newEntity)
                        newInfos.append(newInfo)
                    case .FirstLetter:
                        let typeRep = entity.typeRep + "FirstLetterIndex"
                        let newEntity = Entity.newEntity(withTypeRep: typeRep, fromEntity: entity, relType: .TooMany)
                        let newHash = newEntity.decodeHash
                        entity.hashes.append(newHash)
                        info.entity = entity
                        info.specialAttributes = [.IsSpecial, .FirstLetter]
                        let newInfo = EntityInfo(entity: newEntity)
                        newInfos.append(newInfo)
                    case .EnumAttribute:
                        let typeRep = entity.typeRep + attribute.typeRep + "Index"
                        let newEntity = Entity.newEntity(withTypeRep: typeRep, fromEntity: entity, relType: .TooMany)
                        let newHash = newEntity.decodeHash
                        entity.hashes.append(newHash)
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
        
        // get hashed entities for object
        let hashedEntity = self.hasEntity(forHashes: e.hashes)
        
        // get singleRelationshipEnitites
        let singleRelEntities = e.singleRelationships.map { $0.entity }
        
        // combine and unique
        
        
        
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
