//
//  MainWindow.swift
//  HuckleberryGen
//
//  Created by David Vallas on 7/16/15.
//  Copyright © 2015 Phoenix Labs. All rights reserved.
//

import Cocoa

class MainWindowController: NSWindowController {
    
    // MARK: Variables

    var toolBarEnabled = true
    
    // MARK: Window Lifecycle
    
    override func windowDidLoad() {
        super.windowDidLoad()
        
        window?.backgroundColor = HGColor.White.color()
        window?.titleVisibility = .Hidden
        BoardHandler.shared.windowcontroller = self
        showWelcome()
    }
    
    private func showWelcome() { BoardHandler.startBoard(.Welcome, blur: true) }
    private func showSettings() { BoardHandler.startBoard(.LicenseInfo, blur: true) }
    private func showImport() { BoardHandler.startBoard(.Folder, blur: true) }
    
    @IBAction func menuButtonPressed(sender: NSToolbarItem) {
        if !toolBarEnabled { return }
        switch (sender.tag) {
        case 1: HuckleberryGen.store.hgmodel = HGModel.new // New
        case 2: showImport() // Import
        case 3: showImport() // Export
        case 7: HGNotif.shared.postNotificationForModelUpdate() // Refresh
        case 8: showSettings()              // Settings
        default: assert(true, "Tag - \(sender.tag) Not Defined For Menu Button")
        }
    }
}