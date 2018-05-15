//
//  HGProtocol.swift
//  HuckleberryGen
//
//  Created by David Vallas on 1/28/16.
//  Copyright © 2016 Phoenix Labs.
//
//  All Rights Reserved.

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

extension Protocol: HGCodable {
    
    static var new: Protocol {
        return Protocol(name: "New Protocol")
    }
    
    static var encodeError: Protocol {
        return Protocol(name: "Error Protocol")
    }
    
    var encode: Any {
        var dict = HGDICT()
        dict["name"] = name as AnyObject?
        return dict as AnyObject
    }
    
    static func decode(object: Any) -> Protocol {
        let dict = HG.decode(hgdict: object, decoder: Protocol.self)
        let name = dict["name"].string
        return Protocol(name: name)
    }
}


enum HG_Protocol {
    
    case HGCodable
    
    static var set: [HG_Protocol] = [.HGCodable]
    
    var name: String {
        switch self {
        case .HGCodable: return "HGCodable"
        }
    }
}
