//
//  BoardHandler.swift
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
import QuartzCore

/// Class that appropriately sets up a pop-up NAVController in a windowController.
class BoardHandler {
    
    /// initialize with a window controller
    init(withWindowController wc: NSWindowController) {
        windowcontroller = wc
    }
    
    /// windowController which boards will be pushed to
    fileprivate(set) weak var windowcontroller: NSWindowController!
    
    /// background view which we blur when we display boards
    fileprivate var background: NSView { get { return windowcontroller.window!.contentViewController!.view } }
    
    /// controllers that handles pushing and popping view controllers from Board navigation stack
    fileprivate(set) var nav: NavController?
    
    /// view that holds the Board and blocks the background from touches
    fileprivate var holder: NSView!
    
    /// pops board nav controller (holding board) on window controller
    func start(withBoardData boarddata: BoardData){
        if (nav == nil) {
            createHolder()
            createNav()
            nav?.loadData = boarddata
            nav?.delegate = self
            windowcontroller.window!.toolbar?.isVisible = false
            holder.resize(inParent: background)
            nav?.view.resize(inParent: holder)
        }
    }
    
    /// removes nav controller from window controller
    func endBoard() {
        nav?.view.removeFromSuperview()
        nav?.removeFromParentViewController()
        nav?.view.removeFromSuperview()
        holder.removeFromSuperview()
        windowcontroller.window!.toolbar?.isVisible = true
        holder = nil
        nav = nil
    }
    
    /// creates a empty holding view that is clear but blocks touches to the window
    fileprivate func createHolder() {
        let frame = background.frame
        let h = HGBlockView(frame: frame)
        h.backgroundColor(HGColor.whiteTranslucent)
        holder = h
    }
    
    // creates a navigation controller
    fileprivate func createNav() {
        let storyboard = NSStoryboard(name: NSStoryboard.Name(rawValue: "Board"), bundle: nil)
        nav = storyboard.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: "NavController")) as? NavController
        
        if nav == nil {
            HGReportHandler.shared.report("NavController not properly created from StoryBoard", type: .error)
        }
    }
}

extension BoardHandler: NavControllerDelegate {
    
    func navcontrollerShouldDismiss(_ nav: NavController) {
        endBoard()
    }
    
    func navcontrollerRect() -> CGRect {
        return CGRect(x: 0, y: 0, width: holder.frame.width - 10, height: holder.frame.height * 0.95)
    }
}
