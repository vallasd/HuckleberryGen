//
//  HGEncodable.swift
//  HuckleberryGen
//
//  Created by David Vallas on 1/28/16.
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

protocol HGEncodable {
    var encode: AnyObject { get }
    static func decode(object: AnyObject) -> Self
}

protocol NewCreatable {
    static var new: Self { get }
}

extension HGEncodable {
    
    func encode(_ dict: inout HGDICT, key: String) {
        dict[key] = self.encode
    }
    
    /// decodes an array of objects into an array of [HGEncodable]
    static func decodeArray(objects: [AnyObject]) -> [Self] {
        var array: [Self] = []
        for object in objects {
            let decodedObject: Self = decode(object: object)
            array.append(decodedObject)
        }
        return array
    }
    
    /// encodes and saves an object to standard user defaults given a key
    func saveDefaults(_ key: String) {
        let encoded = self.encode
        UserDefaults.standard.setValue(encoded, forKey: key)
    }
    
    /// removes object with key from standard user defaults
    static func removeDefaults(_ key: String) {
        UserDefaults.standard.removeObject(forKey: key)
    }
    
    /// switches key names for object in standard user defaults
    static func switchDefaults(oldkey: String, newkey: String) {
        let project = UserDefaults.standard.value(forKey: oldkey)
        UserDefaults.standard.setValue(project, forKey: newkey)
        UserDefaults.standard.removeObject(forKey: oldkey)
    }
    
    /// opens and decodes object from standard user defaults given a key
    static func openDefaults(_ key: String, reportError: Bool) -> Self? {
        let defaults = UserDefaults.standard
        if let object = defaults.object(forKey: key) {
            let decoded = Self.decode(object: object as AnyObject)
            return decoded
        }
        HGReportHandler.shared.report("Open Defaults: Object with Key - \(key) was not found in user defaults, returning nil", type: .info)
        return nil
    }
}

//extension HGEncodable where Self : NewCreatable {
//    
//    /// opens and decodes object from standard user defaults given a key
//    static func openDefaults(key: String) -> Self {
//        let defaults = NSUserDefaults.standardUserDefaults()
//        if let object = defaults.objectForKey(key) {
//            let decoded = Self.decode(object: object)
//            return decoded
//        }
//        HGReportHandler.shared.report("Open Defaults: Object with Key - \(key) was not found in user defaults, returning new Object", type: .Info)
//        return self.new
//    }
//}

extension Sequence where Iterator.Element: HGEncodable {
    
    var encode: [AnyObject] {
        return self.map { $0.encode }
    }

}
