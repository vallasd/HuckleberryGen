//
//  Project_Ext.swift
//  HuckleberryGen
//
//  Created by David Vallas on 5/18/18.
//  Copyright © 2018 Phoenix Labs. All rights reserved.
//

import Foundation

extension Project {
    
    func holderHasConnections(holderName: String) -> Bool {
        let primitives = primitiveAttributes.map { $0.holderName }.filter { $0 == holderName }
        if primitives.count > 0 { return true }
        let enums = enumAttributes.map { $0.holderName }.filter { $0 == holderName }
        if enums.count > 0 { return true }
        let entities = entityAttributes.map { $0.holderName }.filter { $0 == holderName }
        if entities.count > 0 { return true }
        return false
    }
    
    
    
}
