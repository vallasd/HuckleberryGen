//
//  NSImage.swift
//  HuckleberryGen
//
//  Created by David Vallas on 10/1/15.
//  Copyright © 2015 Phoenix Labs.
//
//  All Rights Reserved.

import Cocoa

extension NSImage {
    
    /// Returns an image that has a title displayed in bottom half of icon
    static func image(named name: String, title: String) -> NSImage {
        let image = NSImage(named: NSImage.Name(rawValue: name))!
        let width = image.size.width
        let height = image.size.height
        let labelWidth = width * 0.9
        let labelHeight = height * 0.50
        let view = NSImageView(frame: NSRect(x: 0, y: 0, width: width, height: height))
        let label = NSTextField(frame: NSRect(x: (width - labelWidth) / 2.0, y: 0, width: labelWidth, height: labelHeight))
        let font = NSFont.systemFont(ofSize: labelWidth * 0.20)
        label.alignment = .center
        label.font = font
        label.textColor = HGColor.blue.color()
        label.isBezeled = false
        label.drawsBackground = false
        label.isEditable = false
        label.isSelectable = false
        label.stringValue = title
        view.image = image
        view.addSubview(label)
        return view.imageRep
    }
}
