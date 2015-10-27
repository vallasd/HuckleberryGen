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
}