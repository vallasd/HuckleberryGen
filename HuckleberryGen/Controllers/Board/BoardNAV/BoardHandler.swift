//
//  IntroVC.swift
//  HuckleberryGen
//
//  Created by David Vallas on 7/16/15.
//  Copyright © 2015 Phoenix Labs. All rights reserved.
//

import Cocoa
import QuartzCore

enum BoardType: Int16 {
    case Welcome
    case Folder
    case LicenseInfo
    case Model
    case Import
    case Selection
    case Decision
    case Error
    
    var string: String {
        switch self {
        case Welcome: return "WelcomeBoard"
        case Folder: return "FolderBoard"
        case LicenseInfo: return "LicenseInfoBoard"
        case Model: return "ImportModelBoard"
        case Import: return "ImportBoard"
        case Selection: return "SelectionBoard"
        case Decision: return "DecisionBoard"
        case Error: return "ErrorBoard"
        }
    }
    
    func create() -> NSViewController {
        let storyboard = NSStoryboard(name: "Board", bundle: nil)
        let controller = storyboard.instantiateControllerWithIdentifier(self.string) as! NSViewController
        return controller
    }
    
    private static func createNav() -> NavController {
        let storyboard = NSStoryboard(name: "Board", bundle: nil)
        return storyboard.instantiateControllerWithIdentifier("NavController") as! NavController
    }
}

/// protocol for an object (like a window) that holds a board handler
protocol BoardHandlerHolder: AnyObject {
    var boardHandler: BoardHandler! { get }
}

/// Class that appropriately sets up a pop-up NAVController in a windowController.
class BoardHandler {
    
    /// windowController which boards will be pushed to
    private(set) weak var windowcontroller: NSWindowController!
    
    /// background view which we blur when we display boards
    private var background: NSView { get { return windowcontroller.window!.contentViewController!.view } }
    
    /// controllers that handles pushing and popping view controllers from Board navigation stack
    private(set) var nav: NavController?
    
    /// view that holds the Board and blocks the background from touches
    private var holder: NSView!
    
    /// initializes BoardHandler with a window controller, use this function for initialization
    init(windowController wc: NSWindowController) {
        windowcontroller = wc
    }
    
    /// pops board nav controller (holding board) on window controller
    func startBoard(board: BoardType) {
        if (nav == nil) {
            nav = BoardType.createNav()
            nav!.root = board
            nav!.delegate = self
            background.blur()
            holder = createHolder()
            windowcontroller.window!.toolbar?.visible = false
            holder.center(parent: background)
            background.addSubview(holder)
            nav!.view.center(parent: holder)
            holder.addSubview(nav!.view)
        }
    }
    
    /// removes nav controller from window controller
    func endBoard() {
        nav?.view.removeFromSuperview()
        nav?.removeFromParentViewController()
        background.unblur()
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
        holder.backgroundColor(HGColor.Clear)
        return holder
    }
}

extension BoardHandler: NavControllerDelegate {
    
    func shouldDismiss(nav: NavController) {
        endBoard()
    }
    
}
