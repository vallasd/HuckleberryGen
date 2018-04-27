//
//  Enum.swift
//  HuckleberryGen
//
//  Created by David Vallas on 8/19/15.
//  Copyright © 2015 Phoenix Labs.
//
//  All Rights Reserved.


import Cocoa

struct Enum {
    
    let name: String
    var cases: [String]
    
    init(name: String) {
        self.name = name
        cases = []
    }
    
    init(name: String, cases: [String]) {
        self.name = name
        self.cases = cases
    }
    
    static func image(withName name: String) -> NSImage {
        return NSImage.image(named: "enumIcon", title: name)
    }
    
    var iteratedCase: String {
        return cases.iteratedVarRepresentable(string: "New Enum Case")
    }
}

extension Enum: HGEncodable {
    
    static var encodeError: Enum {
        return Enum(name: "Error")
    }
    
    var encode: Any {
        var dict = HGDICT()
        dict["name"] = name
        dict["cases"] = cases
        return dict as AnyObject
    }
    
    static func decode(object: Any) -> Enum {
        let dict = HG.decode(hgdict: object, decoderName: "Enum")
        let name = dict["name"].string
        let cases = dict["cases"].stringArray
        return Enum(name: name, cases: cases)
    }
}

extension Enum: Hashable { var hashValue: Int { return name.hashValue } }
extension Enum: Equatable {}; func ==(lhs: Enum, rhs: Enum) -> Bool { return lhs.name == rhs.name }
