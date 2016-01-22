//
//  ExportOptional.swift
//  HuckleberryGen
//
//  Created by David Vallas on 1/22/16.
//  Copyright © 2016 Phoenix Labs. All rights reserved.
//

import Foundation

class ExportOptional {
    
    let path: String
    let licenseInfo: LicenseInfo
    let entities: [String]
    let enums: [String]
    
    /// initializes the class with a baseDir and entity
    init(baseDir: String, licenseInfo: LicenseInfo, entityNames: [String], enumNames: [String]) {
        path = baseDir
        self.licenseInfo = licenseInfo
        entities = entityNames
        enums = enumNames
    }
    
    /// creates an entity file for the given Entity.  Returns false if error.
    func exportFile() -> Bool {
        
        // set default variables
//        let name = entity.name
//        let filePath = path + "/\(name).swift"
//        let store = appDelegate.store
//        let header = licenseInfo.string(store.project.name, fileName: name)
        
        
//        // write to file, if there is an error, return false
//        do {
//            try file.writeToFile(filePath, atomically: true, encoding: NSUTF8StringEncoding)
//        } catch {
//            return false
//        }
        
        return true
    }
    
    
}

