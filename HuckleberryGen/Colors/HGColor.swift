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
    case WhiteTranslucent
    case Clear
    case Purple
    case Cyan
    case Blue
    case BlueBright
    case Red
    case Green
    case Orange
    
    
    func cgColor() -> CGColorRef {
        switch (self) {
        case .Grey: return CGColorCreateGenericRGB(0.75, 0.75, 0.75, 1.0)
        case .White: return CGColorCreateGenericRGB(1.0, 1.0, 1.0, 1.0)
        case .WhiteTranslucent: return CGColorCreateGenericRGB(1.0, 1.0, 1.0, 0.75)
        case .Clear: return CGColorCreateGenericRGB(1.0, 1.0, 1.0, 0.0)
        case .Purple: return CGColorCreateGenericRGB(0.36, 0.15, 0.60, 1.0)
        case .Cyan: return CGColorCreateGenericRGB(0.67, 0.05, 0.57, 1.0)
        case .Blue: return CGColorCreateGenericRGB(0.11, 0.00, 0.81, 1.0)
        case .BlueBright: return CGColorCreateGenericRGB(0.05, 0.05, 1.00, 1.0)
        case .Red: return CGColorCreateGenericRGB(0.77, 0.10, 0.09, 1.0)
        case .Green: return CGColorCreateGenericRGB(0.00, 0.45, 0.00, 1.0)
        case .Orange: return CGColorCreateGenericRGB(0.70, 0.40, 0.20, 1.0)
        }
    }
    
    func color() -> NSColor {
        switch (self) {
        case .Grey: return NSColor(calibratedRed: 0.75, green: 0.75, blue: 0.75, alpha: 1.0)
        case .White: return NSColor(calibratedRed: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        case .WhiteTranslucent: return NSColor(calibratedRed: 1.0, green: 1.0, blue: 1.0, alpha: 0.75)
        case .Clear: return NSColor(calibratedRed: 1.0, green: 1.0, blue: 1.0, alpha: 0.0)
        case .Purple: return NSColor(calibratedRed: 0.36, green: 0.15, blue: 0.60, alpha: 1.0)
        case .Cyan: return NSColor(calibratedRed: 0.67, green: 0.05, blue: 0.57, alpha: 1.0)
        case .Blue: return NSColor(calibratedRed: 0.11, green: 0.00, blue: 0.81, alpha: 1.0)
        case .BlueBright: return NSColor(calibratedRed: 0.05, green: 0.05, blue: 1.00, alpha: 1.0)
        case .Red: return NSColor(calibratedRed: 0.77, green: 0.10, blue: 0.09, alpha: 1.0)
        case .Green: return NSColor(calibratedRed: 0.00, green: 0.45, blue: 0.00, alpha: 1.0)
        case .Orange: return NSColor(calibratedRed: 0.70, green: 0.40, blue: 0.20, alpha: 1.0)
        }
    }
}


