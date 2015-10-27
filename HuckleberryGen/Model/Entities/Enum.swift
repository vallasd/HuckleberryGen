//
//  Enum.swift
//  HuckleberryGen
//
//  Created by David Vallas on 8/19/15.
//  Copyright © 2015 Phoenix Labs. All rights reserved.
//

import Foundation

struct Enum {
    var name: String
    var cases: [EnumCase]
    
    static var new: Enum {
        return Enum(name: "New Enum", cases: [])
    }
}

extension Enum: HGEncodable {
    
    var encode: AnyObject {
        var dict = HGDICT()
        dict["name"] = name
        dict["cases"] = cases.encode
        return dict
    }
    
    static func decode(object object: AnyObject) -> Enum {
        let dict = hgdict(fromObject: object, decoderName: "Enum")
        let name = dict["name"].string
        let cases = dict["cases"].enumcases
        return Enum(name: name, cases: cases)
    }
}

extension Enum: Hashable { var hashValue: Int { return name.hashValue } }
extension Enum: Equatable {}; func ==(lhs: Enum, rhs: Enum) -> Bool { return lhs.name == rhs.name }
