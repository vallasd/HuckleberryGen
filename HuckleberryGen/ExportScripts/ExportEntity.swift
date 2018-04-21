//
//  ExportEntity.swift
//  HuckleberryGen
//
//  Created by David Vallas on 1/20/16.
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


class ExportEntity {
    
    let path: String
    let licenseInfo: LicenseInfo
    var encodeAvail = true
    var entityType = ExportObject.classObject
    
    /// initializes the class with a baseDir and entity
    init(baseDir: String, licenseInfo: LicenseInfo) {
        self.path = baseDir + "/Entities"
        self.licenseInfo = licenseInfo
    }
    
    /// creates a base folder
    func createBaseFolder() -> Bool {
        do { try FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: false, attributes: nil) }
        catch { return false }
        return true
    }
    
    /// creates an entity file for the given Entity.  Returns false if error.
    func exportFile(forEntity entity: Entity) -> Bool {
        
        // return immediately if enum attributes and relationships are both 0
        if entity.attributes.count == 0 && entity.relationships.count == 0 {
            HGReportHandler.shared.report("ExportEntity |\(entity.typeRep)| failed, no attributes and relationships for entity", type: .error)
            return false
        }
        
        // set default variables
        let name = entity.typeRep
        let filePath = path + "/\(name).swift"
        let store = appDelegate.store
        let header = licenseInfo.string(store.project.name, fileName: name)
        
        // create file with header
        var file = header
        
        // add struct if it is available
        let entityStanza = entityDefinition(entity)
        file = file + "\n" + entityStanza
        
        // add encode if it is available
        if encodeAvail {
            let encodableStanza = encodableExtension(entity)
            file = file + "\n" + encodableStanza
        }
        
        // write to file, if there is an error, return false
        do {
            try file.write(toFile: filePath, atomically: true, encoding: String.Encoding.utf8)
        } catch {
            return false
        }
        
        return true
    }
    
    /// creates a struct definition for the Entity in string format
    fileprivate func entityDefinition(_ entity: Entity) -> String {
        
        // get indent
        let ind = HGIndent.indent
        
        // begin entity stanza
        var string: String = "final class \(entity.typeRep) {\n"
        
        string += "\n"
        
        // add attributes to entity stanza
        for attribute in entity.attributes {
            string += "\(ind)let \(attribute.varRep): \(attribute.typeRep)\n"
        }
        
        // add relationships to entity stanza
        for relationship in entity.relationships {
            string += "\(ind)var \(relationship.varRep): \(relationship.typeRep)\n"
        }
        
        string += "\n"
        
        // begin init
        string += "\(ind)init("
        
        // assign strings
        var assigns: [String] = []
        
        // new variable attributes
        for attribute in entity.attributes {
            string += "\(attribute.varRep): \(attribute.typeRep), "
            let attAssign = "\(ind)\(ind)self.\(attribute.varRep) = \(attribute.varRep)\n"
            assigns.append(attAssign)
            
        }
        
        // new variable relationships
        for relationship in entity.relationships {
            string += "\(relationship.varRep): \(relationship.typeRep), "
            let relAssign = "\(ind)\(ind)self.\(relationship.varRep) = \(relationship.varRep)\n"
            assigns.append(relAssign)
        }
        
        // remove last , from init statement
        string = String(string.dropLast())
        string = String(string.dropLast())
        
        // end init first line
        string += ") {\n"
        
        // add all assignments in init
        for assign in assigns {
            string += assign
        }
        
        // end init
        string += "\(ind)}\n"
        
        // end struct entity stanza
        string += "}\n"
        
        return string
    }
    
    /// creates a HGEncodable extensions for the Entity in string format
    fileprivate func encodableExtension(_ entity: Entity) -> String {
        
        // get indent
        let ind = HGIndent.indent
        
        // get Primitives
        let primitives = Primitive.array.map { $0.typeRep }
        let primitivesDefault = Primitive.array.map { $0.defaultRep }
        
        // begin hgencodable stanza
        var string = "extension \(entity.typeRep): HGEncodable {\n"
        string += "\n"
        
        // new variable
        string += "\(ind)static var new: \(entity.typeRep) {\n"
        string += "\(ind)\(ind)return \(entity.typeRep)("
        
        // new variable attributes
        for attribute in entity.attributes {
            let type = attribute.typeRep
            let index = primitives.index(of: type)
            if let index = index { string += "\(attribute.varRep): \(primitivesDefault[index]), " }
            else { string += "\(attribute.varRep): \(attribute.typeRep).new, " }
        }
        
        // new variable relationships
        for relationship in entity.relationships {
            string += "\(relationship.varRep): \(relationship.defaultRep), "
        }
        
        // remove last , from new var
        string = String(string.dropLast())
        string = String(string.dropLast())
        
        // end new variable
        string += ")\n"
        string += "\(ind)}\n\n"
        
        // begin encode variable
        string += "\(ind)var encode: AnyObject {\n"
        string += "\(ind)\(ind)var dict = HGDICT()\n"
        
        // encode variable attributes
        for attribute in entity.attributes {
            if attribute.isPrimitive {
                string += "\(ind)\(ind)dict[\"\(attribute.varRep)\"] = \(attribute.varRep)\n"
            } else {
                string += "\(ind)\(ind)dict[\"\(attribute.varRep)\"] = \(attribute.varRep).encode\n"
            }
        }
        
        // encode variable relationships
        for relationship in entity.relationships {
            let name = relationship.varRep
            let equals = relationship.relType == .tooOne ? "=?" : "="
            string += "\(ind)\(ind)dict[\"\(name)\"] \(equals) \(name).encode\n"
        }
        
        // end encode variable
        string += "\(ind)\(ind)return dict\n"
        string += "\(ind)}\n\n"
        
        // begin decode function
        string += "\(ind)static func decode(object object: AnyObject) -> \(entity.typeRep) {\n"
        string += "\(ind)\(ind)HGReportHandler.shared.track(name: \"\(entity.typeRep)\", object: object)\n"
        string += "\(ind)\(ind)let dict = hgdict(fromObject: object, decoderName: \"\(entity.typeRep)\")\n"
        
        // decode function attributes
        for attribute in entity.attributes {
            string += "\(ind)\(ind)let \(attribute.varRep) = dict[\"\(attribute.varRep)\"].\(attribute.decodeRep)\n"
        }
        
        // decode function relationships
        for relationship in entity.relationships {
            let name = relationship.varRep
            string += "\(ind)\(ind)let \(name) = dict[\"\(name)\"].\(relationship.decodeRep)\n"
        }
        
        // decode function return statement
        string += "\(ind)\(ind)HGReportHandler.shared.untrack()\n"
        string += "\(ind)\(ind)return \(entity.typeRep)("
        
        // decode function return statement attributes
        for attribute in entity.attributes {
            string += "\(attribute.varRep): \(attribute.varRep), "
        }
        
        // decode function return statement relationships
        for relationship in entity.relationships {
            string += "\(relationship.varRep): \(relationship.varRep), "
        }
        
        // decode function return statement cleanup , from last object
        string = String(string.dropLast())
        string = String(string.dropLast())
        
        // end decode function
        string += ")\n"
        string += "\(ind)}\n"
        
        // end hgencodable stanza
        string += "}\n"
        
        return string
    }
}

