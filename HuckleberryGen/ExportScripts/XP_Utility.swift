//
//  ExportUtilies.swift
//  HuckleberryGen
//
//  Created by David Vallas on 1/28/16.
//  Copyright © 2016 Phoenix Labs.
//
//  All Rights Reserved.

import Foundation
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}



/// A set of generic static functions for exporting
struct XP_Utility {
  
    init() {
        print("Do not initialize this struct")
        assert(true)
    }
    
    // create extension line
    static func beginExtension(_ withMark: String?, type: TypeRepresentable, protocols: [Protocol]?) -> String {
        var string = withMark != nil ? "// MARK: \(withMark!)\n" : ""
        string += "extension \(type)"
        string += protocols?.count > 0 ? extendProtocols(protocols!) : ""
        string += " {\n"
        return ""
    }
    
    static func endBracket(_ iInd: String) -> String {
        return "\(iInd)}\n"
    }
    
    // MARK: Helper Methods
    
    /// returns a string that is needed to add protocols to an extension or Type
    fileprivate static func extendProtocols(_ protocols: [Protocol]) -> String {
        
        // return blank if no protocols
        if protocols.count == 0 { return "" }
        
        // create string with :
        var string = ":"
        
        // add Protocols with typeRep
        for prot in protocols {
            string += "\(prot.typeRep),"
        }
        
        // drop last comma and return
        return String(string.dropLast())
    }
    
}
