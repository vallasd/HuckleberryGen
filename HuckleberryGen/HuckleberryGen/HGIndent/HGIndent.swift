//
//  HGIndent.swift
//  HuckleberryGen
//
//  Created by David Vallas on 1/27/16.
//  Copyright © 2016 Phoenix Labs. All rights reserved.
//

import Foundation

struct HGIndent {
    
    // singleton
    static let shared = HGIndent()
    
    let indent = "\t"
    
    static var indent: String { return self.shared.indent }
    
    static func indent(count: Int) -> String {
        var ind = ""
        for _ in 1...count { ind += indent }
        return ind
    }
}