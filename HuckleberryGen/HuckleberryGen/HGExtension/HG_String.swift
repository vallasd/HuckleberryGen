//
//  HGString.swift
//  HuckleberryGen
//
//  Created by David Vallas on 8/13/15.
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
    
    /// removes all characters
    func stripOutCharacterExcept(characters set: Set<Character>, fromString string: String) -> String {
        return String(string.characters.filter { set.contains($0) })
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
    
    /// returns string with quotes removed inside string
    var removeQuotes: String {
        let string = self.stringByReplacingOccurrencesOfString("\"", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
        return string
    }
    
    /// simple string, removes all characters besides caps, lower case, and spaces
    private var simple: String {
        let chars: Set<Character> = Set("abcdefghijklmnopqrstuvwxyz ABCDEFGHIJKLKMNOPQRSTUVWXYZ_1234567890".characters)
        return stripOutCharacterExcept(characters: chars, fromString: self)
    }
    
    /// returns a new string if change was made, else returns nil if the string is already TypeRepresentable
    var changeToTypeRep: String? {
        
        // trim
        var typeRep = self.trimmed
        
        // remove crap symbols, capitalize words and remove spaces
        typeRep = typeRep.simple.componentsSeparatedByString(" ").map { $0.capitalFirstLetter }.joinWithSeparator("")
        
        // if it is blank, make a New typeRep
        if self == "" || self == "_" {
            typeRep = "NewEntity"
        }
        
        // if type is still same as self, return nil
        if typeRep == self {
            return nil
        }
        
        return typeRep
    }
    
    /// returns a new string if change was made, else returns nil if the string is already VarRepresentable
    var changeToVarRep: String? {
        
        // trim
        var varrep = self.trimmed
        
        // remove crap symbols, capitalize words and remove spaces
        varrep = varrep.simple.componentsSeparatedByString(" ").map { $0.capitalFirstLetter }.joinWithSeparator("").lowerCaseFirstLetter
        
        // if it is blank, make a New typeRep
        if self == "" || self == "_" {
            varrep = "newVariable"
        }
        
        // if type is still same as self, return nil
        if varrep == self {
            return nil
        }
        
        return varrep
    }
    
    /// removes extra white spaces and new lines
    var trimmed: String {
        return self.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
    }
    
    /// makes a Type [Entity, Struct,  representation of the string
    var typeRepresentable: String {
        return self.simple.componentsSeparatedByString(" ").flatMap { $0.capitalFirstLetter }.joinWithSeparator("")
    }
    
    /// makes a variable representation of the string
    var varRepresentable: String {
        return self.typeRepresentable.lowerFirstLetter
    }
    
    var capitalFirstLetter: String {
        if self.isEmpty { return "" }
        var s = self
        s.replaceRange(s.startIndex...s.startIndex, with: String(s[s.startIndex]).capitalizedString)
//        let firstChar = String(s.characters.first!).uppercaseString
//        s.replaceRange(s.startIndex...s.startIndex, with: firstChar)
        return s
    }
    
    func getLast(int: Int) -> String {
        let last = min(int, self.characters.count)
        return self.substringFromIndex(self.endIndex.advancedBy(-last))
    }
    
    func getFirst(int: Int) -> String {
        let last = min(int, self.characters.count)
        return self.substringToIndex(self.startIndex.advancedBy(last))
    }
    
    var lowerFirstLetter: String {
        if self.isEmpty { return "" }
        var string = self
        let firstChar = String(string.characters.first!).lowercaseString
        string.replaceRange(string.startIndex...string.startIndex, with: firstChar)
        return string
    }
    
    /// adds "Set" to end of string
    var setRep: String {
        return self + "Set"
    }
    
    /// wraps Set<> around string
    var pluralRep: String {
        return "Set<\(self)>"
    }
    
    /// add "Nullable" to end of string
    var nilRep: String {
        return self + "Nullable"
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