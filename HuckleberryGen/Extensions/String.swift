//
//  String.swift
//  HuckleberryGen
//
//  Created by David Vallas on 4/25/18.
//  Copyright © 2018 Phoenix Labs. All rights reserved.
//

import Foundation

extension Array where Element == String {
    
    var encode: String {
        return self.map { $0 }.joined(separator: " ")
    }
    
}
