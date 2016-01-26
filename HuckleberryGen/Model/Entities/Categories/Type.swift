//
//  HGType.swift
//  HuckleberryGen
//
//  Created by David Vallas on 1/26/16.
//  Copyright © 2016 Phoenix Labs. All rights reserved.
//

import Cocoa

struct Type {
    
    var editable: Bool
    var name: String
    
    // different ways type can be unwrapped besides standard
    var unwraps: [String]
    
    init(editable: Bool, name: String, unwraps: [String]) {
        self.editable = editable
        self.name = name
        self.unwraps = unwraps
    }
    
    var image: NSImage {
        return NSImage.image(named: "typeIcon", title: name)
    }
}

// MARK: Generic HGType Definitions
extension Type {
    
    static func genericTypes() -> [Type] {
        
        var types: [Type] = []
        
        let bool = Type(editable: false, name: "Bool", unwraps: [])
        types.append(bool)
        
        let int = Type(editable: false, name: "Int", unwraps: [])
        let intUnwrap1 = Unwrap(type: Float.self, returnString: "")
        
        intUnwrap1.formattedString
        
        types.append(int)
        
        let int16 = Type(editable: false, name: "Int16", unwraps: [])
        types.append(int16)
        
        let int32 = Type(editable: false, name: "Int32", unwraps: [])
        types.append(int32)
        
        let float = Type(editable: false, name: "Float", unwraps: [])
        types.append(float)
        
        let double = Type(editable: false, name: "Double", unwraps: [])
        types.append(double)
        
        let interval = Type(editable: false, name: "Interval", unwraps: [])
        types.append(interval)
        
        let date = Type(editable: false, name: "NSDate", unwraps: [])
        types.append(date)
        
        return types
    }
}

extension Type: HGEncodable {
    
    static var new: Type {
        return Type(editable: true, name: "New Type", unwraps: [])
    }
    
    var encode: AnyObject {
        var dict = HGDICT()
        dict["editable"] = editable
        dict["name"] = name
        dict["unwraps"] = unwraps
        return dict
    }
    
    static func decode(object object: AnyObject) -> Type {
        let dict = hgdict(fromObject: object, decoderName: "HGType")
        let editable = dict["editable"].bool
        let name = dict["name"].string
        let unwraps = dict["unwraps"].stringArray
        return Type(editable: editable, name: name, unwraps: unwraps)
    }
}

extension Type: Hashable { var hashValue: Int { return name.hashValue } }
extension Type: Equatable {}; func ==(lhs: Type, rhs: Type) -> Bool { return lhs.name == rhs.name }