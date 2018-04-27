//
//  ExportEntity.swift
//  HuckleberryGen
//
//  Created by David Vallas on 1/20/16.
//  Copyright © 2016 Phoenix Labs.
//
//  All Rights Reserved.

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
        if entity.attributes.count == 0 {
            HGReport.shared.report("ExportEntity |\(entity.name)| failed, no attributes and relationships for entity", type: .error)
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
        var string: String = "final class \(entity.name) {\n"
        
        string += "\n"
        
        // add attributes to entity stanza
        for attribute in entity.attributes {
            string += "\(ind)let \(attribute.name): \(attribute.typeName)\n"
        }
        
        string += "\n"
        
        // begin init
        string += "\(ind)init("
        
        // assign strings
        var assigns: [String] = []
        
        // new variable attributes
        for attribute in entity.attributes {
            string += "\(attribute.name): \(attribute.typeName), "
            let attAssign = "\(ind)\(ind)self.\(attribute.name) = \(attribute.name)\n"
            assigns.append(attAssign)
            
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
        let primitives = Primitive.array.map { $0.name }
        let primitivesDefault = Primitive.array.map { $0.defaultRep }
        
        // begin hgencodable stanza
        var string = "extension \(entity.name): HGEncodable {\n"
        string += "\n"
        
        // new variable
        string += "\(ind)static var new: \(entity.name) {\n"
        string += "\(ind)\(ind)return \(entity.name)("
        
        // new variable attributes
        for attribute in entity.attributes {
            let type = attribute.typeName
            let index = primitives.index(of: type)
            if let index = index { string += "\(attribute.name): \(primitivesDefault[index]), " }
            else { string += "\(attribute.name): \(attribute.name).new, " }
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
            if attribute.type == .primitive {
                string += "\(ind)\(ind)dict[\"\(attribute.name)\"] = \(attribute.name)\n"
            } else {
                string += "\(ind)\(ind)dict[\"\(attribute.name)\"] = \(attribute.name).encode\n"
            }
        }
        
        // end encode variable
        string += "\(ind)\(ind)return dict\n"
        string += "\(ind)}\n\n"
        
        // begin decode function
        string += "\(ind)static func decode(object object: AnyObject) -> \(entity.name) {\n"
        string += "\(ind)\(ind)HGReport.shared.track(name: \"\(entity.name)\", object: object)\n"
        string += "\(ind)\(ind)let dict = HG.decode(hgdict: object, decoderName: \"\(entity.name)\")\n"
        
        // decode function attributes
        for attribute in entity.attributes {
            string += "\(ind)\(ind)let \(attribute.name) = dict[\"\(attribute.name)\"].\(attribute.name)\n"
        }
        
        // decode function return statement
        string += "\(ind)\(ind)HGReport.shared.untrack()\n"
        string += "\(ind)\(ind)return \(entity.name)("
        
        // decode function return statement attributes
        for attribute in entity.attributes {
            string += "\(attribute.name): \(attribute.name), "
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

