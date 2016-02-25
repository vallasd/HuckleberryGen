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

//  You should have received a copy of the GNU General Public License
//  along with HuckleberryGen.  If not, see <http://www.gnu.org/licenses/>.

import Cocoa

extension NSView {
    
    func center(inParent p: NSView) {
        self.frame.origin = NSMakePoint((p.bounds.width / 2.0) - (self.frame.width / 2.0), (p.bounds.height / 2.0) - (self.frame.height / 2.0))
        self.autoresizingMask =  [.ViewMinXMargin, .ViewMaxXMargin, .ViewMinYMargin, .ViewMaxYMargin]
        p.addSubview(self)
    }
    
    func resize(inParent p: NSView) {
        self.frame = CGRect(x: 0, y: 0, width: p.frame.width, height: p.frame.height)
        self.translatesAutoresizingMaskIntoConstraints = true
        
        p.addSubview(self)
        
        self.frame.origin = NSMakePoint((p.bounds.width / 2.0) - (self.frame.width / 2.0), (p.bounds.height / 2.0) - (self.frame.height / 2.0))
        self.autoresizingMask = [.ViewWidthSizable, .ViewHeightSizable]
    }
    
    func disableInteraction() { self.interaction(false) }
    
    func enableInteraction() { self.interaction(true) }
    
    private func interaction(enabled: Bool) {
        for view in self.subviews {
            if let control = view as? NSControl { control.enabled = enabled }
            else { view.interaction(enabled) }
        }
    }
    
    func backgroundColor(color: HGColor) {
        let layer = CALayer()
        layer.backgroundColor = color.cgColor()
        self.wantsLayer = true
        self.layer = layer
    }

// Blur function was causing a memory leak
    
//    func blur() {
//        let blurFilter = CIFilter(name: "CIGaussianBlur")!
//        let blurredLayer = CALayer()
//        blurFilter.setDefaults()
//        blurFilter.setValue(1.0, forKey: kCIInputRadiusKey)
//        blurredLayer.backgroundFilters = [blurFilter]
//        blurredLayer.name = "NSViewBlurredLayer1725349360"
//        self.wantsLayer = true
//        self.layerUsesCoreImageFilters = true
//        self.layer?.addSublayer(blurredLayer)
//        self.disableInteraction()
//    }
//    
//    func unblur() {
//        if let layers = self.layer?.sublayers {
//            for layer in layers {
//                if layer.name == "NSViewBlurredLayer1725349360" {
//                    layer.removeFromSuperlayer()
//                }
//            }
//            self.wantsLayer = false
//            self.layerUsesCoreImageFilters = false
//            self.enableInteraction()
//        }
//    }
    
    func dropshadow() {
        let shadow = NSShadow()
        shadow.shadowColor = NSColor.blackColor()
        shadow.shadowOffset = NSMakeSize(0, -10.0)
        shadow.shadowBlurRadius = 10.0
        
        self.wantsLayer = true
        self.shadow = shadow
    }

    var imageRep: NSImage {
        
        hidden = false
        wantsLayer = true
        
        let image = NSImage(size: bounds.size)
        image.lockFocus()
        let graphicsContext = NSGraphicsContext.currentContext()!
        let context = unsafeBitCast(graphicsContext.graphicsPort, CGContext.self)
        layer?.renderInContext(context)
        image.unlockFocus()
        return image
    }
    
}