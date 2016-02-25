//
//  InfoBoard.swift
//  HuckleberryGen
//
//  Created by David Vallas on 2/24/16.
//  Copyright © 2016 Phoenix Labs.
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

/// board that shows keyboard definitions for Huckleberry Gen
class KeyBoardInfoBoard: NSViewController, NavControllerReferable {
    weak var nav: NavController?
}

extension KeyBoardInfoBoard: BoardInstantiable {
    static var storyboard: String { return "Board" }
    static var nib: String { return "KeyBoardInfoBoard" }
}

extension KeyBoardInfoBoard: NavControllerProgessable {
    
    func navcontrollerProgressionType(nav: NavController) -> ProgressionType {
        return .Next
    }
    
    func navcontroller(nav: NavController, hitProgressWithType progressionType: ProgressionType) {
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
        editableFC.backgroundColor(.Blue)
        nonEditableFC.backgroundColor(.Black)
        indexableFC.backgroundColor(.Green)
        enumFC.backgroundColor(.Cyan)
        specialFC.backgroundColor(.Orange)
    }
}

extension ColorInfoBoard: BoardInstantiable {
    static var storyboard: String { return "Board" }
    static var nib: String { return "ColorInfoBoard" }
}

extension ColorInfoBoard: NavControllerProgessable {
    
    func navcontrollerProgressionType(nav: NavController) -> ProgressionType {
        if appDelegate.store.licenseInfo.needsMoreInformation { return .Next }
        else { return .Finished }
    }
    
    func navcontroller(nav: NavController, hitProgressWithType progressionType: ProgressionType) {
        if progressionType == .Next { nav.push(LicenseInfoBoard.boardData) }
    }
}
