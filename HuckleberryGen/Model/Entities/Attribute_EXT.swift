//
//  Attribute_EXT.swift
//  HuckleberryGen
//
//  Created by David Vallas on 4/27/18.
//  Copyright © 2018 Phoenix Labs. All rights reserved.
//

import Cocoa

extension Attribute {
    
    var image: NSImage {
        return NSImage.image(named: "attributeIcon", title: name)
    }
    
//    var typeImage: NSImage {
//        switch type {
//        case .primitive: return NSImage.image(named: "typeIcon", title: name)
//        case .enuM: return NSImage.image(named: "enumIcon", title: name)
//        case .entity: return NSImage.image(named: "entityIcon", title: name)
//        }
//    }
}
