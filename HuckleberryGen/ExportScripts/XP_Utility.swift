//
//  ExportUtilies.swift
//  HuckleberryGen
//
//  Created by David Vallas on 1/28/16.
//  Copyright © 2016 Phoenix Labs.
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