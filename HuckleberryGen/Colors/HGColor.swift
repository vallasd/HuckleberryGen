//
//  HGColor.swift
//  HuckleberryGen
//
//  Created by David Vallas on 7/16/15.
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

enum HGColor {
    
    case grey
    case white
    case whiteTranslucent
    case clear
    case black
    case purple
    case cyan
    case blue
    case blueBright
    case red
    case green
    case orange
    
    
    func cgColor() -> CGColor {
        switch (self) {
        case .grey: return CGColor(red: 0.75, green: 0.75, blue: 0.75, alpha: 1.0)
        case .white: return CGColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        case .whiteTranslucent: return CGColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.75)
        case .clear: return CGColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.0)
        case .black: return CGColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
        case .purple: return CGColor(red: 0.36, green: 0.15, blue: 0.60, alpha: 1.0)
        case .cyan: return CGColor(red: 0.67, green: 0.05, blue: 0.57, alpha: 1.0)
        case .blue: return CGColor(red: 0.11, green: 0.00, blue: 0.81, alpha: 1.0)
        case .blueBright: return CGColor(red: 0.05, green: 0.05, blue: 1.00, alpha: 1.0)
        case .red: return CGColor(red: 0.77, green: 0.10, blue: 0.09, alpha: 1.0)
        case .green: return CGColor(red: 0.00, green: 0.45, blue: 0.00, alpha: 1.0)
        case .orange: return CGColor(red: 0.70, green: 0.40, blue: 0.20, alpha: 1.0)
        }
    }
    
    func color() -> NSColor {
        switch (self) {
        case .grey: return NSColor(calibratedRed: 0.75, green: 0.75, blue: 0.75, alpha: 1.0)
        case .white: return NSColor(calibratedRed: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        case .whiteTranslucent: return NSColor(calibratedRed: 1.0, green: 1.0, blue: 1.0, alpha: 0.75)
        case .clear: return NSColor(calibratedRed: 1.0, green: 1.0, blue: 1.0, alpha: 0.0)
        case .black: return NSColor(calibratedRed: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
        case .purple: return NSColor(calibratedRed: 0.36, green: 0.15, blue: 0.60, alpha: 1.0)
        case .cyan: return NSColor(calibratedRed: 0.67, green: 0.05, blue: 0.57, alpha: 1.0)
        case .blue: return NSColor(calibratedRed: 0.11, green: 0.00, blue: 0.81, alpha: 1.0)
        case .blueBright: return NSColor(calibratedRed: 0.05, green: 0.05, blue: 1.00, alpha: 1.0)
        case .red: return NSColor(calibratedRed: 0.77, green: 0.10, blue: 0.09, alpha: 1.0)
        case .green: return NSColor(calibratedRed: 0.00, green: 0.45, blue: 0.00, alpha: 1.0)
        case .orange: return NSColor(calibratedRed: 0.70, green: 0.40, blue: 0.20, alpha: 1.0)
        }
    }
}


