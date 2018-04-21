//
//  NSView.swift
//  HuckleberryGen
//
//  Created by David Vallas on 7/17/15.
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

extension NSView {
    
    /// adds a corner to the view
    func roundedCorner() {
        layer?.masksToBounds = true
        layer?.cornerRadius = 20.0
    }
    
    /// adds a shadow to the view's sides
    func dropshadow() {
        let shadow = NSShadow()
        shadow.shadowColor = NSColor.black
        shadow.shadowOffset = NSMakeSize(0, -10.0)
        shadow.shadowBlurRadius = 10.0
        self.wantsLayer = true
        self.shadow = shadow
    }
    
    /// creates a background panel for the view
    func addPanel(insets i: CGFloat) {
        let frame = getFrame(self.bounds, inset: i)
        let panel = NSView(frame: frame)
        panel.backgroundColor(HGColor.white)
        panel.roundedCorner()
        panel.dropshadow()
        panel.insert(inParent: self, below: nil, inset: i)
    }
    
    /// inserts a view below the subview provided.  If no subview is provided, will insert the view at the bottom of the parent views hierarchy.  The view will resize according to the parent views size.
    func insert(inParent p: NSView, below: NSView?, inset i: CGFloat) {
        frame = getFrame(p.bounds, inset: i)
        translatesAutoresizingMaskIntoConstraints = true
        p.addSubview(self, positioned: .below, relativeTo: below)
        frame.origin = origin(p, view: self)
        autoresizingMask = [.width, .height]
    }
    
    /// adds a view to be in the center of its parent, view will not resize with the parent
    func center(inParent p: NSView) {
        frame.origin = origin(p, view: self)
        autoresizingMask =  [.minXMargin,
                             .maxXMargin,
                             .minYMargin,
                             .maxYMargin]
        p.addSubview(self)
    }
    
    /// adds view to be the same size as its parent, view will resize with the parent
    func resize(inParent p: NSView) {
        frame = CGRect(x: 0, y: 0, width: p.frame.width, height: p.frame.height)
        translatesAutoresizingMaskIntoConstraints = true
        p.addSubview(self)
        frame.origin = origin(p, view: self)
        autoresizingMask = [.width, .height]
    }
    
    fileprivate func getFrame(_ bounds: CGRect, inset i: CGFloat) -> NSRect {
        let i2 = 2.0 * i
        return NSRect(x: i,
                      y: i,
                      width: bounds.size.width - i2,
                      height: bounds.size.height - i2)
    }
    
    fileprivate func origin(_ p: NSView, view: NSView) -> NSPoint {
        return NSMakePoint((p.bounds.width / 2.0) - (view.frame.width / 2.0),
                           (p.bounds.height / 2.0) - (view.frame.height / 2.0))
    }
    
    /// turns interaction on or off for all subviews in the view
    fileprivate func interaction(_ enabled: Bool) {
        for view in self.subviews {
            if let control = view as? NSControl { control.isEnabled = enabled }
            else { view.interaction(enabled) }
        }
    }
    
    /// sets background to an HGColor
    func backgroundColor(_ color: HGColor) {
        let layer = CALayer()
        layer.backgroundColor = color.cgColor()
        self.wantsLayer = true
        self.layer = layer
    }

    
    var imageRep: NSImage {
        
        isHidden = false
        wantsLayer = true
        
        let image = NSImage(size: bounds.size)
        image.lockFocus()
        let graphicsContext = NSGraphicsContext.current!
        let context = unsafeBitCast(graphicsContext.graphicsPort, to: CGContext.self)
        layer?.render(in: context)
        image.unlockFocus()
        return image
    }
    
}
