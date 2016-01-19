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
        window?.title = appDelegate.store.project.name
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
        
        /// check if current project is new, if so, ask user first if they want to save the project in Decision Board that pushes to OpenBoard
        if appDelegate.store.project.isNew {
            let context = DBD_SaveProject(project: appDelegate.store.project, nextBoard: OpenBoard.boardData, canCancel:true)
            let boarddata = DecisionBoard.boardData(withContext: context)
            boardHandler.start(withBoardData: boarddata)
        }
        
        // if project is not new, just save it automatically then start Open Board
        else {
            appDelegate.store.saveCurrentProject()
            let boarddata = OpenBoard.boardData
            boardHandler.start(withBoardData: boarddata)
        }
    }
    
    private func showExport() {
        let context = FolderBoardContext(boardtype: .Export)
        let boarddata = FolderBoard.boardData(withContext: context)
        boardHandler.start(withBoardData: boarddata)
    }
    
    /// completes appropriate actions for header button presses
    @IBAction func menuButtonPressed(sender: NSToolbarItem) {
        switch (sender.tag) {
        case 2: showOpen() // Open
        case 3: showExport() // Save
        case 7: appDelegate.store.saveCurrentProject()
        case 8: showSettings()  // Settings
        default: assert(true, "Tag - \(sender.tag) Not Defined For Menu Button")
        }
    }
}