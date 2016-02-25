//
//  HGEvent.swift
//  HuckleberryGen
//
//  Created by David Vallas on 8/19/15.
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

let HGUpArrowCharacter = 63232
let HGDownArrowCharacter = 63233
let HGLeftArrowCharacter = 63234
let HGRightArrowCharacter = 63235
let HGACharacter = 97

/// List of Available Commands For Huckleberry Gen App generated through Keyboard Interaction.
enum HGCocoaCommand {
    case None
    case AddRow
    case DeleteRow
    case NextRow
    case PreviousRow
    case TabLeft
    case TabRight

}

// List of Available Command Options For Huckleberry Gen App generated through Keyboard Interaction.
public struct HGCommandOptions : OptionSetType {
    
    public let rawValue: Int
    
    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
    
    public init() {
        self.rawValue = 0
    }
    
    static let MultiSelectOn = HGCommandOptions(rawValue: 1)
    // static let NextOption = HGCommandOptions(rawValue: 2)
    // static let NextOption = HGCommandOptions(rawValue: 4)
    // static let NextOption = HGCommandOptions(rawValue: 8)

}

extension NSEvent {
    
    /// Returns HGCommandOptions for an NSEvent by checking modifier flags to see which option keys (such as Command, Shift, etc) are pressed, returns appropriate Huckleberry Gen option commands to implement.  Use when checking a flagChanged Event.
    func commandOptions() -> HGCommandOptions {
        
        if self.modifierFlags.contains(NSEventModifierFlags.CommandKeyMask) {
            return .MultiSelectOn
        }
        
        return HGCommandOptions() // None
    }
    
    /// Returns HGCommand for an NSEvent by checking which key was pressed (such as "a", Delete, Tab) are pressed, returns appropriate Huckleberry Gen command to implement.  Use when checking a KeyDown Event.
    func command() -> HGCocoaCommand {
        
        if let scalars = self.charactersIgnoringModifiers?.unicodeScalars {
            let int = Int(scalars[scalars.startIndex].value)
//            Swift.print(int) // Check Value of Key
            switch int {
            case HGUpArrowCharacter: return .PreviousRow
            case HGDownArrowCharacter: return .NextRow
            case NSDeleteCharacter: return .DeleteRow
            case HGACharacter: return .AddRow
            case HGLeftArrowCharacter: return .TabLeft
            case HGRightArrowCharacter: return .TabRight
            default: return .None
            }
        }
        
        return .None
    }
}
