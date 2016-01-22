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
            HGReportHandler.report("Export Enum |\(enuM.name)| failed, no cases for enum", response: .Error)
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
        file = file + "\n\n" + enumStanza
        
        // add encode if it is available
        if encodeAvail {
            let encodableStanza = encodableExtension(enuM)
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
    private func enumDefinition(enuM: Enum) -> String {
        
        var string: String = "\n"
        
        // begin enum definition
        string += "enum \(enuM.name) {\n"
        
        // add attributes to enum stanza
        for enumcase in enuM.cases {
            string += "   case \(enumcase.name)\n"
        }
        
        string += "\n"
        
        // define int for enum stanza
        string += " var int: Int {\n"
        string += "     switch self {\n"
        
        var index = 0
        for enumcase in enuM.cases {
            string += "     case \(enumcase.name): return \(index)\n"
            index++
        }
        
        // end int for enum stanza
        string += "     }\n"
        string += " }\n"
        
        string += "\n"
        
        // define string for enum stanza
        string += " var string: String {\n"
        string += "     switch self {\n"
        
        for enumcase in enuM.cases {
            string += "     case \(enumcase.name): return \"\(enumcase.name)\"\n"
        }
        
        // end string for enum stanza
        string += "     }\n"
        string += " }\n"
        
        // end enum definition
        string += "}\n"
        
        return string
    }
    
    /// creates a HGEncodable extensions for the Entity in string format
    private func encodableExtension(enuM: Enum) -> String {
        
        // begin hgencodable stanza
        var string = "extension \(enuM.name): HGEncodable {\n"
        string += "\n"
        
        // new variable
        string += " static var new: \(enuM.name) {\n"
        string += "     return \(enuM.name).\(enuM.cases[0].name)\n"
        
        // end new variable
        string += " }\n\n"
        
        // begin encode variable
        string += " var encode: AnyObject {\n"
        string += "     return self.int\n"
        
        // end encode variable
        string += " }\n\n"
        
        // begin decode function
        string += " static func decode(object object: AnyObject) -> \(enuM.name) {\n"
        string += "     if let int = object as? Int { return int.\(enuM.name.lowerCaseFirstLetter) }\n"
        string += "     if let string = object as? String { return string.\(enuM.name.lowerCaseFirstLetter) }\n"
        string += "     HGReportHandler.report(\"object \\(object) is not \(enuM.name) decodable, returning \(enuM.cases[0].name)\", .Error)\n"
        string += "     return \(enuM.name).new\n"
        
        // end decode function
        string += " }\n\n"
        
        // end hgencodable stanza
        string += "}\n"
        
        return string
        
    }
}

