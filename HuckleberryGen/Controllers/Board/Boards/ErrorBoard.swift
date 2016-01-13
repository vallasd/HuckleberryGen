//
//  ErrorBoard.swift
//  HuckleberryGen
//
//  Created by David Vallas on 11/18/15.
//  Copyright © 2015 Phoenix Labs. All rights reserved.
//

import Cocoa

class ErrorBoard: NSViewController {
    
}

extension ErrorBoard: BoardInstantiable {
    
    static var storyboard: String { return "Board" }
    static var nib: String { return "ErrorBoard" }
}
