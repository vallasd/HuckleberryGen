//
//  NSImage.swift
//  HuckleberryGen
//
//  Created by David Vallas on 10/1/15.
//  Copyright © 2015 Phoenix Labs. All rights reserved.
//

import Cocoa

extension NSImage {
    
    /// Returns an image that has a title displayed in bottom half of icon
    static func image(named name: String, title: String) -> NSImage {
        let image = NSImage(named: name)!
        let width = image.size.width
        let height = image.size.height
        let labelWidth = width * 0.9
        let labelHeight = height * 0.50
        let view = NSImageView(frame: NSRect(x: 0, y: 0, width: width, height: height))
        let label = NSTextField(frame: NSRect(x: (width - labelWidth) / 2.0, y: 0, width: labelWidth, height: labelHeight))
        let font = NSFont.systemFontOfSize(labelWidth * 0.20)
        label.alignment = .Center
        label.font = font
        label.bezeled = false
        label.drawsBackground = false
        label.editable = false
        label.selectable = false
        label.stringValue = title
        view.image = image
        view.addSubview(label)
        return view.imageRep
    }
    
    
    
    
    
}
