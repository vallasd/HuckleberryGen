//
//  EnumCase.swift
//  HuckleberryGen
//
//  Created by David Vallas on 9/22/15.
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
