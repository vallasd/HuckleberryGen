//
//  HGProtocol.swift
//  HuckleberryGen
//
//  Created by David Vallas on 1/28/16.
//  Copyright © 2016 Phoenix Labs. All rights reserved.
//

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


extension Protocol: HGTypeRepresentable {
    
    func typeRep() -> String { return name.typeRepresentable }
    
}

extension Protocol: HGVarRepresentable {
    
    func varRep() -> String { return name.varRepresentable }
    func varArrayRep() -> String { return name.varArrayRepresentable }
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