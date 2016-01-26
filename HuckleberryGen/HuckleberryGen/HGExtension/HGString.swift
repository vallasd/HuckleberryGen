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
    
    
    /// returns an indexed list of iterated objects that match string in a set of string objects.  Example, string is "New Case", iterated objects are ["Hello", "New Case 2", "Bleepy", "new case 3", "New Case"].  Function will return ["New Case", "New Case 2"].  This search is case sensitive.
    func iteratedObjects(objects: [String]) -> [String] {
        
        // TODO: Implement Function
        
        return []
    }
    
    
    /// adds a space and number to end of string. If number does not exist, adds 1, if number exists, add next number.
    var iterated: String {
        
        let stringArray = self.characters.split(" ").map(String.init)
        
        // is not already iterated, return with 2
        if stringArray.count <= 1 {
            return self + " 2"
        }
        
        // is already iterated, return new string with 1 added to number
        if var int = Int(stringArray.last!) {
            int += 1
            let indexes = stringArray.count - 2
            var newString = ""
            for index in 0...indexes {
                newString += stringArray[index]
            }
            newString = newString + " \(int)"
        }
        
        // is not already iterated, return with 2
        return self + " 2"
    }
    
    /// makes first letter of string lower case
    var lowerCaseFirstLetter: String {
        if self.isEmpty { return "" }
        var string = self
        let firstChar = String(string.characters.first!).lowercaseString
        string.replaceRange(string.startIndex...string.startIndex, with: firstChar)
        return string
    }
    
    /// makes first letter of string lower case and appends "Array" to the end of string
    var lowerCaseFirstLetterAndArray: String {
        
        if self.isEmpty { return "" }
        
        let string = self.lowerCaseFirstLetter
        
        return string + "Array"
    }
}