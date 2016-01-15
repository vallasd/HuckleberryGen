//
//  BoardHandler.swift
//  HuckleberryGen
//
//  Created by David Vallas on 7/16/15.
//  Copyright © 2015 Phoenix Labs. All rights reserved.
//

import Cocoa
import QuartzCore

/// Class that appropriately sets up a pop-up NAVController in a windowController.
class BoardHandler {
    
    /// initialize with a window controller
    init(withWindowController wc: NSWindowController) {
        windowcontroller = wc
    }
    
    /// windowController which boards will be pushed to
    private(set) weak var windowcontroller: NSWindowController!
    
    /// background view which we blur when we display boards
    private var background: NSView { get { return windowcontroller.window!.contentViewController!.view } }
    
    /// controllers that handles pushing and popping view controllers from Board navigation stack
    private(set) var nav: NavController?
    
    /// view that holds the Board and blocks the background from touches
    private var holder: NSView!
    
    /// pops board nav controller (holding board) on window controller
    func start(withBoardData boarddata: BoardData){
        if (nav == nil) {
            createNav()
            nav?.loadData = boarddata
            nav?.delegate = self
            holder = createHolder()
            windowcontroller.window!.toolbar?.visible = false
            holder.center(parent: background)
            background.addSubview(holder)
            nav?.view.center(parent: holder)
            holder.addSubview(nav!.view)
        }
    }
    
    /// removes nav controller from window controller
    func endBoard() {
        nav?.view.removeFromSuperview()
        nav?.removeFromParentViewController()
        nav?.view.removeFromSuperview()
        holder.removeFromSuperview()
        windowcontroller.window!.toolbar?.visible = true
        holder = nil
        nav = nil
    }
    
    /// creates a empty holding view that is clear but blocks touches to the window
    private func createHolder() -> HGBlockView {
        let frame = background.frame
        let holder = HGBlockView(frame: frame)
        holder.backgroundColor(HGColor.WhiteTranslucent)
        return holder
    }
    
    // creates a navigation controller
    private func createNav() {
        let storyboard = NSStoryboard(name: "Board", bundle: nil)
        nav = storyboard.instantiateControllerWithIdentifier("NavController") as? NavController
        
        if nav == nil {
            HGReportHandler.report("NavController not properly created from StoryBoard", response: .Error)
        }
    }
}

extension BoardHandler: NavControllerDelegate {
    
    func navcontrollerShouldDismiss(nav: NavController) {
        endBoard()
    }
    
}
