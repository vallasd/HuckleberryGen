//
//  HGIndent.swift
//  HuckleberryGen
//
//  Created by David Vallas on 1/27/16.
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
//
//  You should have received a copy of the GNU General Public License
//  along with HuckleberryGen.  If not, see <http://www.gnu.org/licenses/>.

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