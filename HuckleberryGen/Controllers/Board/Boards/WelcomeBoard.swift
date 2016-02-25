//
//  WelcomeVC.swift
//  HuckleberryGen
//
//  Created by David Vallas on 7/16/15.
//  Copyright © 2015 Phoenix Labs.
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
