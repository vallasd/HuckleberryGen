//
//  NSView.swift
//  HuckleberryGen
//
//  Created by David Vallas on 7/17/15.
//  Copyright © 2015 Phoenix Labs. All rights reserved.
//

import Cocoa

extension NSView {
    
    func center(parent parent: NSView) {
        self.frame.origin = NSMakePoint((parent.bounds.width / 2.0) - (self.frame.width / 2.0), (parent.bounds.height / 2.0) - (self.frame.height / 2.0))
        self.autoresizingMask =  [.ViewMinXMargin, .ViewMaxXMargin, .ViewMinYMargin, .ViewMaxYMargin]
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