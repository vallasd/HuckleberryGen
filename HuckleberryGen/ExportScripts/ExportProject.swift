//
//  ExportProject.swift
//  HuckleberryGen
//
//  Created by David Vallas on 1/19/16.
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

//  You should have received a copy of the GNU General Public License
//  along with HuckleberryGen.  If not, see <http://www.gnu.org/licenses/>.

import Cocoa

class ExportProject {
    
    let path: String
    let store: HuckleberryGen
    let exportEntity: ExportEntity
    let exportEnum: ExportEnum
    let exportExtensions: ExportExtensions
    let exportProtocols: ExportProtocols
    let exportHGClasses: ExportHGClasses
    
    init(store: HuckleberryGen) {
        self.store = store
        let license = store.licenseInfo
        let projectName = store.project.name
        path = store.exportPath + "/\(store.project.name)"
        exportEntity = ExportEntity(baseDir: path, licenseInfo: license)
        exportEnum = ExportEnum(baseDir: path, licenseInfo: license)
        exportExtensions = ExportExtensions(baseDir: path, store: store)
        exportProtocols = ExportProtocols(baseDir: path, projectName: projectName, licenseInfo: license)
        exportHGClasses = ExportHGClasses(baseDir: path, projectName: projectName, licenseInfo: license)
    }
    
    func export() {
        
        store.project.createEntityInfo()
         
        // create folder structure for export
        createBaseFolders()
        
        // create Entity Files
        for entity in store.project.entities { exportEntity.exportFile(forEntity: entity) }
        
        // create Store Enum Files
        for enuM in store.project.enums { exportEnum.exportFile(forEnum: enuM) }
        
        // create Extension Files
        exportExtensions.exportFiles()
        
        // create Protocol Files
        exportProtocols.exportFiles()
        
        // create HGClass Files
        exportHGClasses.exportFiles()
        
    }

    /// reads file in project, if there is an error, returns false
    static func read(file file: String) -> String {
        
        let path = NSBundle.mainBundle().pathForResource(file, ofType: "txt") ?? ""
        
        do  {
            let content = try String(contentsOfFile: path, encoding: NSUTF8StringEncoding) // crash right away, you are looking for file that DNE
            return content
        } catch {
            HGReportHandler.shared.report("ExportProject: can not unpackage \(file) from path \(path)", type: .Error)
        }
        
        return ""
    }
    
    /// write to file, if there is an error, return false
    static func write(file file: String, toPath path: String) -> Bool {
        
        do {
            try file.writeToFile(path, atomically: true, encoding: NSUTF8StringEncoding)
            return true
        } catch {
            HGReportHandler.shared.report("ExportProject: can not package \(file) to path \(path)", type: .Error)
        }
        
        return false
    }
    
    func createBaseFolders() {
        
        // create base directory from path
        do {
            try NSFileManager.defaultManager().createDirectoryAtPath(path, withIntermediateDirectories: false, attributes: nil)
        } catch {
            // do nothing
        }
        
        // create sub folders in rest of path
        exportEntity.createBaseFolder()
        exportEnum.createBaseFolder()
        exportExtensions.createBaseFolder()
        exportProtocols.createBaseFolder()
        exportHGClasses.createBaseFolder()
        
//        let entities = baseDirectory + "/Entities"
//        let enums = baseDirectory + "/Enums"
//        let errors = baseDirectory + "/Errors"
//        let extensions = baseDirectory + "/Extensions"
//        let options = baseDirectory + "/Options"
//        let protocols = baseDirectory + "/Protocols"
//
    }
    
    
}