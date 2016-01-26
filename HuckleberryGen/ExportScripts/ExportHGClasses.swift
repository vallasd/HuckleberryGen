//
//  ExportHGClasses.swift
//  HuckleberryGen
//
//  Created by David Vallas on 1/26/16.
//  Copyright © 2016 Phoenix Labs. All rights reserved.
//

import Foundation


class ExportHGClasses {
    
    let projectName: String
    let path: String
    let licenseInfo: LicenseInfo
    
    /// initializes the class with a baseDir and entity
    init(baseDir: String, projectName: String, licenseInfo: LicenseInfo) {
        self.path = baseDir + "/HGClasses"
        self.licenseInfo = licenseInfo
        self.projectName = projectName
    }
    
    /// creates a base folder
    func createBaseFolder() -> Bool {
        do { try NSFileManager.defaultManager().createDirectoryAtPath(path, withIntermediateDirectories: false, attributes: nil) }
        catch { return false }
        return true
    }
    
    /// creates an entity file for the given Entity.  Returns false if error.
    func exportFiles() -> Bool {
        exportHGObject()
        exportHGError()
        return true
    }
    
    func exportHGObject() {
        let name = "HGObjects"
        let filePath = path + "/\(name).swift"
        let header = licenseInfo.string(projectName, fileName: name)
        let code = ExportProject.read(file: "XP_CLA_HGObject")
        let file = header + "\n" + code
        ExportProject.write(file: file, toPath: filePath)
    }
    
    func exportHGError() {
        let name = "HGError"
        let filePath = path + "/\(name).swift"
        let header = licenseInfo.string(projectName, fileName: name)
        let code = ExportProject.read(file: "XP_CLA_HGError")
        let file = header + "\n" + code
        ExportProject.write(file: file, toPath: filePath)
    }
    
}