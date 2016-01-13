//
//  LicenseInfoVC.swift
//  HuckleberryGen
//
//  Created by David Vallas on 7/18/15.
//  Copyright © 2015 Phoenix Labs. All rights reserved.
//

import Foundation

import Cocoa

class LicenseInfoBoard: NSViewController, NavControllerReferable {

    // MARK: Outlets

    @IBOutlet weak var nameField: NSTextField!
    @IBOutlet weak var companyField: NSTextField!
    @IBOutlet weak var emailField: NSTextField!
    @IBOutlet weak var contact2Field: NSTextField!
    @IBOutlet weak var licenseButton: NSPopUpButtonCell!
    
    /// reference to the NavController that is holding this board (NavControllerReferable)
    weak var nav: NavController?
    
    // MARK: Private Functions
    
    private func updateLicenseInfo() {
        //LicenseType.create(Int()
        if (nameField.stringValue.characters.count > 2) {
            let store = appDelegate.store
            let license = LicenseInfo(name: nameField.stringValue, company: companyField.stringValue, contact1: emailField.stringValue, contact2: contact2Field.stringValue, type: LicenseType.create(int: licenseButton.indexOfSelectedItem))
            store.licenseInfo = license
        }
    }
    
    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let license = appDelegate.store.licenseInfo
        nameField.stringValue = license.name
        companyField.stringValue = license.company
        emailField.stringValue = license.contact1
        contact2Field.stringValue = license.contact2
        licenseButton.selectItemAtIndex(license.type.int)
        
        nameField.delegate = self
        companyField.delegate = self
        emailField.delegate = self
        contact2Field.delegate = self
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        if (nameField.stringValue.characters.count == 0) {
            nav?.disableProgression()
        }
    }
    
    override func viewWillDisappear() {
        super.viewWillDisappear()
        updateLicenseInfo()
    }
    
}

extension LicenseInfoBoard: BoardInstantiable {
    
    static var storyboard: String { return "Board" }
    static var nib: String { return "LicenseInfoBoard" }
}


extension LicenseInfoBoard: NSTextFieldDelegate {
    
    override func controlTextDidEndEditing(obj: NSNotification) {
        if (nameField.stringValue.characters.count > 0) {
            nav?.enableProgression()
        }
        else {
            nav?.disableProgression()
        }
    }
}
