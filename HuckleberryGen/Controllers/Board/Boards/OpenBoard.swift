//
//  OpenBoard.swift
//  HuckleberryGen
//
//  Created by David Vallas on 1/4/16.
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

class OpenBoard: NSViewController, NavControllerReferable {
    
    /// reference to the NavController that may be holding this board
    weak var nav: NavController?
    
    /// holds reference to last tag pressed from button tags
    var lastTagPressed: Int = 0
    
    // MARK: Button Commands
    
    @IBAction func buttonPressed(_ sender: NSButton) {
        displayBoardForTag(sender.tag)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    /// displays next nav controller based on button tag
    fileprivate func displayBoardForTag(_ tag: Int) {
        switch tag {
        case 1: // New Project
            appDelegate.store.project = Project.new
            nav?.end()
        case 2: // Load Saved Project
            let context = SBD_SavedProjects()
            let boarddata = SelectionBoard.boardData(withContext: context)
            nav?.push(boarddata)
        case 3: // Import Saved Project
            let boarddata = FolderBoard.boardData
            nav?.push(boarddata)
        default: break // Do Nothing
        }
    }
}

extension OpenBoard: BoardInstantiable {
    
    static var storyboard: String { return "Board" }
    static var nib: String { return "OpenBoard" }
}
