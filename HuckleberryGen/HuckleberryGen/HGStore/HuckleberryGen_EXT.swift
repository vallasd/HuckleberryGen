//
//  HuckleberryGen_EXT.swift
//  HuckleberryGen
//
//  Created by David Vallas on 1/30/16.
//  Copyright © 2016 Phoenix Labs. All rights reserved.
//

import Foundation


extension HuckleberryGen {
    
    func createEnum() -> Enum  {
        
        // create new Enum
        var enuM = Enum.new
        
        // make iterated version of Enum if necessary
        if let itr = enuM.iteratedTypeRep(forArray: project.enums) { enuM.typeRep = itr }
        
        // add Enum to store
        project.enums.append(enuM)
        
        // return enum
        return enuM
        
    }
    
    func replaceEnum(atIndex i: Int, withEnum e2: Enum) {
        
        // check if index is in bounds
        if i < 0 || i >= project.enums.count {
            HGReportHandler.shared.report("Enum REPLACE index: |\(i)| is out of bounds", type: .Error)
            return
        }
        
        // get Enum
        let e1 = getEnum(index: i)
        
        // make iterated version of Enum if necessary, |If types are not already the same|
        if e1.typeRep != e2.typeRep {
            if let itr = e2.iteratedTypeRep(forArray: project.enums) {
                var e3 = e2
                e3.typeRep = itr
                project.enums[i] = e3
                return
            }
        }
        
        // add Enum to store
        project.enums[i] = e2
    }
    
    func deleteEnums(atIndexes a: [Int]) -> Bool {
        
        // check if index is in bounds
        let maxIndex = project.enums.count - 1
        let boundErrors = a.filter { $0 > maxIndex }.count
        if  boundErrors > 0 {
            HGReportHandler.shared.report("Enum DELETE indexes: |\(a)| is out of bounds", type: .Error)
            return false
        }
        
        project.enums.removeIndexes(a)
        return true
    }
    
    func getEnum(index i: Int) -> Enum {
        
        // check if index is in bounds
        if i < 0 || i >= project.enums.count {
            HGReportHandler.shared.report("Enum GET index: |\(i)| is out of bounds", type: .Error)
            assert(true)
            return Enum.new
        }
        
        return project.enums[i]
    }
    
    func createEntity() -> Entity  {
        
        // create new Entity
        var entity = Entity.new
        
        // make iterated version of Entity if necessary
        if let itr = entity.iteratedTypeRep(forArray: project.entities) { entity.typeRep = itr }
        
        // add Entity to store
        project.entities.append(entity)
        
        // return entity
        return entity
    }
    
    func replaceEntity(atIndex i: Int, withEntity e2: Entity) {
        
        // check if index is in bounds
        if i < 0 || i >= project.entities.count {
            HGReportHandler.shared.report("Entity REPLACE index: |\(i)| is out of bounds", type: .Error)
            return
        }
        
        // get Entity
        let e1 = getEntity(index: i)
        
        // make iterated version of Entity if necessary, |If types are not already the same|
        if e1.typeRep != e2.typeRep {
            if let itr = e2.iteratedTypeRep(forArray: project.entities) {
                var e3 = e2
                e3.typeRep = itr
                project.entities[i] = e3
                return
            }
        }
        
        // add Enum to store
        project.entities[i] = e2
    }
    
    
    func deleteEntities(atIndexes a: [Int]) -> Bool {
        
        // check if index is in bounds
        let maxIndex = project.entities.count - 1
        let boundErrors = a.filter { $0 > maxIndex || $0 < 0 }.count
        if  boundErrors > 0 {
            HGReportHandler.shared.report("Enum DELETE indexes: |\(a)| is out of bounds", type: .Error)
            return false
        }
        
        project.enums.removeIndexes(a)
        return true
        
    }
    
    func getEntity(index i: Int) -> Entity {
        
        // check if index is in bounds
        if i < 0 || i >= project.entities.count {
            HGReportHandler.shared.report("Entity GET index: |\(i)| is out of bounds", type: .Error)
            if i == 0 { return createEntity() }
            assert(true)
        }
        
        return project.entities[i]
    }
    
    func getEntities(indexes a: [Int]) -> [Entity] {
        
        // check if index is in bounds
        let maxIndex = project.entities.count - 1
        let boundErrors = a.filter { $0 > maxIndex }.count
        if  boundErrors > 0 {
            HGReportHandler.shared.report("Enum GET indexes: |\(a)| is out of bounds", type: .Error)
            return []
        }
        
        var entities: [Entity] = []
        for index in a {
            entities.append(project.entities[index])
        }
        
        return entities
    }
    
}