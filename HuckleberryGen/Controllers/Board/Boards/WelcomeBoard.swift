//
//  WelcomeVC.swift
//  HuckleberryGen
//
//  Created by David Vallas on 7/16/15.
//  Copyright © 2015 Phoenix Labs. All rights reserved.
//

import Cocoa

class WelcomeBoard: NSViewController {
    
}

extension WelcomeBoard: NavControllerPushable {
    
    var nextBoard: BoardType? {
        if HuckleberryGen.store.licenseInfo == nil { return .LicenseInfo }
        return nil
    }
    var nextString: String? { return "Get Started" }
    var nextLocation: BoardLocation { return .bottomCenter }
}
