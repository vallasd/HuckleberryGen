//
//  ExportExtensions.swift
//  HuckleberryGen
//
//  Created by David Vallas on 1/22/16.
//  Copyright © 2016 Phoenix Labs. All rights reserved.
//

import Foundation

class ExportExtensions {
    
    let path: String
    let exportOptional: ExportOptional
    
    /// initializes the class with a baseDir and entity
    init(baseDir: String, store: HuckleberryGen) {
        path = baseDir + "/Extensions"
        let licenseInfo = store.licenseInfo
        let entityNames = store.project.entities.map { $0.name }
        let enumNames = store.project.enums.map { $0.name }
        
        exportOptional = ExportOptional(baseDir: path, licenseInfo: licenseInfo, entityNames: entityNames, enumNames: enumNames)
        
    }
    
    /// creates a base folder
    func createBaseFolder() -> Bool {
        do { try NSFileManager.defaultManager().createDirectoryAtPath(path, withIntermediateDirectories: false, attributes: nil) }
        catch { return false }
        return true
    }
    
    /// creates an optional file for the given Entity.  Returns false if error.
    func exportFiles() -> Bool {
        
        var pass = true
        
        // pass = pass == false ? false : ExportOptional.exportFile()
        
        
        return pass
    }

}

