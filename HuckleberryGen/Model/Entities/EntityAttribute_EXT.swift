//
//  EntityAttribute_EXT.swift
//  HuckleberryGen
//
//  Created by David Vallas on 4/30/18.
//  Copyright © 2018 Phoenix Labs. All rights reserved.
//

import Cocoa

extension EntityAttribute {
    
    var image: NSImage {
        return NSImage.image(named: "entityIcon", title: name)
    }
    
}
