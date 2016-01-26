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
        
        // begin enum definition
        var string = "enum \(enuM.name) {\n"
        
        string += "\n"
        
        // add attributes to enum stanza
        for enumcase in enuM.cases {
            string += "\tcase \(enumcase.name)\n"
        }
        
        string += "\n"
        
        // define int for enum stanza
        string += "\tvar int: Int {\n"
        string += "\t\tswitch self {\n"
        
        var index = 0
        for enumcase in enuM.cases {
            string += "\t\tcase \(enumcase.name): return \(index)\n"
            index++
        }
        
        // end int for enum stanza
        string += "\t\t}\n"
        string += "\t}\n"
        
        string += "\n"
        
        // define string for enum stanza
        string += "\tvar string: String {\n"
        string += "\t\tswitch self {\n"
        
        for enumcase in enuM.cases {
            string += "\t\tcase \(enumcase.name): return \"\(enumcase.name)\"\n"
        }
        
        // end string for enum stanza
        string += "\t\t}\n"
        string += "\t}\n"
        
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
        string += "\tstatic var new: \(enuM.name) {\n"
        string += "\t\treturn \(enuM.name).\(enuM.cases[0].name)\n"
        
        // end new variable
        string += "\t}\n\n"
        
        // begin encode variable
        string += "\tvar encode: AnyObject {\n"
        string += "\t\treturn self.int\n"
        
        // end encode variable
        string += "\t}\n\n"
        
        // begin decode function
        string += "\tstatic func decode(object object: AnyObject) -> \(enuM.name) {\n"
        string += "\t\tif let int = object as? Int { return int.\(enuM.name.lowerCaseFirstLetter) }\n"
        string += "\t\tif let string = object as? String { return string.\(enuM.name.lowerCaseFirstLetter) }\n"
        string += "\t\tappDelegate.hgerror.report(\"object \\(object) is not \(enuM.name) decodable, returning \(enuM.cases[0].name)\", .Error)\n"
        string += "\t\treturn \(enuM.name).new\n"
        
        // end decode function
        string += "\t}\n"
        
        // end hgencodable stanza
        string += "}\n"
        
        return string
        
    }
}

