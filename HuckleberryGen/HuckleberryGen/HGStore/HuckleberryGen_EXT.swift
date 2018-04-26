//
//  HuckleberryGen_EXT.swift
//  HuckleberryGen
//
//  Created by David Vallas on 1/30/16.
//  Copyright © 2016 Phoenix Labs.
//
//  All Rights Reserved.

import Foundation


extension HuckleberryGen {
    
    func createEnum() -> Enum  {
        
        // create iterated name of Enum
        let name = usedNames.typeRep(string: "New Enum")
        
        // create new Enum
        let enuM = Enum(name: name)
        
        // add Enum to store
        project.enums.append(enuM)
        
        // return enum
        return enuM
    }
    
    func getEnum(index i: Int) -> Enum {
        
        // check if index is in bounds
        if i < 0 || i >= project.enums.count {
            HGReportHandler.shared.report("Enum GET index: |\(i)| is out of bounds", type: .error)
            assert(true)
            return Enum(name: "Error")
        }
        
        return project.enums[i]
    }
    
    func replaceEnum(atIndex i: Int, withEnum e: Enum) {

        // check if index is in bounds
        if i < 0 || i >= project.enums.count {
            HGReportHandler.shared.report("Enum REPLACE index: |\(i)| is out of bounds", type: .error)
            return
        }
        
        // update attributes
        
        
        // update Entities has
        
        
        // make iterated version of Enum if necessary, |If types are not already the same|

        
        // add Enum to store
        project.enums[i] = e
    }
    
    func deleteEnums(atIndexes a: [Int]) -> Bool {
        
        // check if index is in bounds
        let maxIndex = project.enums.count - 1
        let boundErrors = a.filter { $0 > maxIndex || $0 < 0  }.count
        if  boundErrors > 0 {
            HGReportHandler.shared.report("Enum DELETE indexes: |\(a)| is out of bounds", type: .error)
            return false
        }
        
        project.enums.removeIndexes(a)
        return true
    }


    func createEntity() -> Entity  {
        
        // create iterated name of Entity
        let name = usedNames.typeRep(string: "New Entity")
        
        // create new Entity
        let entity = Entity(name: name)
        
        // add Entity to store
        project.entities.append(entity)
        
        // return Entity
        return entity
    }
    
    func getEntity(index i: Int) -> Entity {
        
        // check if index is in bounds
        if i < 0 || i >= project.entities.count {
            HGReportHandler.shared.report("Entity GET index: |\(i)| is out of bounds", type: .error)
            if i == 0 { return createEntity() }
            assert(true)
        }
        
        return project.entities[i]
    }
    
    func replaceEntity(atIndex i: Int, withEntity e: Entity) {
        
        // check if index is in bounds
        if i < 0 || i >= project.entities.count {
            HGReportHandler.shared.report("Entity REPLACE index: |\(i)| is out of bounds", type: .error)
            return
        }
        
        // get Entity
        let e1 = getEntity(index: i)

        // make additional updates
        
        
        // add Enum to store
        project.entities[i] = e
    }
    
    func removeHashes(atEntityIndex i: Int) {
        let e = project.entities[i]
        let newEntity = Entity(name: e.name, attributes: e.attributes, hashes: [])
        project.entities[i] = newEntity
    }
    
    func add(hash: Attribute, atEntityIndex i: Int) {
        let e = project.entities[i]
        let index = e.attributes.index(of: hash)!
        var hashes = e.hashes
        hashes.append(index)
        let newEntity = Entity(name: e.name, attributes: e.attributes, hashes: hashes)
        project.entities[i] = newEntity
    }
    
    func updateEntity(name: String, atIndex i: Int) {
        
        // create iterated name of Entity
        let name = usedNames.typeRep(string: name)
        
        // FIXME: update relationships that have are this entity
        let e = project.entities[i]
    
        // update Entity at index
        project.entities[i] = Entity(name: name, attributes: e.attributes, hashes: e.hashes)
    }
    
    
    func deleteEntities(atIndexes a: [Int]) -> Bool {
        
        // check if index is in bounds
        let maxIndex = project.entities.count - 1
        let boundErrors = a.filter { $0 > maxIndex || $0 < 0 }.count
        if  boundErrors > 0 {
            HGReportHandler.shared.report("Enum DELETE indexes: |\(a)| is out of bounds", type: .error)
            return false
        }
        
        project.entities.removeIndexes(a)
        return true
    }

    func getEntities(indexes a: [Int]) -> [Entity] {
        
        // check if index is in bounds
        let maxIndex = project.entities.count - 1
        let boundErrors = a.filter { $0 > maxIndex || $0 < 0  }.count
        if  boundErrors > 0 {
            HGReportHandler.shared.report("Enum GET indexes: |\(a)| is out of bounds", type: .error)
            return []
        }
        
        var entities: [Entity] = []
        for index in a {
            entities.append(project.entities[index])
        }
        
        return entities
    }
    
    func createEnumCase(atEnumIndex i: Int) -> String {
        
        // create iterated name of EnumCase
        let usedNames = project.enums[i].cases
        let name = usedNames.varRep(string: "New Enum Case")
        
        // add enumCase to cases
        project.enums[i].cases.append(name)
        
        // return name
        return name
    }
    
    func updateEnumCase(name: String, atIndex i: Int, enumIndex ei: Int) -> String {
        
        // create iterated name of EnumCase
        let usedNames = project.enums[i].cases
        let name = usedNames.varRep(string: name)
        
        // update enumCase
        project.enums[ei].cases[i].append(name)
        
        // return name
        return name
    }
    
    var usedNames: [String] {
        return project.entities.map { $0.name } + project.enums.map { $0.name } + Primitive.array.map { $0.name }
    }
    
}
