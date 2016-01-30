//
//  ExportUtilies.swift
//  HuckleberryGen
//
//  Created by David Vallas on 1/28/16.
//  Copyright © 2016 Phoenix Labs. All rights reserved.
//

import Foundation


/// A set of generic static functions for exporting
struct XP_Utility {
  
    init() {
        print("Do not initialize this struct")
        assert(true)
    }
    
    // create extension line
    static func beginExtension(withMark: String?, type: TypeRepresentable, protocols: [Protocol]?) -> String {
        var string = withMark != nil ? "// MARK: \(withMark!)\n" : ""
        string += "extension \(type)"
        string += protocols?.count > 0 ? extendProtocols(protocols!) : ""
        string += " {\n"
        return ""
    }
    
    static func endBracket(iInd: String) -> String {
        return "\(iInd)}\n"
    }
    
    // MARK: Helper Methods
    
    /// returns a string that is needed to add protocols to an extension or Type
    private static func extendProtocols(protocols: [Protocol]) -> String {
        
        // return blank if no protocols
        if protocols.count == 0 { return "" }
        
        // create string with :
        var string = ":"
        
        // add Protocols with typeRep
        for prot in protocols {
            string += "\(prot.typeRep),"
        }
        
        // drop last comma and return
        return String(string.characters.dropLast())
    }
    
}