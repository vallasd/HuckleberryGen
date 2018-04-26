//
//  DevFolder.swift
//  HuckleberryGen
//
//  Created by David Vallas on 7/11/15.
//  Copyright © 2015 Phoenix Labs.
//
//  All Rights Reserved.

import Foundation



struct Folder {
    let name: String
    let path: String
    let importFiles: [ImportFile]
    
    static func create(name: String, path: String, completion: @escaping (_ newfolder: Folder) -> Void) {
        ImportFile.importFiles(path: path) { (importFiles) -> Void in
            completion(Folder(name: name, path: path, importFiles: importFiles))
        }
    }
}

extension Folder: HGEncodable {
    
    static var new: Folder {
        return Folder(name: "New Folder", path: "/", importFiles: [] )
    }
    
    var encode: AnyObject {
        var dict = HGDICT()
        dict["name"] = name as AnyObject?
        dict["path"] = path as AnyObject?
        dict["importFiles"] = importFiles.encode as AnyObject
        return dict as AnyObject
    }
    
    static func decode(object: AnyObject) -> Folder {
        let dict = HG.decode(hgdict: object, decoderName: "Folder")
        let name = dict["name"].string
        let path = dict["path"].string
        let importFiles = dict["importFiles"].importFiles
        return Folder(name: name, path: path, importFiles: importFiles)
    }
}
