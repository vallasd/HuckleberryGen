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
    weak var windowcontroller: NSWindowController!
    
    /// controllers that handles pushing and popping view controllers from Board navigation stack
    var nav: NavController?
    
    /// base viewController that will hold the navigation controller
    private weak var holder: NSViewController?
    
    /// initializes BoardHandler with a window controller, use this function for initialization
    init(windowController wc: NSWindowController) {
        windowcontroller = wc
    }
    
    /// pops board nav controller (holding board) on window controller
    func startBoard(board: BoardType) {
        if (nav == nil) {
            if let vc = windowcontroller?.window?.contentViewController {
                startBoard(board, ToViewController: vc)
            }
        }
    }
    
    /// removes nav controller from window controller
    func endBoard() {
        nav?.view.removeFromSuperview()
        nav?.removeFromParentViewController()
        nav = nil
        holder?.view.unblur()
        enableToolBar()
    }
    
    private func startBoard(board: BoardType, ToViewController vc: NSViewController) {
        if (nav == nil) {
            disableToolBar()
            nav = BoardType.createNav()
            nav?.root = board
            nav?.delegate = self
            holder = vc
            holder?.view.blur()
            nav?.view.center(parent: vc.view)
            holder?.view.addSubview(nav!.view)
        }
    }
    
    // MARK: TOOLBAR CONTROL
    
    func disableToolBar() {
        if let winVC = windowcontroller as? MainWindowController { winVC.toolBarEnabled = false }
    }
    
    func enableToolBar() {
        if let winVC = windowcontroller as? MainWindowController { winVC.toolBarEnabled = true }
    }
    
}

extension BoardHandler: NavControllerDelegate {
    
    func shouldDismiss(nav: NavController) {
        endBoard()
    }
    
}
