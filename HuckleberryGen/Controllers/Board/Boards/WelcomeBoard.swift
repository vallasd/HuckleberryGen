//
//  WelcomeVC.swift
//  HuckleberryGen
//
//  Created by David Vallas on 7/16/15.
//  Copyright © 2015 Phoenix Labs. All rights reserved.
//

import Cocoa

class WelcomeBoard: NSViewController, NavControllerReferable {
    
    // reference to nav controller
    var nav: NavController?
    
}

extension WelcomeBoard: BoardInstantiable {
    
    static var storyboard: String { return "Board" }
    static var nib: String { return "WelcomeBoard" }
}

extension WelcomeBoard: NavControllerRegressable {
    
    func navcontrollerRegressionTypes(nav: NavController) -> [RegressionType] {
        return [] // We just want to remove the cancel option for the Welcome Board
    }
    
    func navcontroller(nav: NavController, hitRegressWithType: RegressionType) {
        // Do Nothing
    }
    
}

extension WelcomeBoard: NavControllerProgessable {
    
    func navcontrollerProgressionType(nav: NavController) -> ProgressionType {
        if appDelegate.store.licenseInfo.needsMoreInformation { return .Next }
        else { return .Finished }
    }
    
    /// push license info if nav controller is going to next
    func navcontroller(nav: NavController, hitProgressWithType progressionType: ProgressionType) {
        if progressionType == .Next { nav.push(LicenseInfoBoard.boardData) }
    }
}
