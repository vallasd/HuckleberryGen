//
//  ExportProject.swift
//  HuckleberryGen
//
//  Created by David Vallas on 1/19/16.
//  Copyright © 2016 Phoenix Labs. All rights reserved.
//

import Cocoa

class ExportProject {
    
    let path: String
    let store: HuckleberryGen
    let exportEntity: ExportEntity
    let exportEnum: ExportEnum
    let exportExtensions: ExportExtensions
    
    init(store: HuckleberryGen) {
        self.store = store
        let license = store.licenseInfo
        path = store.exportPath + "/\(store.project.name)"
        exportEntity = ExportEntity(baseDir: path, licenseInfo: license)
        exportEnum = ExportEnum(baseDir: path, licenseInfo: license)
        exportExtensions = ExportExtensions(baseDir: path, store: store)
    }
    
    func export() {
        
        // create folder structure for export
        createBaseFolders()
        
        // create Entity Files
        for entity in store.project.entities { exportEntity.exportFile(forEntity: entity) }
        
        // create Enum Files
        for enuM in store.project.enums { exportEnum.exportFile(forEnum: enuM) }
        
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
        
//        let entities = baseDirectory + "/Entities"
//        let enums = baseDirectory + "/Enums"
//        let errors = baseDirectory + "/Errors"
//        let extensions = baseDirectory + "/Extensions"
//        let options = baseDirectory + "/Options"
//        let protocols = baseDirectory + "/Protocols"
//
    }
    
    
}