//
//  ModelEntity.swift
//  HuckleberryGen
//
//  Created by David Vallas on 7/11/15.
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

enum ImportFileType: Int16 {
    case XCODE_XML = 0
    
    var int: Int {
        return Int(self.rawValue)
    }
    
    static func create(int int: Int) -> ImportFileType {
        switch int {
        case 0: return .XCODE_XML
        default:
            HGReportHandler.shared.report("int: |\(int)| is not an ImportFileType mapable, using .XCODE_XML", type: .Error)
            return .XCODE_XML
        }
    }
}

struct ImportFile {
    
    let name: String
    let lastUpdate: NSDate
    let modificationDate: NSDate
    let creationDate: NSDate
    let path: String
    let type: ImportFileType
    
    static func importFiles(path path: String, completion: (importFiles: [ImportFile]) -> Void) {
        HGFileQuery.shared.importFiles(forPath: path) { (importFiles) -> Void in completion(importFiles: importFiles) }
    }
    
    func save(key: String) {
        NSUserDefaults.standardUserDefaults().setValue(self.encode, forKey: key)
    }
    
    static func open(key: String) -> ImportFile? {
        let defaults = NSUserDefaults.standardUserDefaults()
        if let dict = defaults.objectForKey(key) as? HGDICT {
            return ImportFile.decode(object: dict)
        }
        return nil
    }
}


extension ImportFile: Hashable { var hashValue: Int { return path.hashValue } }
extension ImportFile: Equatable {}; func ==(lhs: ImportFile, rhs: ImportFile) -> Bool { return lhs.path == rhs.path }


extension ImportFile: HGEncodable {
    
    static var new: ImportFile {
        let date = NSDate()
        return ImportFile(name: "", lastUpdate: date, modificationDate: date, creationDate: date, path: "", type: .XCODE_XML)
    }
    
    var encode: AnyObject {
        var dict = HGDICT()
        dict["name"] = name
        dict["lastUpdate"] = lastUpdate.timeIntervalSince1970
        dict["modificationDate"] = modificationDate.timeIntervalSince1970
        dict["creationDate"] = creationDate.timeIntervalSince1970
        dict["path"] = path
        dict["type"] = type.int
        return dict
    }
    
    static func decode(object object: AnyObject) -> ImportFile {
        let dict = hgdict(fromObject: object, decoderName: "ImportFile")
        let name = dict["name"] as! String
        let lastUpdate = dict["lastUpdate"].interval.date()
        let modificationDate = dict["modificationDate"].interval.date()
        let creationDate = dict["creationDate"].interval.date()
        let path = dict["path"].string
        let type = dict["type"].importFileType
        return ImportFile(name: name, lastUpdate: lastUpdate, modificationDate: modificationDate, creationDate: creationDate, path: path, type: type)
    }
}