//
//  HGEvent.swift
//  HuckleberryGen
//
//  Created by David Vallas on 8/19/15.
//  Copyright © 2015 Phoenix Labs. All rights reserved.
//

import Cocoa

let HGUpArrowCharacter = 63232
let HGDownArrowCharacter = 63233
let HGLeftArrowCharacter = 63234
let HGRightArrowCharacter = 63235
let HGACharacter = 97

enum HGCommand: Int {
    case HGCommandNone = 0
    case HGCommandAddRow = 1
    case HGCommandDeleteRow = 2
    case HGCommandNextRow = 3
    case HGCommandPreviousRow = 4
    case HGCommandTabLeft = 5
    case HGCommandTabRight = 6
}

extension NSEvent {
    
    func command() -> HGCommand {
        
        if let scalars = self.charactersIgnoringModifiers?.unicodeScalars {
            let int = Int(scalars[scalars.startIndex].value)
            // Swift.print(int) // Check Value of Key
            switch int {
            case HGUpArrowCharacter: return .HGCommandPreviousRow
            case HGDownArrowCharacter: return .HGCommandNextRow
            case NSDeleteCharacter: return .HGCommandDeleteRow
            case HGACharacter: return .HGCommandAddRow
            case HGLeftArrowCharacter: return .HGCommandTabLeft
            case HGRightArrowCharacter: return .HGCommandTabRight
            default: return .HGCommandNone
            }
        }
        
        return .HGCommandNone
    }
}

//case NSEnterCharacter: return .HGCommandEnter;
//case NSBackspaceCharacter: return .HGCommandBackspace
//case NSTabCharacter: return .HGCommandTab
//case NSNewlineCharacter: return .HGCommandNewline
//case NSFormFeedCharacter: return .HGCommandFormFeed
//case NSCarriageReturnCharacter: return .HGCommandCarriageReturn
//case NSBackTabCharacter: return .HGCommandBackTab
//case NSDeleteCharacter: return .HGCommandDelete
//case NSLineSeparatorCharacter: return .HGCommandLineSeparator
//case NSParagraphSeparatorCharacter: return .HGCommandParagraphSeparator
