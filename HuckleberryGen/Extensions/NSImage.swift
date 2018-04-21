//
//  NSImage.swift
//  HuckleberryGen
//
//  Created by David Vallas on 10/1/15.
//  Copyright © 2015 Phoenix Labs.
//
//  This file is part of HuckleberryGen.
//
//  HuckleberryGen is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  HuckleberryGen is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with HuckleberryGen.  If not, see <http://www.gnu.org/licenses/>.

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
