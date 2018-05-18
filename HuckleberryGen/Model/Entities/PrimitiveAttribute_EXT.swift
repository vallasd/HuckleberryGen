//
//  PrimitiveAttribute_EXT.swift
//  HuckleberryGen
//
//  Created by David Vallas on 5/18/18.
//  Copyright © 2018 Phoenix Labs. All rights reserved.
//

import Cocoa

extension PrimitiveAttribute {
    
    var image: NSImage {
        return NSImage.image(named: "typeIcon", title: primitiveName)
    }
    
}
