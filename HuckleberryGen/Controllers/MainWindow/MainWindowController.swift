//
//  MainWindow.swift
//  HuckleberryGen
//
//  Created by David Vallas on 7/16/15.
//  Copyright © 2015 Phoenix Labs. All rights reserved.
//

import Cocoa

/// The main window controller for the Huckleberry Gen app.
class MainWindowController: NSWindowController {
    
    /// allows boards to be displayed on window (BoardHandlerHolder)
    var boardHandler: BoardHandler!
    
    override func windowDidLoad() {
        super.windowDidLoad()
        
        window?.backgroundColor = HGColor.White.color()
        window?.titleVisibility = .Hidden
        appDelegate.mainWindowController = self
        boardHandler = BoardHandler(withWindowController: self)
        showWelcome()
    }
    
    /// displays the welcome screen
    private func showWelcome() {
        boardHandler.start(withBoardData: WelcomeBoard.boardData)
    }
    
    /// displays the settings screen
    private func showSettings() {
        boardHandler.start(withBoardData: LicenseInfoBoard.boardData)
    }
    
    /// displays the import screens
    private func showOpen() {
        boardHandler.start(withBoardData: OpenBoard.boardData)
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