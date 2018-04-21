//
//  LicenseInfoVC.swift
//  HuckleberryGen
//
//  Created by David Vallas on 7/18/15.
//  Copyright © 2015 Phoenix Labs.
//
//  All Rights Reserved.

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
