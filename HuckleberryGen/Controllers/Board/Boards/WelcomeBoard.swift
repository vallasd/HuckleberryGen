//
//  WelcomeVC.swift
//  HuckleberryGen
//
//  Created by David Vallas on 7/16/15.
//  Copyright © 2015 Phoenix Labs.
//
//  All Rights Reserved.

import Cocoa

class WelcomeBoard: NSViewController, NavControllerReferable {
    
    // reference to nav controller
    weak var nav: NavController?
    
}

extension WelcomeBoard: BoardInstantiable {
    
    static var storyboard: String { return "Board" }
    static var nib: String { return "WelcomeBoard" }
}

extension WelcomeBoard: NavControllerRegressable {
    
    func navcontrollerRegressionTypes(_ nav: NavController) -> [RegressionType] {
        return [] // We just want to remove the cancel option for the Welcome Board
    }
    
    func navcontroller(_ nav: NavController, hitRegressWithType: RegressionType) {
        // Do Nothing
    }
    
}

extension WelcomeBoard: NavControllerProgessable {
    
    func navcontrollerProgressionType(_ nav: NavController) -> ProgressionType {
        if appDelegate.store.licenseInfo.needsMoreInformation { return .next }
        else { return .finished }
    }
    
    /// push license info if nav controller is going to next
    func navcontroller(_ nav: NavController, hitProgressWithType progressionType: ProgressionType) {
        if progressionType == .next { nav.push(LicenseInfoBoard.boardData) }
    }
}
