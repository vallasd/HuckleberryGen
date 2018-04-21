//
//  InfoBoard.swift
//  HuckleberryGen
//
//  Created by David Vallas on 2/24/16.
//  Copyright © 2016 Phoenix Labs.
//
//  All Rights Reserved.

import Cocoa

/// board that shows keyboard definitions for Huckleberry Gen
class KeyBoardInfoBoard: NSViewController, NavControllerReferable {
    weak var nav: NavController?
}

extension KeyBoardInfoBoard: BoardInstantiable {
    static var storyboard: String { return "Board" }
    static var nib: String { return "KeyBoardInfoBoard" }
}

extension KeyBoardInfoBoard: NavControllerProgessable {
    
    func navcontrollerProgressionType(_ nav: NavController) -> ProgressionType {
        return .next
    }
    
    func navcontroller(_ nav: NavController, hitProgressWithType progressionType: ProgressionType) {
        nav.push(ColorInfoBoard.boardData)
    }
}


/// board that shows color definitions for Huckleberry Gen
class ColorInfoBoard: NSViewController, NavControllerReferable {
    
    @IBOutlet weak var editableFC: NSView!
    @IBOutlet weak var nonEditableFC: NSView!
    @IBOutlet weak var indexableFC: NSView!
    @IBOutlet weak var enumFC: NSView!
    @IBOutlet weak var specialFC: NSView!
    
    weak var nav: NavController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        editableFC.backgroundColor(.blue)
        nonEditableFC.backgroundColor(.black)
        indexableFC.backgroundColor(.green)
        enumFC.backgroundColor(.cyan)
        specialFC.backgroundColor(.orange)
    }
}

extension ColorInfoBoard: BoardInstantiable {
    static var storyboard: String { return "Board" }
    static var nib: String { return "ColorInfoBoard" }
}

extension ColorInfoBoard: NavControllerProgessable {
    
    func navcontrollerProgressionType(_ nav: NavController) -> ProgressionType {
        if appDelegate.store.licenseInfo.needsMoreInformation { return .next }
        else { return .finished }
    }
    
    func navcontroller(_ nav: NavController, hitProgressWithType progressionType: ProgressionType) {
        if progressionType == .next { nav.push(LicenseInfoBoard.boardData) }
    }
}
