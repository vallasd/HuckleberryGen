//
//  EnumCase.swift
//  HuckleberryGen
//
//  Created by David Vallas on 9/22/15.
//  Copyright © 2015 Phoenix Labs.
//
//  All Rights Reserved.

import Foundation

struct EnumCase {
    
    /// string representation of enum's case.  case .caseRep:
    var string: String
    
    init(string: String) {
        self.string = string
    }
}

extension EnumCase: HGEncodable {
    
    static var new: EnumCase {
        return EnumCase(string: "New Case")
    }
    
    var encode: AnyObject {
        var dict = HGDICT()
        dict["string"] = string as AnyObject?
        return dict as AnyObject
    }
    
    static func decode(object: AnyObject) -> EnumCase {
        let dict = hgdict(fromObject: object, decoderName: "EnumCase")
        let name = dict["string"].string
        return EnumCase(string: name)
    }
}

extension EnumCase: TypeRepresentable {
    
    var typeRep: String { return string.typeRepresentable }
}

extension EnumCase: VarRepresentable {
    
    var varRep: String { return string.varRepresentable }
}

extension EnumCase: Hashable { var hashValue: Int { return string.hashValue } }
extension EnumCase: Equatable {}; func ==(lhs: EnumCase, rhs: EnumCase) -> Bool { return lhs.string == rhs.string }
