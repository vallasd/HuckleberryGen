//
//  EnumCase.swift
//  HuckleberryGen
//
//  Created by David Vallas on 9/22/15.
//  Copyright © 2015 Phoenix Labs. All rights reserved.
//

import Foundation

struct EnumCase {
    var name: String
    
    init(name: String) {
        self.name = name
    }
}

extension EnumCase: HGEncodable {
    
    static var new: EnumCase {
        return EnumCase(name: "New Case")
    }
    
    var encode: AnyObject {
        var dict = HGDICT()
        dict["name"] = name
        return dict
    }
    
    static func decode(object object: AnyObject) -> EnumCase {
        let dict = hgdict(fromObject: object, decoderName: "EnumCase")
        let name = dict["name"].string
        return EnumCase(name: name)
    }
}

extension EnumCase: Hashable { var hashValue: Int { return name.hashValue } }
extension EnumCase: Equatable {}; func ==(lhs: EnumCase, rhs: EnumCase) -> Bool { return lhs.name == rhs.name }