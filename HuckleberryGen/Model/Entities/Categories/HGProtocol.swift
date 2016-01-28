//
//  HGProtocol.swift
//  HuckleberryGen
//
//  Created by David Vallas on 1/28/16.
//  Copyright © 2016 Phoenix Labs. All rights reserved.
//

import Foundation

struct HGProtocol {
    
    var name: String
    
//    init(name: String) {
//        self.name = name
//    }
    
}

extension HGProtocol: HGEncodable {
    
    static var new: HGProtocol {
        return HGProtocol(name: "New Protocol")
    }
    
    var encode: AnyObject {
        var dict = HGDICT()
        dict["name"] = name
        return dict
    }
    
    static func decode(object object: AnyObject) -> HGProtocol {
        let dict = hgdict(fromObject: object, decoderName: "Enum")
        let name = dict["name"].string
        return HGProtocol(name: name)
    }
}


extension HGProtocol: HGTypeRepresentable {
    
    func typeRep() -> String { return name.typeRepresentable }
}

extension HGProtocol: HGVarRepresentable {
    
    func varRep() -> String { return name.varRepresentable }
    func varArrayRep() -> String { return name.varArrayRepresentable }
}
