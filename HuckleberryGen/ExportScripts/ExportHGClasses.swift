//
//  ExportHGClasses.swift
//  HuckleberryGen
//
//  Created by David Vallas on 1/26/16.
//  Copyright © 2016 Phoenix Labs.
//
//  All Rights Reserved.

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
        do { try FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: false, attributes: nil) }
        catch { return false }
        return true
    }
    
    /// creates an entity file for the given Entity.  Returns false if error.
    func exportFiles() -> Bool {
        exportHGObject()
        exportHGError()
        exportHGErrorTrack()
        exportHGErrorReporter()
        exportHGOperators()
        return true
    }
    
    func exportHGObject() {
        let name = "HGObjects"
        let filePath = path + "/\(name).swift"
        let header = licenseInfo.string(projectName, fileName: name)
        let code = ExportProject.read(file: "XP_CLA_HGObject")
        let file = header + "\n" + code
        let _ = ExportProject.write(file: file, toPath: filePath)
    }
    
    func exportHGErrorReporter() {
        let name = "HGErrorReporter"
        let filePath = path + "/\(name).swift"
        let header = licenseInfo.string(projectName, fileName: name)
        let code = ExportProject.read(file: "XP_CLA_HGErrorReporter")
        let file = header + "\n" + code
        let _ = ExportProject.write(file: file, toPath: filePath)
    }
    
    func exportHGError() {
        let name = "HGError"
        let filePath = path + "/\(name).swift"
        let header = licenseInfo.string(projectName, fileName: name)
        let code = ExportProject.read(file: "XP_CLA_HGError")
        let file = header + "\n" + code
        let _ = ExportProject.write(file: file, toPath: filePath)
    }
    
    func exportHGErrorTrack() {
        let name = "HGErrorTrack"
        let filePath = path + "/\(name).swift"
        let header = licenseInfo.string(projectName, fileName: name)
        let code = ExportProject.read(file: "XP_CLA_HGErrorTrack")
        let file = header + "\n" + code
        let _ = ExportProject.write(file: file, toPath: filePath)
    }
    
    func exportHGOperators() {
        let name = "HGOperators"
        let filePath = path + "/\(name).swift"
        let file = ExportProject.read(file: "XP_CLA_HGOperators")
        let _ = ExportProject.write(file: file, toPath: filePath)
    }
    
}
