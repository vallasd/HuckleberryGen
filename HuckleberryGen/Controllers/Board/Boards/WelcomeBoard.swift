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

extension WelcomeBoard: NavControllerCancelable {
    
    var canCancel: Bool { return false }
}


extension WelcomeBoard: NavControllerPushable {
    
    var nextBoard: BoardType? {
        if appDelegate.store.licenseInfo.needsMoreInformation { return .LicenseInfo }
        return nil
    }
    
}
