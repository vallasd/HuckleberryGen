//
//  MainWindow.swift
//  HuckleberryGen
//
//  Created by David Vallas on 7/16/15.
//  Copyright © 2015 Phoenix Labs.
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

/// The main window controller for the Huckleberry Gen app.
class MainWindowController: NSWindowController {
    
    /// allows boards to be displayed on window (BoardHandlerHolder)
    var boardHandler: BoardHandler!
    
    override func windowDidLoad() {
        super.windowDidLoad()
        
        window?.backgroundColor = HGColor.White.color()
        window?.title = appDelegate.store.project.name
        appDelegate.mainWindowController = self
        //self.window?.setFrame(windowFrame(), display: true)
        boardHandler = BoardHandler(withWindowController: self)
        showWelcome()
    }
    
    /// displays the welcome screen
    private func showSave() {
        boardHandler.start(withBoardData: SaveBoard.boardData)
    }
    
    /// displays the welcome screen
    private func showWelcome() {
        boardHandler.start(withBoardData: WelcomeBoard.boardData)
    }
    
    /// displays the settings screen
    private func showSettings() {
        boardHandler.start(withBoardData: LicenseInfoBoard.boardData)
    }
    
    /// displays the export screen
    private func showExport() {
        let context = FolderBoardContext(boardtype: .Export)
        let boarddata = FolderBoard.boardData(withContext: context)
        boardHandler.start(withBoardData: boarddata)
    }
    
    /// displays the info board
    private func showInfo() {
        let boarddata = KeyBoardInfoBoard.boardData
        boardHandler.start(withBoardData: boarddata)
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
    
    /// returns the required frame for the window
    private func windowFrame() -> CGRect {
        let screens = NSScreen.screenRects()
        let mainScreen = screens.count > 0 ? screens[0] : CGRect(x: 0, y: 0, width: 240, height: 960)
        let windowFrame = CGRect(x: mainScreen.origin.x, y: mainScreen.origin.y, width: 240, height: mainScreen.size.height)
        return windowFrame
    }
    
    /// completes appropriate actions for header button presses
    @IBAction func menuButtonPressed(sender: NSToolbarItem) {
        switch (sender.tag) {
        case 2: showOpen()
        case 3: showExport()
        case 7: showSave()
        case 8: showSettings()
        case 9: showInfo()
        default: assert(true, "Tag - \(sender.tag) Not Defined For Menu Button")
        }
    }
    
    
    
}