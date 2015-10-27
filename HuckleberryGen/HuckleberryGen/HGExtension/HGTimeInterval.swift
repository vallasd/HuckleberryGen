//
//  HGTimeInterval.swift
//  HuckleberryGen
//
//  Created by David Vallas on 7/17/15.
//  Copyright © 2015 Phoenix Labs. All rights reserved.
//

import Foundation

extension NSTimeInterval {
    
    func date() -> NSDate { return NSDate(timeIntervalSince1970: self) }
    
}