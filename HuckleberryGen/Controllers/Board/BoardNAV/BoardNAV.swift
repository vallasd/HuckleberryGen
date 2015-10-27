//
//  NSNavigationController.swift
//  HuckleberryGen
//
//  Created by David Vallas on 7/16/15.
//  Copyright © 2015 Phoenix Labs. All rights reserved.
//

import Cocoa

enum BoardLocation: Int {
    case bottomRight
    case bottomCenter
}

protocol NavControllerPushable {
    var nextBoard: BoardType? { get }
    var nextString: String? { get }
    var nextLocation: BoardLocation { get }
}

protocol NavControllerSetable {
    var setableObject: Setable { get }
}

protocol Setable {
    func set() -> [AnyObject]
}

// Will Let Nav Controller Reinstantiate Controller with savable context
protocol NavSavable {
    var saveContext: AnyObject { get }
    func updateWithSavedContext(saveContext: AnyObject)
}

class NavController: NSViewController {
    
    @IBOutlet weak var container: NSView!
    @IBOutlet weak var next: NSButton!
    @IBOutlet weak var back: NSButton!
    @IBOutlet weak var mutableNextConstraint: NSLayoutConstraint!

    func disableProgression() { next.enabled = false }
    func enableProgression() { next.enabled = true }
    
    private struct BoardInfo {
        let boardType: BoardType
        var saveContext: AnyObject?
    }
    
    var root: BoardType? = nil
    var currentVC: NSViewController? = nil
    private var boardStack: [BoardInfo] = []
    
    // MARK: Button Selection
    
    @IBAction func backPressed(sender: AnyObject) {
        pop(animated: true)
    }
    
    @IBAction func nextPressed(sender: AnyObject) {
        if let current = currentVC as? NavControllerPushable {
            if let nextBoard = current.nextBoard {
                push(nextBoard, animated: true)
                return
            }
        }
        BoardHandler.endBoard()
    }
    
    // MARK: Navigation
    
    private func push(board: BoardType, animated: Bool) {
        removeTopView()
        saveCurrentBoard()
        boardStack.append(BoardInfo(boardType: board, saveContext: nil))
        currentVC = BoardHandler.vc(forBoardType: board)
        updateNavButtons()
        addTopView()
    }
    
    private func pop(animated animated: Bool) {
        removeTopView()
        boardStack.removeLast()
        currentVC = BoardHandler.vc(forBoardType: boardStack.last!.boardType)
        updateNavButtons()
        addTopView()
    }
    
    private func removeTopView() {
        if let view = currentVC?.view { view.removeFromSuperview() }
    }
    
    private func addTopView() {
        if let view = currentVC?.view { container.addSubview(view) }
    }
    
    func saveCurrentBoard() {
        if let saveableVC = currentVC as? NavSavable {
            let oldboardinfo = boardStack.last!
            let newboardinfo = BoardInfo(boardType: oldboardinfo.boardType, saveContext: saveableVC.saveContext)
            boardStack[boardStack.count - 1] = newboardinfo
        }
    }
    
    func updateCurrentVC() {
        
    }
    
    // MARK: LifeCycle
    
    override func viewDidLoad() {
        view.backgroundColor(HGColor.Clear)
        if let root = root as BoardType! { push(root, animated: true) }
    }
    
    override func viewWillDisappear() {
        super.viewWillDisappear()
        boardStack.removeAll()
    }
    
    // MARK: Helper Methods
    
    private func containerInfo() {
        print("container subview count is \(container.subviews.count)")
        for view in container.subviews { print ("description: \(view.description)") }
    }
    
    private func updateNavButtons() {
        enableProgression()
        hideBackIfNeeded()
        displayNext()
    }
    
    private func hideBackIfNeeded() {
        if boardStack.count > 1 { back.hidden = false }
        else { back.hidden = true }
    }
    
    private func displayNext() {
        
        if let vc = currentVC as? NavControllerPushable {
            if vc.nextString != nil { next.title = vc.nextString! }
            else if vc.nextBoard != nil { next.title = "next" }
            else { next.title = "Finished" }
            
            if vc.nextLocation == .bottomRight { rightNext() }
            else if vc.nextLocation == .bottomCenter { centerNext() }
            
        } else {
            next.title = "Finished"
            if back.hidden { centerNext() }
            else { rightNext() }
        }
        
        self.view.layoutSubtreeIfNeeded()
    }
    
    
    private func centerNext() {
        self.view.removeConstraint(mutableNextConstraint)
        mutableNextConstraint = NSLayoutConstraint(item: next, attribute: .CenterX, relatedBy: .Equal, toItem: view, attribute: .CenterX, multiplier: 1, constant: 0.0)
        self.view.addConstraint(mutableNextConstraint)
    }
    
    private func rightNext() {
        self.view.removeConstraint(mutableNextConstraint)
        mutableNextConstraint = NSLayoutConstraint(item: next, attribute: .Trailing, relatedBy: .Equal, toItem: view, attribute: .Trailing, multiplier: 1, constant: -20.0)
        self.view.addConstraint(mutableNextConstraint)
    }
}
