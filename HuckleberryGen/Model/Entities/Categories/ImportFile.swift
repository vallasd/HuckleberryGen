//
//  ModelEntity.swift
//  HuckleberryGen
//
//  Created by David Vallas on 7/11/15.
//  Copyright © 2015 Phoenix Labs.
//
//  All Rights Reserved.

import Foundation
import CoreData

enum ImportFileType: Int16 {
    case xcode_XML = 0
    
    var int: Int {
        return Int(self.rawValue)
    }
    
    static func create(int: Int) -> ImportFileType {
        switch int {
        case 0: return .xcode_XML
        default:
            HGReportHandler.shared.report("int: |\(int)| is not an ImportFileType mapable, using .XCODE_XML", type: .error)
            return .xcode_XML
        }
    }
}

struct ImportFile {
    
    let name: String
    let lastUpdate: Date
    let modificationDate: Date
    let creationDate: Date
    let path: String
    let type: ImportFileType
    
    static func importFiles(path: String, completion: @escaping (_ importFiles: [ImportFile]) -> Void) {
        HGFileQuery.shared.importFiles(forPath: path) { (importFiles) -> Void in completion(importFiles) }
    }
    
    func save(_ key: String) {
        UserDefaults.standard.setValue(self.encode, forKey: key)
    }
    
    static func open(_ key: String) -> ImportFile? {
        let defaults = UserDefaults.standard
        if let dict = defaults.object(forKey: key) as? HGDICT {
            return ImportFile.decode(object: dict as AnyObject)
        }
        return nil
    }
}


extension ImportFile: Hashable { var hashValue: Int { return path.hashValue } }
extension ImportFile: Equatable {}; func ==(lhs: ImportFile, rhs: ImportFile) -> Bool { return lhs.path == rhs.path }


extension ImportFile: HGEncodable {
    
    static var new: ImportFile {
        let date = Date()
        return ImportFile(name: "", lastUpdate: date, modificationDate: date, creationDate: date, path: "", type: .xcode_XML)
    }
    
    var encode: AnyObject {
        var dict = HGDICT()
        dict["name"] = name as AnyObject?
        dict["lastUpdate"] = lastUpdate.timeIntervalSince1970 as AnyObject?
        dict["modificationDate"] = modificationDate.timeIntervalSince1970 as AnyObject?
        dict["creationDate"] = creationDate.timeIntervalSince1970 as AnyObject?
        dict["path"] = path as AnyObject?
        dict["type"] = type.int as AnyObject?
        return dict as AnyObject
    }
    
    static func decode(object: AnyObject) -> ImportFile {
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
