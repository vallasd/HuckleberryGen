//
//  ExportProtocols.swift
//  HuckleberryGen
//
//  Created by David Vallas on 1/26/16.
//  Copyright © 2016 Phoenix Labs.
//
//  All Rights Reserved.

import Foundation


class ExportProtocols {
    
    let projectName: String
    let path: String
    let licenseInfo: LicenseInfo
    
    /// initializes the class with a baseDir and entity
    init(baseDir: String, projectName: String, licenseInfo: LicenseInfo) {
        self.path = baseDir + "/Protocols"
        self.licenseInfo = licenseInfo
        self.projectName = projectName
    }
    
    /// creates a base folder
    func createBaseFolder() -> Bool {
        do { try FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: false, attributes: nil) }
        catch { return false }
        return true
    }
    
    /// creates an entity file for the given Entity.  Returns false if error.
    func exportFiles() -> Bool {
        
        exportHGCodable()
        
        return true
    }
    
    func exportHGCodable() {
        let name = "HGCodable"
        let filePath = path + "/\(name).swift"
        let header = licenseInfo.string(projectName, fileName: name)
        let code = ExportProject.read(file: "XP_PRO_HGCodable")
        let file = header + "\n" + code
        let _ = ExportProject.write(file: file, toPath: filePath)
    }
}
