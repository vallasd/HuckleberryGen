//
//  HGUnwrap.swift
//  HuckleberryGen
//
//  Created by David Vallas on 1/26/16.
//  Copyright © 2016 Phoenix Labs. All rights reserved.
//

import Foundation

struct Unwrap {
    
    // different ways type can be unwrapped besides standard
    let type: Any.Type
    let returnString: String
    
    init(type: Any.Type, returnString: String) {
        self.type = type
        self.returnString = returnString
    }
    
    var formattedString: String {
        
        let string = "\(type)"
        print(string)
        
        return string
    }
}

//extension HGUnwrap: HGEncodable {
//    
//    static var new: HGUnwrap {
//        return HGUnwrap(type: Float.self, returnString: "")
//    }
//    
//    var encode: AnyObject {
//        var dict = HGDICT()
//        dict["type"] = editable
//        dict["returnString"] = name
//        dict["unwraps"] = unwraps
//        return dict
//    }
//    
//    static func decode(object object: AnyObject) -> HGUnwrap {
//        let dict = hgdict(fromObject: object, decoderName: "HGUnwrap")
//        let returnString = dict["returnString"].bool
//        let name = dict["name"].string
//        let unwraps = dict["unwraps"].stringArray
//        return HGType(editable: editable, name: name, unwraps: unwraps)
//    }
//}
