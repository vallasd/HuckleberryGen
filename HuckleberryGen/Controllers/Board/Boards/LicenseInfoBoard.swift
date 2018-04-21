//
//  LicenseInfoVC.swift
//  HuckleberryGen
//
//  Created by David Vallas on 7/18/15.
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

import Foundation

import Cocoa

class LicenseInfoBoard: NSViewController, NavControllerReferable {

    // MARK: Outlets

    @IBOutlet weak var nameField: NSTextField!
    @IBOutlet weak var companyField: NSTextField!
    @IBOutlet weak var emailField: NSTextField!
    @IBOutlet weak var contact2Field: NSTextField!
    @IBOutlet weak var licenseButton: NSPopUpButtonCell!
    
    /// reference to the Nav Controller
    weak var nav: NavController?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let license = appDelegate.store.licenseInfo
        nameField.stringValue = license.name
        companyField.stringValue = license.company
        emailField.stringValue = license.contact1
        contact2Field.stringValue = license.contact2
        licenseButton.selectItem(at: license.type.int)
        
        nameField.delegate = self
        
        updateProgression()
    }
    
    var nameFieldFilledOut: Bool {
        return nameField.stringValue.count > 2 ? true : false
    }
    
    func updateProgression() {
        if nameFieldFilledOut { nav?.enableProgression() }
        else { nav?.disableProgression() }
    }
    
    func updateLicenseInfo() {
        if nameFieldFilledOut {
            let license = LicenseInfo(name: nameField.stringValue, company: companyField.stringValue, contact1: emailField.stringValue, contact2: contact2Field.stringValue, type: LicenseType.create(int: licenseButton.indexOfSelectedItem))
            appDelegate.store.licenseInfo = license
        }
    }
    
}

extension LicenseInfoBoard: NavControllerProgessable {
    
    func navcontrollerProgressionType(_ nav: NavController) -> ProgressionType {
        return .finished
    }
    
    func navcontroller(_ nav: NavController, hitProgressWithType progressionType: ProgressionType) {
        if progressionType == .finished {
            updateLicenseInfo()
        }
    }
    
}

extension LicenseInfoBoard: BoardInstantiable {
    
    static var storyboard: String { return "Board" }
    static var nib: String { return "LicenseInfoBoard" }
}

extension LicenseInfoBoard: NSTextFieldDelegate {
    
    override func controlTextDidChange(_ obj: Notification) {
        updateProgression()
    }
    
}
