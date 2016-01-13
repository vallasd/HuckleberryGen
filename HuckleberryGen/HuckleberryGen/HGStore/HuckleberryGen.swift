//
//  HuckleberryPiStore.swift
//  HuckleberryPi
//
//  Created by David Vallas on 6/24/15.
//  Copyright © 2015 Phoenix Labs. All rights reserved.
//

import Foundation
import CoreData

final class HuckleberryGen {
    
    /// unique identifier for this Huckleberry Gen store
    private(set) var uniqIdentifier: String
    
    /// user and license info
    var licenseInfo: LicenseInfo
    
    /// the current search path for the XCODE files
    var importFileSearchPath: String
    
    /// the project that is currently opened
    var project: Project {
        didSet {
            postProjectChangedNotifications()
        }
    }
    
    /// a list of saved projects for this store
    private(set) var savedProjects: [String]
    
    /// Checks defaults to see if a Huckleberry Gen was saved with same identifier and opens that data if available, else returns a blank project with identifier
    init(uniqIdentifier uniqID: String) {
        let file = HuckleberryGen.openDefaults(uniqID)
        uniqIdentifier = uniqID
        licenseInfo = file.licenseInfo
        importFileSearchPath = file.importFileSearchPath
        project = file.project
        savedProjects = file.savedProjects
    }
    
    /// initializes Huckleberry Gen when user gives all data
    init(uniqIdentifier: String, licenseInfo: LicenseInfo, importFileSearchPath: String, project: Project, savedProjects: [String]) {
        self.uniqIdentifier = uniqIdentifier
        self.licenseInfo = licenseInfo
        self.importFileSearchPath = importFileSearchPath
        self.project = project
        self.savedProjects = savedProjects
    }
    
    /// clears all variables to default values
    func clear() {
        licenseInfo = LicenseInfo.new
        importFileSearchPath = "/"
        project = Project.new
    }
    
    /// saves HuckleberryGen file to user defaults
    func save() {
        self.saveDefaults(uniqIdentifier)
    }
    
    // MARK: Project Manipulation
    
    /// saves the current project to user defaults and creates a key
    func saveProject() {
        
        // determine what the project name either is or will be
        let projectName = project.name ?? "New Project \(NSDate().mmddyymmss)"
        
        // if project was not already named, name it and append it to savedProjects
        if project.name == nil {
            project.name = projectName
            savedProjects.append(projectName)
        }
        
        // create save key, this will always return a string because we know for sure that project has a name
        let key = project.saveKey(withUniqID: uniqIdentifier) as String!
        
        // save defaults
        project.saveDefaults(key)
    }
    
    /// deletes a project at index of savedProjects, return true if project was successfully deleted
    func deleteProject(atIndex index: Int) -> Bool {
    
        // index out of bounds
        if savedProjects.indices.contains(index) == false {
            HGReportHandler.report("savedProjects attempting to delete index that is out of bound", response: .Error)
            return false
        }
        
        // create save key, this will always return a string because we know for sure that project has a name
        let key = Project.saveKey(withUniqID: uniqIdentifier, name: savedProjects[index])
        
        // remove project from defaults
        Project.removeDefaults(key)
        
        // remove project from index
        savedProjects.removeAtIndex(index)
        
        return true
    }
    
    /// open a project at index of savedProjects, return true if project was successfully opened
    func openProject(atIndex index: Int) -> Bool {
        
        // index out of bounds
        if savedProjects.indices.contains(index) == false {
            HGReportHandler.report("savedProjects attempting to open index that is out of bound", response: .Error)
            return false
        }
        
        // create save key, this will always return a string because we know for sure that project has a name
        let key = Project.saveKey(withUniqID: uniqIdentifier, name: savedProjects[index])
        
        // opens project from defaults
        project = Project.openDefaults(key)
        
        return true
    }
    
    /// changes name of project at index of savedProjects to supplied, return true if project name was successfully changed
    func changeProject(atIndex index: Int, toName name: String) -> Bool {
        
        // index out of bounds
        if savedProjects.indices.contains(index) == false {
            HGReportHandler.report("savedProjects attempting to change index that is out of bounds", response: .Error)
            return false
        }
        
        // the name already exists
        if savedProjects.contains(name) {
            HGReportHandler.report("savedProjects already contains name, will not change name", response: .Error)
            return false
        }
    
        // create save keys
        let oldKey = Project.saveKey(withUniqID: uniqIdentifier, name: savedProjects[index])
        let newKey = Project.saveKey(withUniqID: uniqIdentifier, name: name)
        
        // switch the default stuff
        Project.switchDefaults(oldkey: oldKey, newkey: newKey)
        
        // change name at the index
        savedProjects[index] = name
        
        return true
    }
    
    
    // MARK: Notifications
    
    /// returns a store unique Notification Name for a particular HGNotifType
    func notificationName(forNotifType notif: HGNotifType) -> String {
        return notif.uniqString(forUniqId: uniqIdentifier)
    }
    
    /// posts a mass notification to every sub component when the project has changed
    private func postProjectChangedNotifications() {
        let notifs: [HGNotifType] = [.EntityUpdated, .EnumUpdated, .AttributeUpdated, .RelationshipUpdated, .EnumCaseUpdated]
        let posts = HGNotifType.uniqStrings(forNotifTypes: notifs, uniqID: uniqIdentifier)
        HGNotif.postNotifications(posts)
    }
}

extension HuckleberryGen: HGEncodable {
    
    static var new: HuckleberryGen {
        let uuid = NSUUID().UUIDString
        return HuckleberryGen(uniqIdentifier: uuid, licenseInfo: LicenseInfo.new, importFileSearchPath: "/", project: Project.new, savedProjects: [])
    }
    
    var encode: AnyObject {
        var dict = HGDICT()
        dict["uniqIdentifier"] = uniqIdentifier
        dict["licenseInfo"] = licenseInfo.encode
        dict["importFileSearchPath"] = importFileSearchPath
        dict["project"] = project.encode
        dict["savedProjects"] = savedProjects
        return dict
    }
    
    static func decode(object object: AnyObject) -> HuckleberryGen {
        let dict = hgdict(fromObject: object, decoderName: "HuckleberryGen")
        let uniqIdentifier = dict["uniqIdentifier"].string
        let licenseInfo = dict["licenseInfo"].licenseInfo
        let importFileSearchPath = dict["importFileSearchPath"].string
        let project = dict["project"].project
        let savedProjects = dict["savedProjects"].arrayString
        return HuckleberryGen(uniqIdentifier: uniqIdentifier, licenseInfo: licenseInfo, importFileSearchPath: importFileSearchPath, project: project, savedProjects: savedProjects)
    }
}