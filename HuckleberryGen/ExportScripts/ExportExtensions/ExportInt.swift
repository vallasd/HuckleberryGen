//
//  ExportInt.swift
//  HuckleberryGen
//
//  Created by David Vallas on 1/25/16.
//  Copyright © 2016 Phoenix Labs.
//
//  All Rights Reserved.

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
            try file.write(toFile: filePath, atomically: true, encoding: String.Encoding.utf8)
        } catch {
            return false
        }
        
        return true
    }
    
    /// creates optional definitions for the Enum in string format
    fileprivate func enumDefinitions() -> String {
        
        // begin string extension
        var string = "// MARK: Enums\n"
        string += "extension Int {\n\n"
        
        // get indent
        let ind = HGIndent.indent
        
        for enuM in enums {
            
            // check if enums have cases, if not log error and break
            if enuM.cases.count == 0 {
                HGReport.shared.report("enum: |\(enuM.name)| has no cases, skipping", type: .error)
                break
            }
            
            // get enum name and defaultValue
            let enumtype = enuM.name
            let enumvar = enuM.name.varRepresentable
            let defaultValue = enuM.cases.first!
            
            // create var that attempts to unwrap the string as the Enum
            string += "\(ind)/// returns \(enumtype)s.  Logs error and returns \(defaultValue) if not a valid Int.\n"
            string += "\(ind)var \(enumvar): \(enumtype) {\n"
            string += " \(ind)\(ind)switch self {\n"
            var count = 0
            for enumcase in enuM.cases {
                string += "\(ind)\(ind)case \(count): return .\(enumcase) \n"
                count += 1
            }
            string += "\(ind)\(ind)default:\n"
            string += "\(ind)\(ind)\(ind)HGReport.shared.report(\"int: |\\(self)| is not enum |\(enumtype)| mapable, using \(defaultValue)\", type: .Error)\n"
            string += "\(ind)\(ind)}\n"
            string += "\(ind)\(ind)return \(defaultValue)\n"
            string += "\(ind)}\n"
        }
        
        // end string extension
        string += "}\n"
        
        return string
    }
    
}

