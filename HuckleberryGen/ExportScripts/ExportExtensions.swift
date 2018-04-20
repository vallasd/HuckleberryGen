//
//  ExportExtensions.swift
//  HuckleberryGen
//
//  Created by David Vallas on 1/22/16.
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

class ExportExtensions {
    
    let path: String
    let exportOptional: ExportOptional
    let exportString: ExportString
    let exportInt: ExportInt
    
    /// initializes the class with a baseDir and entity
    init(baseDir: String, store: HuckleberryGen) {
        path = baseDir + "/Extensions"
        let licenseInfo = store.licenseInfo
        let entityNames = store.project.entities.map { $0.typeRep }
        let enumNames = store.project.enums.map { $0.name }
        
        exportOptional = ExportOptional(baseDir: path, licenseInfo: licenseInfo, entityNames: entityNames, enumNames: enumNames)
        exportString = ExportString(baseDir: path, licenseInfo: licenseInfo, enums: store.project.enums)
        exportInt = ExportInt(baseDir: path, licenseInfo: licenseInfo, enums: store.project.enums)
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

