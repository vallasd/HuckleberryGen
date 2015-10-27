//
//  HGColor.swift
//  HuckleberryGen
//
//  Created by David Vallas on 7/16/15.
//  Copyright © 2015 Phoenix Labs. All rights reserved.
//

import Cocoa

enum HGColor {
    case Grey
    case White
    case Blue
    case Clear
    
    func cgColor() -> CGColorRef {
        switch (self) {
        case .Grey: return CGColorCreateGenericRGB(0.75, 0.75, 0.75, 1.0)
        case .White: return CGColorCreateGenericRGB(1.0, 1.0, 1.0, 1.0)
        case .Blue: return CGColorCreateGenericRGB(0.0, 0.48, 1.0, 1.0)
        case .Clear: return CGColorCreateGenericRGB(1.0, 1.0, 1.0, 0.0)
        }
    }
    
    func color() -> NSColor {
        switch (self) {
        case .Grey: return NSColor(calibratedRed: 0.75, green: 0.75, blue: 0.75, alpha: 1.0)
        case .White: return NSColor(calibratedRed: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        case .Blue: return NSColor(calibratedRed: 0.0, green: 0.0, blue: 1.0, alpha: 1.0)
        case .Clear: return NSColor(calibratedRed: 1.0, green: 1.0, blue: 1.0, alpha: 0.0)
        }
    }
}


