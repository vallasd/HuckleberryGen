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
    
//    TODO: Change this to NSVisualEffectView or setup blur function for this window
    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    override init(frame frameRect: NSRect) {
//        super.init(frame: frameRect)
//        material = .MediumLight
//        
//    }
    
    override func mouseDown(theEvent: NSEvent) {
        // do nothing
    }
    
}