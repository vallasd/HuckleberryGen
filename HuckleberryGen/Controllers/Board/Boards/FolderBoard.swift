//
//  FolderVC.swift
//  HuckleberryGen
//
//  Created by David Vallas on 7/16/15.
//  Copyright © 2015 Phoenix Labs. All rights reserved.
//

import Cocoa

class FolderBoard: NSViewController, NavControllerReferrable {
    
    @IBOutlet weak var folderButton: NSButton!
    
    @IBAction func folderPressed(sender: AnyObject) {
        self.openFileChooser()
    }
    
    /// reference to the NavController that may be holding this board
    weak var nav: NavController?
    
    // MARK: View Lifecycle
    
    override func viewWillAppear() {
        super.viewWillAppear()
        if let path = HuckleberryGen.store.importFileSearchPath { setPath(path) }
        else {
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
        HuckleberryGen.store.importFileSearchPath = path
        folderButton.title = name
        nav?.enableProgression()
    }
}

extension FolderBoard: NavControllerPushable {
    
    var nextBoard: BoardType? { return .Import }
    var nextString: String? { return nil }
    var nextLocation: BoardLocation { return .bottomRight }
}
