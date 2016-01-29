//
//  ExportEnum.swift
//  HuckleberryGen
//
//  Created by David Vallas on 1/21/16.
//  Copyright © 2016 Phoenix Labs. All rights reserved.
//

import Foundation

class ExportEnum {
    
    let path: String
    let licenseInfo: LicenseInfo
    var encodeAvail = true
    
    /// initializes the class with a baseDir and entity
    init(baseDir: String, licenseInfo: LicenseInfo) {
        self.path = baseDir + "/Enums"
        self.licenseInfo = licenseInfo
    }
    
    /// creates a base folder
    func createBaseFolder() -> Bool {
        do { try NSFileManager.defaultManager().createDirectoryAtPath(path, withIntermediateDirectories: false, attributes: nil) }
        catch { return false }
        return true
    }
    
    /// creates an entity file for the given Entity.  Returns false if error.
    func exportFile(forEnum enuM: Enum) -> Bool {
        
        // return immediately if enum cases count is 0
        if enuM.cases.count == 0 {
            appDelegate.error.report("Export Enum |\(enuM.name)| failed, no cases for enum", type: .Error)
            return false
        }
        
        // set default variables
        let name = enuM.name
        let filePath = path + "/\(name).swift"
        let store = appDelegate.store
        let header = licenseInfo.string(store.project.name, fileName: name)
        
        // create file with header
        var file = header
        
        // add struct if it is available
        let enumStanza = enumDefinition(enuM)
        file = file + "\n" + enumStanza
        
        // add encode if it is available
        if encodeAvail {
            let encodableStanza = encodableExtension(enuM)
            file = file + "\n" + encodableStanza
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
    private func enumDefinition(enuM: Enum) -> String {
        
        // get indent
        let ind = HGIndent.indent
        
        // begin enum definition
        var string = "enum \(enuM.name) {\n"
        
        string += "\n"
        
        // add attributes to enum stanza
        for enumcase in enuM.cases {
            string += "\(ind)case \(enumcase.typeRep())\n"
        }
        
        string += "\n"
        
        // define int for enum stanza
        string += "\(ind)var int: Int {\n"
        string += "\(ind)\(ind)switch self {\n"
        
        var index = 0
        for enumcase in enuM.cases {
            string += "\(ind)\(ind)case \(enumcase.typeRep()): return \(index)\n"
            index++
        }
        
        // end int for enum stanza
        string += "\(ind)\(ind)}\n"
        string += "\(ind)}\n"
        
        string += "\n"
        
        // define string for enum stanza
        string += "\(ind)var string: String {\n"
        string += "\(ind)\(ind)switch self {\n"
        
        for enumcase in enuM.cases {
            string += "\(ind)\(ind)case \(enumcase.typeRep()): return \"\(enumcase.string)\"\n"
        }
        
        // end string for enum stanza
        string += "\(ind)\(ind)}\n"
        string += "\(ind)}\n"
        
        // end enum definition
        string += "}\n"
        
        return string
    }
    
    /// creates a HGEncodable extensions for the Entity in string format
    private func encodableExtension(enuM: Enum) -> String {
        
        // get indent
        let ind = HGIndent.indent
        
        // create default case type report, if cases were not loaded, will create string that will cause an error in Export file to draw attention
        let defaultCaseType = enuM.cases.count > 0 ? enuM.cases.first!.typeRep() : "Missing Enum Cases!!!"
        
        // begin hgencodable stanza
        var string = "extension \(enuM.name): HGEncodable {\n"
        string += "\n"
        
        // new variable
        string += "\(ind)static var new: \(enuM.name) {\n"
        string += "\(ind)\(ind)return \(enuM.name).\(defaultCaseType)\n"
        
        // end new variable
        string += "\(ind)}\n\n"
        
        // begin encode variable
        string += "\(ind)var encode: AnyObject {\n"
        string += "\(ind)\(ind)return self.int\n"
        
        // end encode variable
        string += "\(ind)}\n\n"
        
        // begin decode function
        string += "\(ind)static func decode(object object: AnyObject) -> \(enuM.name) {\n"
        string += "\(ind)\(ind)if let int = object as? Int { return int.\(enuM.name.lowerCaseFirstLetter) }\n"
        string += "\(ind)\(ind)if let string = object as? String { return string.\(enuM.name.lowerCaseFirstLetter) }\n"
        string += "\(ind)\(ind)appDelegate.error.report(\"object \\(object) is not |\(enuM.typeRep())| decodable, returning \(defaultCaseType)\", type: .Error)\n"
        string += "\(ind)\(ind)return \(enuM.name).new\n"
        
        // end decode function
        string += "\(ind)}\n"
        
        // end hgencodable stanza
        string += "}\n"
        
        return string
        
    }
}

