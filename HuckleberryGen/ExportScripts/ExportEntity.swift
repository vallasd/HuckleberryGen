//
//  ExportEntity.swift
//  HuckleberryGen
//
//  Created by David Vallas on 1/20/16.
//  Copyright © 2016 Phoenix Labs. All rights reserved.
//

import Foundation


class ExportEntity {
    
    let path: String
    let licenseInfo: LicenseInfo
    var encodeAvail = true
    var entityType = ExportObject.ClassObject
    
    /// initializes the class with a baseDir and entity
    init(baseDir: String, licenseInfo: LicenseInfo) {
        self.path = baseDir + "/Entities"
        self.licenseInfo = licenseInfo
    }
    
    /// creates a base folder
    func createBaseFolder() -> Bool {
        do { try NSFileManager.defaultManager().createDirectoryAtPath(path, withIntermediateDirectories: false, attributes: nil) }
        catch { return false }
        return true
    }
    
    /// creates an entity file for the given Entity.  Returns false if error.
    func exportFile(forEntity entity: Entity) -> Bool {
        
        // return immediately if enum attributes and relationships are both 0
        if entity.attributes.count == 0 && entity.relationships.count == 0 {
            HGReportHandler.report("ExportEntity |\(entity.name)| failed, no attributes and relationships for entity", response: .Error)
            return false
        }
        
        // set default variables
        let name = entity.name
        let filePath = path + "/\(name).swift"
        let store = appDelegate.store
        let header = licenseInfo.string(store.project.name, fileName: name)
        
        // create file with header
        var file = header
        
        // add struct if it is available
        let entityStanza = entityDefinition(entity)
        file = file + "\n\n" + entityStanza
        
        // add encode if it is available
        if encodeAvail {
            let encodableStanza = encodableExtension(entity)
            file = file + "\n\n" + encodableStanza
        }
        
        // write to file, if there is an error, return false
        do {
            try file.writeToFile(filePath, atomically: true, encoding: NSUTF8StringEncoding)
        } catch {
            return false
        }
        
        return true
    }
    
    /// creates a struct definition for the Entity in string format
    private func entityDefinition(entity: Entity) -> String {
        
        // begin entity stanza
        var string: String = ""
        
        // define entity with entityType
        switch entityType {
        case .ClassObject: string = "final class \(entity.name) {\n"
        case .StructObject: string = "struct \(entity.name) {\n"
        }
        
        string += "\n"
        
        // add attributes to entity stanza
        for attribute in entity.attributes {
            string += "   let \(attribute.name): \(attribute.type)\n"
        }
        
        string += "\n"
        
        // add relationships to entity stanza
        for relationship in entity.relationships {
            if relationship.type == .TooMany {
                string += "   var \(relationship.name): [\(relationship.entity)]\n"
            } else {
                string += "   var \(relationship.name): \(relationship.entity)?\n"
            }
        }
        
        // end struct entity stanza
        string += "\n}\n"
        
        return string
    }
    
    /// creates a HGEncodable extensions for the Entity in string format
    private func encodableExtension(entity: Entity) -> String {
        
        // begin hgencodable stanza
        var string = "extension \(entity.name): HGEncodable {\n"
        string += "\n"
        
        // new variable
        string += " static var new: \(entity.name) {\n"
        string += "     return \(entity.name)("
        
        // new variable attributes
        for attribute in entity.attributes {
            string += "\(attribute.name): \(attribute.type).new, "
        }
        
        // new variable relationships
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
        
        // end new variable
        string += ")\n"
        string += " }\n\n"
        
        // begin encode variable
        string += " var encode: AnyObject {\n"
        string += "     var dict = HGDict()\n"
        
        // encode variable attributes
        for attribute in entity.attributes {
            if attribute.isPrimitive {
                string += "     dict[\"\(attribute.name)\"] = \(attribute.name)\n"
            } else {
                string += "     dict[\"\(attribute.name)\"] = \(attribute.name).encode\n"
            }
        }
        
        // encode variable relationships
        for relationship in entity.relationships {
            string += "     dict[\"\(relationship.name)\"] = \(relationship.name).encode\n"
        }
        
        // end encode variable
        string += "     return dict\n"
        string += " }\n\n"
        
        // begin decode function
        string += " static func decode(object object: AnyObject) -> \(entity.name) {\n"
        string += "     appDelegate.hgerror.track(name: \"\(entity.name)\", object: object)\n"
        string += "     let dict = hgdict(fromObject: object)\n"
        
        // decode function attributes
        for attribute in entity.attributes {
            if attribute.isPrimitive {
                string += "     let \(attribute.name) = dict[\"\(attribute.name)\"].\(attribute.type.lowerCaseFirstLetter)\n"
            } else {
                string += "     let \(attribute.name) = dict[\"\(attribute.name)\"].\(attribute.name.lowerCaseFirstLetter)\n"
            }
        }
        
        // decode function relationships
        for relationship in entity.relationships {
            if relationship.type == .TooMany {
                let arrayName = relationship.name.lowerCaseFirstLetterAndArray
                string += "     let \(relationship.name) = dict[\"\(relationship.name)\"].\(arrayName)\n"
            } else {
                let name = relationship.name.lowerCaseFirstLetter
                string += "     let \(relationship.name) = dict[\"\(relationship.name)\"].\(name)\n"
            }
        }
        
        // decode function return statement
        string += "     appDelegate.hgerror.untrack()\n"
        string += "     return \(entity.name)("
        
        // decode function return statement attributes
        for attribute in entity.attributes {
            string += "\(attribute.name): \(attribute.type), "
        }
        
        // decode function return statement relationships
        for relationship in entity.relationships {
            string += "\(relationship.name): \(relationship.name), "
        }
        
        // decode function return statement cleanup , from last object
        string = String(string.characters.dropLast())
        string = String(string.characters.dropLast())
        
        // end decode function
        string += ")\n"
        string += " }\n\n"
        
        // end hgencodable stanza
        string += "}\n"
        
        return string
    }
}

