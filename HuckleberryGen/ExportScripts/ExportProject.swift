//
//  ExportProject.swift
//  HuckleberryGen
//
//  Created by David Vallas on 1/19/16.
//  Copyright © 2016 Phoenix Labs. All rights reserved.
//

import Cocoa

class ExportProject {
    
    let store: HuckleberryGen
    
    init(store: HuckleberryGen) {
        self.store = store
    }
    
    func export() {
        
        createDirectories()
        createEntities()
    }
    
    func createHeader(forName name: String) -> String {
        return store.licenseInfo.string(store.project.name, fileName: name)
    }
    
    
    func createEntities() {
        
        let basePath = store.exportPath
        let baseDirectory = basePath + "/\(store.project.name)"
        let folder = baseDirectory + "/Entities"
        
        for entity in store.project.entities {
            
            // create entity's full File Path
            let entityPath = folder + "/\(entity.name).swift"
            
            // create string components for file
            let head = createHeader(forName: entity.name)
            let st = entityStructString(entity)
            let hg = hgEncodableEntityString(entity)
            
            // concatenate file components
            let file = head + st + hg
            
            // write to file
            do {
                try file.writeToFile(entityPath, atomically: true, encoding: NSUTF8StringEncoding)
            } catch {
                // do nothing
            }
        }
        
    }
    
    
    /// creates a string that will print out to be a struct of an Entity
    func entityStructString(entity: Entity) -> String {
        
        var string: String = "\n"
        
        // add struct
        string += "struct \(entity.name) {\n"
        string += "\n"
        
        // add attributes
        for attribute in entity.attributes {
            string += "   let \(attribute.name): \(attribute.type)\n"
        }
        
        string += "\n"
        
        // add relationships
        for relationship in entity.relationships {
            if relationship.type == .TooMany {
                string += "   var \(relationship.name): [\(relationship.entity)]\n"
            } else {
                string += "   var \(relationship.name): \(relationship.entity)?\n"
            }
        }
        
        // end struct
        string += "\n}\n"
        
        return string
    }
    
    /// creates a string that will print out to be a HGEncodable definition for an Entity
    func hgEncodableEntityString(entity: Entity) -> String {
        
        //
        var string = "\n"
        
        // create HGEncodable extension
        string += "extensions \(entity.name): HGEncodable {\n"
        string += "\n"
        
        // create new var
        string += " static var new: \(entity.name) {\n"
        string += "     return \(entity.name)("
        
        // new attributes
        for attribute in entity.attributes {
            string += "\(attribute.name): \(attribute.type).new, "
        }
        
        // new relationships
        for relationship in entity.relationships {
            if relationship.type == .TooMany {
                string += "\(relationship.name): [], "
            } else {
                string += "\(relationship.name): nil, "
            }
        }
        
        // remove last , from new var
        string = String(string.characters.dropLast())
        string = String(string.characters.dropLast())
        
        // end new var
        string += ")\n"
        string += " }\n\n"
        
        // create encode var
        string += " var encode: AnyObject {\n"
        string += "     var dict = HGDict()\n"
        
        // encode attributes
        for attribute in entity.attributes {
            if attribute.isPrimitive {
                string += "     dict[\"\(attribute.name)\"] = \(attribute.name)\n"
            } else {
                string += "     dict[\"\(attribute.name)\"] = \(attribute.name).encode\n"
            }
        }
        
        // encode relationships
        for relationship in entity.relationships {
            string += "     dict[\"\(relationship.name)\"] = \(relationship.name).encode\n"
        }
        
        // end encode var
        string += "     return dict\n"
        string += " }\n\n"
        
        
        // create decode func
        string += " var encode: AnyObject {\n"
        string += "     var dict = HGDict()\n"
        
        
        return string
    }
    
    func relationshipName(forEntity entity: Entity) -> String {
        let name = entity.name
        if name.isEmpty { return name }
        return ""
    }
    
    func relationshipArrayName(forEntity entity: Entity) -> String {
        return ""
    }
    
    func createDirectories() {
        
        let basePath = store.exportPath
        let baseDirectory = basePath + "/\(store.project.name)"
        let entities = baseDirectory + "/Entities"
        let enums = baseDirectory + "/Enums"
        let errors = baseDirectory + "/Errors"
        let extensions = baseDirectory + "/Extensions"
        let options = baseDirectory + "/Options"
        let protocols = baseDirectory + "/Protocols"
        
        let paths = [baseDirectory, entities, enums, errors, extensions, options, protocols]
        
        for path in paths {
            do {
                try NSFileManager.defaultManager().createDirectoryAtPath(path, withIntermediateDirectories: false, attributes: nil)
            } catch {
                // do nothing, We are going to override
            }
        }
    }
    
    
}