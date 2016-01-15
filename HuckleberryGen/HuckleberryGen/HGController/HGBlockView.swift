//
//  HGBlockView.swift
//  HuckleberryGen
//
//  Created by David Vallas on 12/21/15.
//  Copyright © 2015 Phoenix Labs. All rights reserved.
//

import Cocoa

/// NSView that will block the background views from any mouseclicks or touches (mousedown)
class HGBlockView: NSView {
    
    override func mouseDown(theEvent: NSEvent) {
        // do nothing
    }
    
}