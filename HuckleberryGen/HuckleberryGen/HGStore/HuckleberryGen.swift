//
//  HuckleberryPiStore.swift
//  HuckleberryPi
//
//  Created by David Vallas on 6/24/15.
//  Copyright © 2015 Phoenix Labs. All rights reserved.
//

import Foundation
import CoreData

class HuckleberryGen {
    
    // MARK: Singleton Instance
    
    static let store = HuckleberryGen()
    
    // MARK: Cached Model
    
    var licenseInfo: LicenseInfo? {
        didSet { licenseInfo.saveDefaults(licenseInfoKey) }
    }
    
    var importFileSearchPath: String? {
        didSet { importFileSearchPath.saveDefaults(importFileSearchPathKey) }
    }
    
    var project: Project {
        didSet {
            HGNotif.shared.postNotificationForModelUpdate()
            project.saveDefaults(projectKey)
        }
    }
    
    // MARK: - Initialization
    
    init() {
        licenseInfo = LicenseInfo.openDefaults(licenseInfoKey)
        importFileSearchPath = NSUserDefaults.standardUserDefaults().objectForKey(importFileSearchPathKey) as? String
        if let proj = Project.openDefaults(projectKey) {
            project = proj
        } else {
            project = Project.new
        }
    }
    
    // MARK: NSUserDefaults
    
    let licenseInfoKey = "LICENSEKEY_123483818"
    let projectKey = "CURRENTPROJECT_123483818"
    let importFileSearchPathKey = "IMPORTFILESEARCHPATHKEY_123483818"
    
    func clearDefaults() {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.removeObjectForKey(licenseInfoKey)
        defaults.removeObjectForKey(importFileSearchPathKey)
        defaults.removeObjectForKey(projectKey)
        
        licenseInfo = nil
        importFileSearchPath = nil
        project = Project.new
    }
    
    func saveDefaults() {
        licenseInfo.saveDefaults(licenseInfoKey)
        project.saveDefaults(projectKey)
        importFileSearchPath.saveDefaults(importFileSearchPathKey)
    }
    
}
