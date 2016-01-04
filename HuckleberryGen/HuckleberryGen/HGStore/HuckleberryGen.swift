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
    
    // MARK: Model Data
    
    private(set) var uniqIdentifier: String
    
    var licenseInfo: LicenseInfo
    
    var importFileSearchPath: String
    
    var project: Project {
        didSet {
            postProjectChangedNotifications()
        }
    }
    
    /// Checks defaults to see if a Huckleberry Gen was saved with same identifier and opens that data if available, else returns a blank project with identifier
    init(uniqIdentifier uniqID: String) {
        let file = HuckleberryGen.openDefaults(uniqID)
        uniqIdentifier = uniqID
        licenseInfo = file.licenseInfo
        importFileSearchPath = file.importFileSearchPath
        project = file.project
    }
    
    /// initializes Huckleberry Gen when user gives all data
    init(uniqIdentifier: String, licenseInfo: LicenseInfo, importFileSearchPath: String, project: Project) {
        self.uniqIdentifier = uniqIdentifier
        self.licenseInfo = licenseInfo
        self.importFileSearchPath = importFileSearchPath
        self.project = project
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
        return HuckleberryGen(uniqIdentifier: uuid, licenseInfo: LicenseInfo.new, importFileSearchPath: "/", project: Project.new)
    }
    
    var encode: AnyObject {
        var dict = HGDICT()
        dict["uniqIdentifier"] = uniqIdentifier
        dict["licenseInfo"] = licenseInfo.encode
        dict["importFileSearchPath"] = importFileSearchPath
        dict["project"] = project.encode
        return dict
    }
    
    static func decode(object object: AnyObject) -> HuckleberryGen {
        let dict = hgdict(fromObject: object, decoderName: "HuckleberryGen")
        let uniqIdentifier = dict["uniqIdentifier"].string
        let licenseInfo = dict["licenseInfo"].licenseInfo
        let importFileSearchPath = dict["importFileSearchPath"].string
        let project = dict["project"].project
        return HuckleberryGen(uniqIdentifier: uniqIdentifier, licenseInfo: licenseInfo, importFileSearchPath: importFileSearchPath, project: project)
    }
}