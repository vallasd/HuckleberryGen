//
//  HGProtocol.swift
//  HuckleberryGen
//
//  Created by David Vallas on 1/28/16.
//  Copyright © 2016 Phoenix Labs.
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

//  You should have received a copy of the GNU General Public License
//  along with HuckleberryGen.  If not, see <http://www.gnu.org/licenses/>.

import Foundation

struct Protocol {
    
    var name: String
    
    init(name: String) {
        self.name = name
    }
    
    init(proto: HG_Protocol) {
        self.name = proto.name
    }
}

extension Protocol {
    
    static func genericProtocols() -> [Protocol] {
        
        var generics: [Protocol] = []
        
        for proto in HG_Protocol.set {
            generics.append(Protocol(proto: proto))
        }
        
        return generics
    }
}

extension Protocol: HGEncodable {
    
    static var new: Protocol {
        return Protocol(name: "New Protocol")
    }
    
    var encode: AnyObject {
        var dict = HGDICT()
        dict["name"] = name
        return dict
    }
    
    static func decode(object object: AnyObject) -> Protocol {
        let dict = hgdict(fromObject: object, decoderName: "Enum")
        let name = dict["name"].string
        return Protocol(name: name)
    }
}


extension Protocol: TypeRepresentable {
    
    var typeRep: String { return name.typeRepresentable }
    
}

extension Protocol: VarRepresentable {
    
    var varRep: String { return name.varRepresentable }
}


enum HG_Protocol {
    
    case HGEncodable
    
    static var set: [HG_Protocol] = [.HGEncodable]
    
    var name: String {
        switch self {
        case .HGEncodable: return "HGEncodable"
        }
    }
}