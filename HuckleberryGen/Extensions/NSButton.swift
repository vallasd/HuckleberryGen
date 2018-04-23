//
//  NSButton.swift
//  HuckleberryGen
//
//  Created by David Vallas on 4/21/18.
//  Copyright © 2018 Phoenix Labs. All rights reserved.
//

import Cocoa

extension NSButton {
    
    var copy: NSButton {
        let button = NSButton()
        button.setButtonType(.momentaryPushIn)
        button.bezelStyle = bezelStyle
        button.isBordered = isBordered
        button.imagePosition = imagePosition
        button.makeConstrainable()
        button.backgroundColor(.blue)
        return button
    }
    
    
}
