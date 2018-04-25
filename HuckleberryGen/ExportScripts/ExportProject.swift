//
//  ExportProject.swift
//  HuckleberryGen
//
//  Created by David Vallas on 1/19/16.
//  Copyright © 2016 Phoenix Labs.
//
//  All Rights Reserved.

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
        path = store.exportPath + "/HG_\(store.project.name)"
        exportEntity = ExportEntity(baseDir: path, licenseInfo: license)
        exportEnum = ExportEnum(baseDir: path, licenseInfo: license)
        exportExtensions = ExportExtensions(baseDir: path, store: store)
        exportProtocols = ExportProtocols(baseDir: path, projectName: projectName, licenseInfo: license)
        exportHGClasses = ExportHGClasses(baseDir: path, projectName: projectName, licenseInfo: license)
    }
    
    func export() {
        
        // create folder structure for export
        createBaseFolders()
        
        // create Entity Files
        for entity in store.project.entities {
            let _ = exportEntity.exportFile(forEntity: entity)
        }
        
        // create Store Enum Files
        for enuM in store.project.enums {
            let _ = exportEnum.exportFile(forEnum: enuM)
        }
        
        // create Extension Files
        let _ = exportExtensions.exportFiles()
        
        // create Protocol Files
        let _ = exportProtocols.exportFiles()
        
        // create HGClass Files
        let _ = exportHGClasses.exportFiles()
    }

    /// reads file in project, if there is an error, returns false
    static func read(file: String) -> String {
        
        let path = Bundle.main.path(forResource: file, ofType: "txt") ?? ""
        
        do  {
            // crash right away, you are looking for file that DNE
            let content = try String(contentsOfFile: path, encoding: String.Encoding.utf8)
            return content
        } catch {
            HGReportHandler.shared.report("ExportProject: can not unpackage \(file) from path \(path)", type: .error)
        }
        
        return ""
    }
    
    /// write to file, if there is an error, return false
    static func write(file: String, toPath path: String) -> Bool {
        
        do {
            try file.write(toFile: path, atomically: true, encoding: String.Encoding.utf8)
            return true
        } catch {
            HGReportHandler.shared.report("ExportProject: can not package \(file) to path \(path)", type: .error)
        }
        
        return false
    }
    
    func createBaseFolders() {
        
        // create base directory from path
        do {
            try FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: false, attributes: nil)
        } catch {
            // do nothing
        }
        
        // create sub folders in rest of path
        let _ = exportEntity.createBaseFolder()
        let _ = exportEnum.createBaseFolder()
        let _ = exportExtensions.createBaseFolder()
        let _ = exportProtocols.createBaseFolder()
        let _ = exportHGClasses.createBaseFolder()
    }
    
    
}
