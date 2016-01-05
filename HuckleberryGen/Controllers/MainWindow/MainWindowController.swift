//
//  MainWindow.swift
//  HuckleberryGen
//
//  Created by David Vallas on 7/16/15.
//  Copyright © 2015 Phoenix Labs. All rights reserved.
//

import Cocoa

/// The main window controller for the Huckleberry Gen app.  This controller also holds the boardHandler which can be used for pushing and popping Alerts / Boards to window
class MainWindowController: NSWindowController, BoardHandlerHolder {
    
    /// Allows boards to be displayed on window (BoardHandlerHolder)
    var boardHandler: BoardHandler!
    
    // MARK: Window Lifecycle
    
    override func windowDidLoad() {
        super.windowDidLoad()
        
        window?.backgroundColor = HGColor.White.color()
        window?.titleVisibility = .Hidden
        boardHandler = BoardHandler(windowController: self)
        showWelcome()
    }
    
    /// displays the welcome screen
    private func showWelcome() {
        boardHandler.startBoard(.Welcome)
    }
    
    /// displays the settings screen
    private func showSettings() {
        boardHandler.startBoard(.LicenseInfo)
    }
    
    /// displays the import screens
    private func showOpen() {
        boardHandler.startBoard(.Open)
    }
    
    /// completes appropriate actions for header button presses
    @IBAction func menuButtonPressed(sender: NSToolbarItem) {
        switch (sender.tag) {
        case 2: showOpen() // Open
        case 3: showOpen() // Save
        case 8: showSettings()  // Settings
        default: assert(true, "Tag - \(sender.tag) Not Defined For Menu Button")
        }
    }
}