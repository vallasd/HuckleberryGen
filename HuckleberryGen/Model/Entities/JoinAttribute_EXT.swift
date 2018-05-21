//
//  JoinAttribute_EXT.swift
//  HuckleberryGen
//
//  Created by David Vallas on 5/21/18.
//  Copyright © 2018 Phoenix Labs. All rights reserved.
//

import Cocoa

extension JoinAttribute {
    
    var image: NSImage {
        return NSImage.image(named: "relationshipIcon", title: joinName)
    }
    
}

