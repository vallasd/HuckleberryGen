//
//  HuckleberryPiStore.swift
//  HuckleberryPi
//
//  Created by David Vallas on 6/24/15.
//  Copyright © 2015 Phoenix Labs.
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
import CoreData

final class HuckleberryGen {
    
    /// unique identifier for this Huckleberry Gen store
    private(set) var uniqIdentifier: String
    
    /// user and license info
    var licenseInfo: LicenseInfo
    
    /// the current path for the XCODE files to import
    var importPath: String
    
    /// the current path for the exporting a Project
    var exportPath: String
    
    /// the project that is currently opened
    var project: Project {
        didSet {
            appDelegate.mainWindowController.window?.title = project.name
            postProjectChanged()
        }
    }
    
    /// a list of saved projects for this store
    private(set) var savedProjects: [String]
    
    /// Checks defaults to see if a Huckleberry Gen was saved with same identifier and opens that data if available, else returns a blank project with identifier
    init(uniqIdentifier uniqID: String) {
        let file = HuckleberryGen.openDefaults(uniqID, reportError: true) ?? HuckleberryGen.new
        uniqIdentifier = uniqID
        licenseInfo = file.licenseInfo
        importPath = file.importPath
        exportPath = file.exportPath
        project = file.project
        savedProjects = file.savedProjects
    }
    
    /// initializes Huckleberry Gen when user gives all data
    init(uniqIdentifier: String, licenseInfo: LicenseInfo, importPath: String, exportPath: String, project: Project, savedProjects: [String]) {
        self.uniqIdentifier = uniqIdentifier
        self.licenseInfo = licenseInfo
        self.importPath = importPath
        self.exportPath = exportPath
        self.project = project
        self.savedProjects = savedProjects
    }
    
    /// clears NSUserDefaults completely
    static func clear() {
        let appDomain = NSBundle.mainBundle().bundleIdentifier
        NSUserDefaults.standardUserDefaults().removePersistentDomainForName(appDomain!)
    }
    
    
    /// clears all variables to default values
    func clear() {
        let keys = Array(NSUserDefaults.standardUserDefaults().dictionaryRepresentation().keys)
        let storeKeys = keys.filter { $0.containsString(self.uniqIdentifier) }
        let defaults = NSUserDefaults.standardUserDefaults()
        
        print("Deleting storeKeys: \n\(storeKeys)")
        
        for key in storeKeys {
            defaults.removeObjectForKey(key)
        }
        
        licenseInfo = LicenseInfo.new
        importPath = ""
        exportPath = ""
        project = Project.new
    }
    
    /// saves HuckleberryGen file to user defaults
    func save() {
        self.saveDefaults(uniqIdentifier)
    }
    
    // MARK: Project Manipulation
    
    /// saves or overwrites a project to user defaults
    func saveProject(project: Project) {
        
        // if project was not already named, name it and append it to savedProjects
        if project.isNew {
            project.name = "New Project \(NSDate().mmddyymmss)"
            appDelegate.mainWindowController.window?.title = project.name
            savedProjects.append(project.name)
        }
        
        // create save key, this will always return a string because we know for sure that project has a name
        let key = project.saveKey(withUniqID: uniqIdentifier) as String!
        
        // save defaults
        project.saveDefaults(key)
    }
    
    /// saves the current project to user defaults and creates a key
    func saveCurrentProject() {
        
        // if project was not already named, name it and append it to savedProjects
        if project.isNew {
            project.name = "New Project \(NSDate().mmddyymmss)"
            appDelegate.mainWindowController.window?.title = project.name
            savedProjects.append(project.name)
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
            HGReportHandler.shared.report("savedProjects attempting to delete index that is out of bound", type: .Error)
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
            HGReportHandler.shared.report("savedProjects attempting to open index that is out of bound", type: .Error)
            return false
        }
        
        // create save key, this will always return a string because we know for sure that project has a name
        let key = Project.saveKey(withUniqID: uniqIdentifier, name: savedProjects[index])
        
        // opens project from defaults
        project =? Project.openDefaults(key, reportError: true)
        
        return true
    }
    
    /// changes name of project at index of savedProjects to supplied, return true if project name was successfully changed
    func changeCurrentProject(toName name: String) -> Bool {
        
        // set original name
        let originalName = project.name
        
        // remove original name
        if savedProjects.contains(originalName) {
            // remove original name and name from savedProjects if they exist
            savedProjects = savedProjects.filter { $0 != originalName && $0 != name }
        }
        
        // change name
        project.name = name
        
        // add new name to top of index
        savedProjects.insert(name, atIndex: 0)
        
        // update title bar
        appDelegate.mainWindowController.window?.title = project.name
    
        // create save keys
        let oldKey = Project.saveKey(withUniqID: uniqIdentifier, name: originalName)
        let key = project.saveKey(withUniqID: uniqIdentifier) as String!
        
        // delete old key
        Project.removeDefaults(oldKey)
        
        // save new key
        project.saveDefaults(key)
        
        return true
    }
    
    /// exports a project to a series of files and directories
    func exportProject() {
        print("Exporting the Project to \(exportPath)")
        let ep = ExportProject(store: self)
        ep.export()
    }
    
    
    // MARK: Notifications
    
    /// returns a store unique Notification Name for a particular HGNotifType
    func notificationNames(forNotifTypes notifs: [HGNotifType]) -> [String] {
        var names: [String] = []
        for notif in notifs {
            names.append(notif.uniqString(forUniqId: uniqIdentifier))
        }
        return names
    }
    
    /// returns a store unique Notification Name for a particular HGNotifType
    func notificationName(forNotifType notif: HGNotifType) -> String {
        return notif.uniqString(forUniqId: uniqIdentifier)
    }
    
    /// posts a notification that is unique to store
    func post(forNotifType notif: HGNotifType) {
        let uniqNotif = notificationName(forNotifType: notif)
        HGNotif.postNotification(uniqNotif)
    }
    
    /// posts a mass notification to every sub component when the project has changed
    private func postProjectChanged() {
        let notifType = HGNotifType.ProjectChanged
        let post = notifType.uniqString(forUniqId: uniqIdentifier)
        HGNotif.postNotification(post)
    }
}

extension HuckleberryGen: HGEncodable {
    
    static var new: HuckleberryGen {
        let uuid = NSUUID().UUIDString
        return HuckleberryGen(uniqIdentifier: uuid, licenseInfo: LicenseInfo.new, importPath: "/", exportPath: "/", project: Project.new, savedProjects: [])
    }
    
    var encode: AnyObject {
        var dict = HGDICT()
        dict["uniqIdentifier"] = uniqIdentifier
        dict["licenseInfo"] = licenseInfo.encode
        dict["importPath"] = importPath
        dict["exportPath"] = exportPath
        dict["project"] = project.encode
        dict["savedProjects"] = savedProjects
        return dict
    }
    
    static func decode(object object: AnyObject) -> HuckleberryGen {
        let dict = hgdict(fromObject: object, decoderName: "HuckleberryGen")
        let uniqIdentifier = dict["uniqIdentifier"].string
        let licenseInfo = dict["licenseInfo"].licenseInfo
        let importPath = dict["importPath"].string
        let exportPath = dict["exportPath"].string
        let project = dict["project"].project
        let savedProjects = dict["savedProjects"].stringArray
        return HuckleberryGen(uniqIdentifier: uniqIdentifier, licenseInfo: licenseInfo, importPath: importPath, exportPath: exportPath, project: project, savedProjects: savedProjects)
    }
}