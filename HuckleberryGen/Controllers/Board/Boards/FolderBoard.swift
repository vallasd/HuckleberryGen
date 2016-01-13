//
//  FolderVC.swift
//  HuckleberryGen
//
//  Created by David Vallas on 7/16/15.
//  Copyright © 2015 Phoenix Labs. All rights reserved.
//

import Cocoa

class FolderBoard: NSViewController, NavControllerReferable {
    
    @IBOutlet weak var folderButton: NSButton!
    
    @IBAction func folderPressed(sender: AnyObject) {
        self.openFileChooser()
    }
    
    /// reference to the NavController that may be holding this board
    weak var nav: NavController?
    
    // MARK: View Lifecycle
    
    override func viewWillAppear() {
        super.viewWillAppear()
        let path = appDelegate.store.importFileSearchPath
        if path != "/" {
            setPath(path)
        } else {
            nav?.disableProgression()
        }
    }
    
    override func viewWillDisappear() {
        super.viewWillDisappear()
        
    }
    
    private func openFileChooser() {
        
        nav?.disableProgression()
        
        let panel = NSOpenPanel()
        
        panel.canChooseDirectories = true
        panel.canChooseFiles = false
        panel.allowsMultipleSelection = false
        panel.prompt = "Choose Your Development Folder"
        
        if panel.runModal() == NSModalResponseOK {
            
            let directory = panel.URL!
            let path = directory.path!
        
            setPath(path)
        }
    }
    
    private func setPath(path: String) {
        let name = path.lastPathComponent
        appDelegate.store.importFileSearchPath = path
        folderButton.title = name
        nav?.enableProgression()
    }
}

extension FolderBoard: BoardInstantiable {
    
    static var storyboard: String { return "Board" }
    static var nib: String { return "FolderBoard" }
}


extension FolderBoard: NavControllerProgessable {
    
    func navcontrollerProgressionType(nav: NavController) -> ProgressionType {
        return .Next
    }
    
    func navcontroller(nav: NavController, hitProgressWithType progressionType: ProgressionType) {
        let context = SBD_Import()
        let boarddata = SelectionBoard.boardData(withContext: context)
        nav.push(boarddata)
    }
}
