//
//  FolderVC.swift
//  HuckleberryGen
//
//  Created by David Vallas on 7/16/15.
//  Copyright © 2015 Phoenix Labs. All rights reserved.
//

import Cocoa

class FolderBoard: NSViewController {
    
    @IBOutlet weak var folderButton: NSButton!
    
    @IBAction func folderPressed(sender: AnyObject) {
        self.openFileChooser()
    }
    
    // MARK: View Lifecycle
    
    override func viewWillAppear() {
        super.viewWillAppear()
        if let path = HuckleberryGen.store.importFileSearchPath { setPath(path) }
        else { BoardHandler.disableProgression() }
    }
    
    override func viewWillDisappear() {
        super.viewWillDisappear()
        
    }
    
    private func openFileChooser() {
        
        BoardHandler.disableProgression()
        
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
        BoardHandler.enableProgression()
    }
}

extension FolderBoard: NavControllerPushable {
    
    var nextBoard: BoardType? { return .Import }
    var nextString: String? { return nil }
    var nextLocation: BoardLocation { return .bottomRight }
}
