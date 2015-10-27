//
//  IntroVC.swift
//  HuckleberryGen
//
//  Created by David Vallas on 7/16/15.
//  Copyright © 2015 Phoenix Labs. All rights reserved.
//

import Cocoa
import QuartzCore

protocol HandlerDelegate {
    func handlerFinished(handler: HGHandler)
}

enum BoardType: Int16 {
    case Welcome
    case Folder
    case LicenseInfo
    case Model
    case Import
    case Selection
    
    var string: String {
        switch self {
        case Welcome: return "WelcomeBoard"
        case Folder: return "FolderBoard"
        case LicenseInfo: return "LicenseInfoBoard"
        case Model: return "ImportModelBoard"
        case Import: return "SelectionBoard"
        case Selection: return "SelectionBoard"
        }
    }
}

class BoardHandler {
    
    // MARK: Handlers
    
    var handlers: [HGHandler] = []

    static let shared: BoardHandler = BoardHandler()
    weak var windowcontroller: NSWindowController? = nil
    
    static var currentVC: NSViewController? { return BoardHandler.shared.nav?.currentVC }
    
    private var nav: NavController? = nil
    private weak var holder: NSViewController? = nil
    
    static func startBoard(board: BoardType, blur: Bool) { BoardHandler.shared.startBoard(board, blur: blur) }
    static func endBoard() { BoardHandler.shared.endBoard() }
    
    private func startBoard(board: BoardType, ToViewController vc: NSViewController, blur: Bool) {
        if (nav == nil) {
            nav = BoardHandler.navcontroller()
            nav?.root = board
            holder = vc
            holder?.view.blur()
            nav?.view.center(parent: vc.view)
            holder?.view.addSubview(nav!.view)
        }
    }
    
    private func startBoard(board: BoardType, blur: Bool) {
        if (nav == nil) {
            disableToolBar()
            if let vc = windowcontroller?.window?.contentViewController { startBoard(board, ToViewController: vc, blur: blur) }
        }
    }
    
    private func endBoard() {
        nav?.view.removeFromSuperview()
        nav?.removeFromParentViewController()
        nav = nil
        holder?.view.unblur()
        enableToolBar()
    }
    
    // MARK: TOOLBAR CONTROL
    
    func disableToolBar() { if let winVC = windowcontroller as? MainWindowController { winVC.toolBarEnabled = false } }
    func enableToolBar() { if let winVC = windowcontroller as? MainWindowController { winVC.toolBarEnabled = true } }
    
    // MARK: Navigation Button Manipulation
    
    // Will User Be Able to Move to Next Screen Or Close Menu (Default is YES / Enabled when screen is created)
    
    static func disableProgression() { if let nav = BoardHandler.shared.nav { nav.disableProgression() } }
    static func enableProgression() { if let nav = BoardHandler.shared.nav { nav.enableProgression() } }
    
    // MARK: Menu
    
    static func vc(forBoardType type: BoardType) -> NSViewController {
        let storyboard = NSStoryboard(name: "Board", bundle: nil)
        let controller = storyboard.instantiateControllerWithIdentifier(type.string) as! NSViewController
        BoardHandler.shared.setupHandler(forController: controller, type: type)
        return controller
    }
    
    static func navcontroller() -> NavController {
        let storyboard = NSStoryboard(name: "Board", bundle: nil)
        return storyboard.instantiateControllerWithIdentifier("NavController") as! NavController
    }
    
    private func setupHandler(forController controller: NSViewController, type: BoardType) {
        
        if type == .Import {
            let sb = controller as! SelectionBoard
            let handler = ImportHandler(sb: sb)
            handler.delegate = self
            handlers.append(handler)
        }
    }
}

extension BoardHandler: HandlerDelegate {
    
    func handlerFinished(handler: HGHandler) {
        var index = 0
        for held in handlers {
            if held.selectionBoard === handler.selectionBoard || held.selectionBoard == nil {
                handlers.removeAtIndex(index)
            }
            index++
        }
    }
    
}

