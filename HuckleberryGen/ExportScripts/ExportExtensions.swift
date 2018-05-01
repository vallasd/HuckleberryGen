//
//  ExportExtensions.swift
//  HuckleberryGen
//
//  Created by David Vallas on 1/22/16.
//  Copyright © 2016 Phoenix Labs.
//
//  All Rights Reserved.

import Foundation

class ExportExtensions {
    
    let path: String
    let exportOptional: ExportOptional
    let exportString: ExportString
    let exportInt: ExportInt
    
    /// initializes the class with a baseDir and entity
    init(baseDir: String, store: HuckleberryGen) {
        path = baseDir + "/Extensions"
        let licenseInfo = store.licenseInfo
        let entityArray = project.entities.sorted { $0.name > $1.name }
        let enumArray = project.enums.sorted { $0.name > $1.name }
        let entityNames = entityArray.map { $0.name }
        let enumNames = enumArray.map { $0.name }
        
        exportOptional = ExportOptional(baseDir: path, licenseInfo: licenseInfo, entityNames: entityNames, enumNames: enumNames)
        exportString = ExportString(baseDir: path, licenseInfo: licenseInfo, enums: enumArray)
        exportInt = ExportInt(baseDir: path, licenseInfo: licenseInfo, enums: enumArray)
    }
    
    /// creates a base folder
    func createBaseFolder() -> Bool {
        do { try FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: false, attributes: nil) }
        catch { return false }
        return true
    }
    
    /// creates an optional file for the given Entity.  Returns false if error.
    func exportFiles() -> Bool {
        
        var exportedAllFiles = true

        exportedAllFiles = exportOptional.exportFile() == false ? false : exportedAllFiles
        exportedAllFiles = exportString.exportFile() == false ? false : exportedAllFiles
        exportedAllFiles = exportInt.exportFile() == false ? false : exportedAllFiles
        
        return exportedAllFiles
    }

}

