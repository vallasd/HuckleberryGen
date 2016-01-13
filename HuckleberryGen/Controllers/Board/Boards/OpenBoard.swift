//
//  OpenBoard.swift
//  HuckleberryGen
//
//  Created by David Vallas on 1/4/16.
//  Copyright © 2016 Phoenix Labs. All rights reserved.
//

import Cocoa

class OpenBoard: NSViewController, NavControllerReferable {
    
    /// reference to the NavController that may be holding this board
    weak var nav: NavController?
    
    /// holds reference to last tag pressed from button tags
    var lastTagPressed: Int = 0
    
    // MARK: Button Commands
    
    @IBAction func buttonPressed(sender: NSButton) {
        
        lastTagPressed = sender.tag
        
        // determine if the first save of project was ever performed, name is set during this time
        let projectWasInitiallySaved = appDelegate.store.project.name == nil ? false : true
        
        
        if projectWasInitiallySaved {
            appDelegate.store.saveProject()
            displayBoardForTag(lastTagPressed)
        } else {
            //nav?.popoverDecision(withTitle: "Do you want to save current project?", delegate: self)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    /// displays next nav controller based on button tag
    private func displayBoardForTag(tag: Int) {
        switch tag {
        case 1:
            appDelegate.store.project = Project.new
            nav?.end()
        case 2:
            nav?.end()
            let context = SBD_SavedProjects()
            let boarddata = SelectionBoard.boardData(withContext: context)
            
//            let data = BoardData(storyboard: vcType.storyboard, nibIdentifer: vcType.nib, saveContext: context)
//            nav?.push(.Load, animated: true)
        case 3:
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