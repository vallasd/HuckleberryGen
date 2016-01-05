//
//  HGProtocol.swift
//  HuckleberryPi
//
//  Created by David Vallas on 6/23/15.
//  Copyright © 2015 Phoenix Labs. All rights reserved.
//

import Foundation
import CoreData

enum HGEntityDepth: Int {
    case Single = 1  // Just Attributes
    case Double = 2  // Attributes and One Level Of Relationships
    case Full = 3    // Attributes and All Levels of Relationships
}

protocol HGReportable {
    static var report: HGReport { get }
}

protocol HGEncodable {
    static var new: Self { get }
    var encode: AnyObject { get }
    static func decode(object object: AnyObject) -> Self
}

extension HGEncodable {
    
    /// decodes an array of objects into an array of [HGEncodable]
    static func decodeArray(objects objects: [AnyObject]) -> [Self] {
        var array: [Self] = []
        for object in objects {
            let decodedObject: Self = decode(object: object)
            array.append(decodedObject)
        }
        return array
    }
    
    /// encodes and saves an object to standard user defaults given a key
    func saveDefaults(key: String) {
        let encoded = self.encode
        NSUserDefaults.standardUserDefaults().setValue(encoded, forKey: key)
    }
    
    /// removes object with key from standard user defaults
    static func removeDefaults(key: String) {
        NSUserDefaults.standardUserDefaults().removeObjectForKey(key)
    }
    
    /// switches key names for object in standard user defaults
    static func switchDefaults(oldkey oldkey: String, newkey: String) {
        let project = NSUserDefaults.standardUserDefaults().valueForKey(oldkey)
        NSUserDefaults.standardUserDefaults().setValue(project, forKey: newkey)
        NSUserDefaults.standardUserDefaults().removeObjectForKey(oldkey)
    }
    
    /// opens and decodes object from standard user defaults given a key
    static func openDefaults(key: String) -> Self {
        let defaults = NSUserDefaults.standardUserDefaults()
        if let object = defaults.objectForKey(key) {
            let decoded = Self.decode(object: object)
            return decoded
        }
        HGReportHandler.report("Open Defaults: Object with Key - \(key) was not found in user defaults, returning new Object", response: .Info)
        return self.new
    }
}

extension SequenceType where Generator.Element: HGEncodable {
    
    var encode: [AnyObject] {
        var jsonArray: [AnyObject] = []
        for encodable in self { jsonArray.append(encodable.encode) }
        return jsonArray
    }
    
}
