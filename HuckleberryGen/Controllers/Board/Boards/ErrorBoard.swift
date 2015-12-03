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

extension ErrorBoard: NavControllerPushable {
    var nextBoard: BoardType? { return nil }
    var nextString: String? { return "OK" }
    var nextLocation: BoardLocation { return .bottomCenter }
}
