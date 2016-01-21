//
//  HGString.swift
//  HuckleberryGen
//
//  Created by David Vallas on 8/13/15.
//  Copyright © 2015 Phoenix Labs. All rights reserved.
//

import Foundation
import Cocoa

extension String {
    
    static func random(length: Int) -> String {
    
        let allowedChars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let allowedCharsCount = UInt32(allowedChars.characters.count)
        var randString = ""
        
        for _ in 0..<length {
            let randNum = Int(arc4random_uniform(allowedCharsCount))
            let newChar = allowedChars[allowedChars.startIndex.advancedBy(randNum)]
            randString += String(newChar)
        }
        
        return randString
    }
    
    var stringByDeletingPathExtension: String {
        get {
            let nsstring = self as NSString
            return nsstring.stringByDeletingPathExtension
        }
    }
    
    var lastPathComponent: String {
        get {
            let nsstring = self as NSString
            return nsstring.lastPathComponent
        }
    }
    
    var lowerCaseFirstLetter: String {
        return ""
    }
}