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
        
        // get indent
        let ind = HGIndent.indent
        
        for enuM in enums {
            
            // get enum name and defaultValue
            let enumtype = enuM.typeRep()
            let enumvar = enuM.varRep()
            let defaultValue = enuM.defaultRep()
            
            // create var that attempts to unwrap the string as the Enum
            string += "\(ind)/// returns \(enumtype)s.  Logs error and returns \(defaultValue) if not a valid Int.\n"
            string += "\(ind)var \(enumvar): \(enumtype) {\n"
            string += " \(ind)\(ind)switch self {\n"
            var count = 0
            for enumcase in enuM.cases {
                string += "\(ind)\(ind)case \(count): return .\(enumcase.typeRep()) \n"
                count++
            }
            string += "\(ind)\(ind)default:\n"
            string += "\(ind)\(ind)\(ind)HGReportHandler.shared.report(\"int: |\\(self)| is not enum |\(enumtype)| mapable, using \(defaultValue)\", type: .Error)\n"
            string += "\(ind)\(ind)}\n"
            string += "\(ind)\(ind)return \(defaultValue)\n"
            string += "\(ind)}\n"
        }
        
        // end string extension
        string += "}\n"
        
        return string
    }
    
}

