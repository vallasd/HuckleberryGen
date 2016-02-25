//
//  NSEvent.swift
//  HuckleberryGen
//
//  Created by David Vallas on 12/21/15.
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

extension NSEvent {
    
    func fullDescription() -> String {
        
        return "NSEvent **** \n type \(self.type) \n modifierFlags \(self.modifierFlags) \n timestamp \(self.timestamp) \n window \(self.window) \n windowNumber \(self.windowNumber) \n context \(self.context) \n clickCount \(self.clickCount) \n buttonNumber \(self.buttonNumber) \n eventNumber \(self.eventNumber) \n locationInWindow \(self.locationInWindow) \n deltaZ \(self.deltaZ) \n hasPreciseScrollingDeltas \(self.hasPreciseScrollingDeltas) \n subtype \(self.subtype) \n absoluteZ \(self.absoluteZ) \n type \(self.type) \n type \(self.type)"
    }

}