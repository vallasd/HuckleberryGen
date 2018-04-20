//
//  DevFolder.swift
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
        dict["importFiles"] = importFiles.encode
        return dict as AnyObject
    }
    
    static func decode(object: AnyObject) -> Folder {
        let dict = hgdict(fromObject: object, decoderName: "Folder")
        let name = dict["name"].string
        let path = dict["path"].string
        let importFiles = dict["importFiles"].importFiles
        return Folder(name: name, path: path, importFiles: importFiles)
    }
}
