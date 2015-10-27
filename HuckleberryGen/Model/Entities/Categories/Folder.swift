//
//  DevFolder.swift
//  HuckleberryGen
//
//  Created by David Vallas on 7/11/15.
//  Copyright © 2015 Phoenix Labs. All rights reserved.
//

import Foundation

struct Folder {
    let name: String
    let path: String
    let importFiles: [ImportFile]
    
    static var new: Folder {
        return Folder(name: "New Folder", path: "/", importFiles: [] )
    }
    
    static func create(name name: String, path: String, completion: (newfolder: Folder) -> Void) {
        ImportFile.importFiles(path: path) { (importFiles) -> Void in
            completion(newfolder: Folder(name: name, path: path, importFiles: importFiles))
        }
    }
}

extension Folder: HGEncodable {
    
    var encode: AnyObject {
        var dict = HGDICT()
        dict["name"] = name
        dict["path"] = path
        dict["importFiles"] = importFiles.encode
        return dict
    }
    
    static func decode(object object: AnyObject) -> Folder {
        let dict = hgdict(fromObject: object, decoderName: "Folder")
        let name = dict["name"].string
        let path = dict["path"].string
        let importFiles = dict["importFiles"].importFiles
        return Folder(name: name, path: path, importFiles: importFiles)
    }
}