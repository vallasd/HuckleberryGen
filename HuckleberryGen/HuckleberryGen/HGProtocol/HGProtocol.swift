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
    var encode: AnyObject { get }
    static func decode(object object: AnyObject) -> Self
}

extension HGEncodable {
    
    static func decodeArray(objects objects: [AnyObject]) -> [Self] {
        var array: [Self] = []
        for object in objects {
            let decodedObject: Self = decode(object: object)
            array.append(decodedObject)
        }
        return array
    }
    
    func saveDefaults(key: String) {
        let encoded = self.encode
        NSUserDefaults.standardUserDefaults().setValue(encoded, forKey: key)
    }
    
    static func openDefaults(key: String) -> Self? {
        let defaults = NSUserDefaults.standardUserDefaults()
        if let object = defaults.objectForKey(key) {
            let decoded = Self.decode(object: object)
            return decoded
        }
        return nil
    }
}

extension SequenceType where Generator.Element: HGEncodable {
    
    var encode: [AnyObject] {
        var jsonArray: [AnyObject] = []
        for encodable in self { jsonArray.append(encodable.encode) }
        return jsonArray
    }
    
}

//extension SequenceType where Generator.Element: HGDICT {
//    
//    var decodeJSON: [HGEncodable] {
//        var jsonArray: [HGEncodable]
//        for dict in self { jsonArray.append(hgencodable.json) }
//        return jsonArray
//    }
//}

extension Optional {
    
    // Should set stuff for NSCoder Optionals as well
    func saveDefaults(key: String) {
        if let encodable = self as? HGEncodable { encodable.saveDefaults(key) }
        else if let string = self as? String { NSUserDefaults.standardUserDefaults().setValue(string, forKey: key) }
        else { NSUserDefaults.standardUserDefaults().removeObjectForKey(key) }
    }
}


