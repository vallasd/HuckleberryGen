//
//  HGType.swift
//  HuckleberryGen
//
//  Created by David Vallas on 4/25/18.
//  Copyright © 2018 Phoenix Labs. All rights reserved.
//

import Foundation

enum HGType: Int8, HGCodable {
    
    case primitive = 0
    case enuM = 1
    case entity = 2
    case join = 3
    
    // MARK - HGCodable
    
    static var encodeError: HGType {
        return .primitive
    }
    
    var encode: Any {
        return Int(self.rawValue)
    }
    
    static func decode(object: Any) -> HGType {
        let int8 = HG.decode(int8: object, decoder: HGType.self)
        switch int8 {
        case 0: return .primitive
        case 1: return .enuM
        case 2: return .entity
        case 3: return .join
        default:
            HGReport.shared.report("int8: |\(int8)| is not |HGType| mapable, using .primitive", type: .error)
        }
        return .primitive
    }
    
    
}

