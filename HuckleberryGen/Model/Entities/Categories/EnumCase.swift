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
    var number: Int
    
}

extension EnumCase: HGEncodable {
    
    static var new: EnumCase {
        return EnumCase(name: "New Case", number: 0)
    }
    
    var encode: AnyObject {
        var dict = HGDICT()
        dict["name"] = name
        dict["number"] = Int(number)
        return dict
    }
    
    static func decode(object object: AnyObject) -> EnumCase {
        let dict = hgdict(fromObject: object, decoderName: "EnumCase")
        let name = dict["name"].string
        let number = dict["number"].int
        return EnumCase(name: name, number: number)
    }
}

extension EnumCase: Hashable { var hashValue: Int { return number.hashValue } }
extension EnumCase: Equatable {}; func ==(lhs: EnumCase, rhs: EnumCase) -> Bool { return lhs.number == rhs.number }