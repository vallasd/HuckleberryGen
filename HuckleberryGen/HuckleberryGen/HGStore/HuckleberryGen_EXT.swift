//
//  HuckleberryGen_EXT.swift
//  HuckleberryGen
//
//  Created by David Vallas on 1/30/16.
//  Copyright © 2016 Phoenix Labs.
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
            HGReportHandler.shared.report("Enum REPLACE index: |\(i)| is out of bounds", type: .error)
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
        let boundErrors = a.filter { $0 > maxIndex || $0 < 0  }.count
        if  boundErrors > 0 {
            HGReportHandler.shared.report("Enum DELETE indexes: |\(a)| is out of bounds", type: .error)
            return false
        }
        
        project.enums.removeIndexes(a)
        return true
    }
    
    func getEnum(index i: Int) -> Enum {
        
        // check if index is in bounds
        if i < 0 || i >= project.enums.count {
            HGReportHandler.shared.report("Enum GET index: |\(i)| is out of bounds", type: .error)
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
            HGReportHandler.shared.report("Entity REPLACE index: |\(i)| is out of bounds", type: .error)
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
            HGReportHandler.shared.report("Enum DELETE indexes: |\(a)| is out of bounds", type: .error)
            return false
        }
        
        project.entities.removeIndexes(a)
        return true
        
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
    
    func createIndex() -> Index  {
        
        // create new Enum
        var index = Index.new
        
        // make iterated version of Enum if necessary
        if let itr = index.iteratedVarRep(forArray: project.indexes) { index.varRep = itr }
        
        // add Enum to store
        project.indexes.append(index)
        
        // return enum
        return index
        
    }
    
    func deleteIndexes(atIndexes a: [Int]) -> Bool {
        
        // check if index is in bounds
        let maxIndex = project.indexes.count - 1
        let boundErrors = a.filter { $0 > maxIndex || $0 < 0 }.count
        if  boundErrors > 0 {
            HGReportHandler.shared.report("Index DELETE indexes: |\(a)| is out of bounds", type: .error)
            return false
        }
        
        project.enums.removeIndexes(a)
        return true
    }
    
    func replaceIndex(atIndex i: Int, withIndex i2: Index) {
        
        // check if index is in bounds
        if i < 0 || i >= project.indexes.count {
            HGReportHandler.shared.report("Index REPLACE index: |\(i)| is out of bounds", type: .error)
            return
        }
        
        // get Entity
        let i1 = getEntity(index: i)
        
        // make iterated version of EnIndextity if necessary, |If types are not already the same|
        if i1.varRep != i2.varRep {
            if let vtr = i2.iteratedVarRep(forArray: project.indexes) {
                var i3 = i2
                i3.varRep = vtr
                project.indexes[i] = i3
                return
            }
        }
        
        // add Enum to store
        project.indexes[i] = i2
    }
    
    
    func getIndex(index i: Int) -> Index {
        
        // check if index is in bounds
        if i < 0 || i >= project.indexes.count {
            HGReportHandler.shared.report("Index GET index: |\(i)| is out of bounds", type: .error)
            assert(true)
            return Index.new
        }
        
        return project.indexes[i]
    }
    
}
