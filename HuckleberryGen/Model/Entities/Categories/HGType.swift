//
//  HGType.swift
//  HuckleberryGen
//
//  Created by David Vallas on 1/26/16.
//  Copyright © 2016 Phoenix Labs. All rights reserved.
//

import Cocoa

struct HGType {
    
    var editable: Bool
    var name: String
    
    // different ways type can be unwrapped besides standard
    var unwraps: [String]
    
    init(editable: Bool, name: String, unwraps: [String]) {
        self.editable = editable
        self.name = name
        self.unwraps = unwraps
    }
    
    static func image(withName name: String) -> NSImage {
        return NSImage.image(named: "typeIcon", title: name)
    }
}

// MARK: Generic HGType Definitions
extension HGType {
    
    static func genericTypes() -> [HGType] {
        
        var types: [HGType] = []
        
        let float = HGType(editable: false, name: "Float", unwraps: [])
        types.append(float)
        
        
        
        return types
    }
}

extension HGType: HGEncodable {
    
    static var new: HGType {
        return HGType(editable: true, name: "New Type", unwraps: [])
    }
    
    var encode: AnyObject {
        var dict = HGDICT()
        dict["editable"] = editable
        dict["name"] = name
        dict["unwraps"] = unwraps
        return dict
    }
    
    static func decode(object object: AnyObject) -> HGType {
        let dict = hgdict(fromObject: object, decoderName: "Enum")
        let editable = dict["editable"].bool
        let name = dict["name"].string
        let unwraps = dict["unwraps"].stringArray
        return HGType(editable: editable, name: name, unwraps: unwraps)
    }
}

extension HGType: Hashable { var hashValue: Int { return name.hashValue } }
extension HGType: Equatable {}; func ==(lhs: HGType, rhs: HGType) -> Bool { return lhs.name == rhs.name }