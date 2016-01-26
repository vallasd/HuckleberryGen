//
//  Enum.swift
//  HuckleberryGen
//
//  Created by David Vallas on 8/19/15.
//  Copyright © 2015 Phoenix Labs. All rights reserved.
//

import Cocoa

struct Enum {
    var editable: Bool
    var name: String
    var cases: [EnumCase]
    
    init(editable: Bool, name: String, cases: [EnumCase]) {
        self.editable = editable
        self.name = name
        self.cases = cases
    }
    
    static func image(withName name: String) -> NSImage {
        return NSImage.image(named: "enumIcon", title: name)
    }
}

// MARK: Generic Enum Definitions
extension Enum {

    static func genericEnums() -> [Enum] {
        
        var enums: [Enum] = []
        
        // generics are not editable
        let editable = false
        
        let error = "HGErrorType"
        let error1 = EnumCase(name: "Info")
        let error2 = EnumCase(name: "Warn")
        let error3 = EnumCase(name: "Error")
        let error4 = EnumCase(name: "Alert")
        let error5 = EnumCase(name: "Assert")
        let enum1 = Enum(editable: editable, name: error, cases: [error1, error2, error3, error4, error5])
        enums.append(enum1)
        
        return enums
    }
}

extension Enum: HGEncodable {
    
    static var new: Enum {
        return Enum(editable: true, name: "New Enum", cases: [EnumCase.new])
    }
    
    var encode: AnyObject {
        var dict = HGDICT()
        dict["editable"] = editable
        dict["name"] = name
        dict["cases"] = cases.encode
        return dict
    }
    
    static func decode(object object: AnyObject) -> Enum {
        let dict = hgdict(fromObject: object, decoderName: "Enum")
        let editable = dict["editable"].bool
        let name = dict["name"].string
        let cases = dict["cases"].enumcases
        return Enum(editable: editable, name: name, cases: cases)
    }
}

extension Enum: Hashable { var hashValue: Int { return name.hashValue } }
extension Enum: Equatable {}; func ==(lhs: Enum, rhs: Enum) -> Bool { return lhs.name == rhs.name }
