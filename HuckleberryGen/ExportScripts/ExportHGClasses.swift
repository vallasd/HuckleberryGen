//
//  ExportHGClasses.swift
//  HuckleberryGen
//
//  Created by David Vallas on 1/26/16.
//  Copyright © 2016 Phoenix Labs.
//
//  This file is part of HuckleberryGen.
//
//  HuckleberryGen is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  HuckleberryGen is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with HuckleberryGen.  If not, see <http://www.gnu.org/licenses/>.

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
        ExportProject.write(file: file, toPath: filePath)
    }
    
    func exportHGErrorReporter() {
        let name = "HGErrorReporter"
        let filePath = path + "/\(name).swift"
        let header = licenseInfo.string(projectName, fileName: name)
        let code = ExportProject.read(file: "XP_CLA_HGErrorReporter")
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
    
    func exportHGErrorTrack() {
        let name = "HGErrorTrack"
        let filePath = path + "/\(name).swift"
        let header = licenseInfo.string(projectName, fileName: name)
        let code = ExportProject.read(file: "XP_CLA_HGErrorTrack")
        let file = header + "\n" + code
        ExportProject.write(file: file, toPath: filePath)
    }
    
    func exportHGOperators() {
        let name = "HGOperators"
        let filePath = path + "/\(name).swift"
        let file = ExportProject.read(file: "XP_CLA_HGOperators")
        ExportProject.write(file: file, toPath: filePath)
    }
    
}
