//
//  ExportInt.swift
//  HuckleberryGen
//
//  Created by David Vallas on 1/25/16.
//  Copyright © 2016 Phoenix Labs. All rights reserved.
//

import Foundation

class ExportInt {
    
    let path: String
    let licenseInfo: LicenseInfo
    let enums: [Enum]
    
    /// initializes the class with a baseDir and entity
    init(baseDir: String, licenseInfo: LicenseInfo, enums: [Enum]) {
        path = baseDir
        self.licenseInfo = licenseInfo
        self.enums = enums
    }
    
    /// creates an entity file for the given Entity.  Returns false if error.
    func exportFile() -> Bool {
        
        // Setting Default Names
        let name = "HGInt"
        let filePath = path + "/\(name).swift"
        let store = appDelegate.store
        let header = licenseInfo.string(store.project.name, fileName: name)
        let enumExtension = enumDefinitions()
        
        // Create String File that will be written
        let file = header + "\n" + enumExtension
        
        // write to file, if there is an error, return false
        do {
            try file.writeToFile(filePath, atomically: true, encoding: NSUTF8StringEncoding)
        } catch {
            return false
        }
        
        return true
    }
    
    /// creates optional definitions for the Enum in string format
    private func enumDefinitions() -> String {
        
        // begin string extension
        var string = "// MARK: Enums\n"
        string += "extension Int {\n\n"
        
        
        for enuM in enums {
            
            // get indent
            let ind = HGIndent.indent
            
            // get enum name and defaultValue
            let name = enuM.name
            let defaultValue = "\(enuM.name).new"
            
            // create var that attempts to unwrap the string as the Enum
            string += "\(ind)/// returns \(name) if valid string.  Logs error and returns \(defaultValue) if object is nil or not a valid string.\n"
            string += "\(ind)var \(name.lowerCaseFirstLetter): \(name) {\n"
            string += " \(ind)\(ind)switch self {\n"
            var count = 0
            for enumcase in enuM.cases {
                string += "\(ind)\(ind)case \(count): return .\(enumcase.name) \n"
                count++
            }
            string += "\(ind)\(ind)}\n"
            string += "\(ind)\(ind)appDelegate.error.report(\"int: |\\(self)| is not enum \(name) mapable, using \(name).new\", type: .Error)\n"
            string += "\(ind)\(ind)return \(name).new\n"
            string += "\(ind)}\n"
        }
        
        // end string extension
        string += "}\n"
        
        return string
    }
    
}

