//
//  HGType.swift
//  HuckleberryGen
//
//  Created by David Vallas on 4/25/18.
//  Copyright © 2018 Phoenix Labs. All rights reserved.
//

import Foundation

enum HGType: Int, HGEncodable {
    
    case primitive = 0
    case enuM = 1
    case entity = 2
    
    // MARK - HGEncodable
    
    static var encodeError: HGType {
        return .primitive
    }
    
    var encode: Any {
        return self.rawValue
    }
    
    static func decode(object: Any) -> HGType {
        let int: Int = HG.decode(int: object, decoderName: "HGType")
        return int.hGType
    }
    
    
}

