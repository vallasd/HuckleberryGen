//
//  NSNavigationController.swift
//  HuckleberryGen
//
//  Created by David Vallas on 7/16/15.
//  Copyright © 2015 Phoenix Labs. All rights reserved.
//

import Cocoa

enum BoardLocation: Int {
    case bottomLeft
    case bottomRight
    case bottomCenter
}

/// Protocol that allows boards to define the navigation and button placements for next buttons
protocol NavControllerPushable {
    var nextBoard: BoardType? { get }
    var nextString: String? { get }
    var nextLocation: BoardLocation { get }
}

/// Protocol that allows boards to gain reference to NavController.  If board conforms to protocol, NavController will assign itself to nav value immediately after board is instantiated.  (Allows Board to run nav commands like disableProgression)
protocol NavControllerReferrable {
    var nav: NavController? { get set }
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

protocol NavControllerDelegate: AnyObject {
    func shouldDismiss(nav: NavController)
}

class NavController: NSViewController {
    
    @IBOutlet weak var container: NSView!
    @IBOutlet weak var next: NSButton!
    @IBOutlet weak var back: NSButton!
    @IBOutlet weak var mutableNextConstraint: NSLayoutConstraint!
    
    weak var delegate: NavControllerDelegate?

    func disableProgression() {
        next.enabled = false
    }
    
    func enableProgression() {
        next.enabled = true
    }
    
    func end() {
        delegate?.shouldDismiss(self)
    }
    
    private struct BoardInfo {
        let boardType: BoardType
        var saveContext: AnyObject?
    }
    
    var root: BoardType? = nil
    var currentVC: NSViewController? = nil
    private var boardStack: [BoardInfo] = []
    
    // MARK: Button Selection
    
    /// action that is run when back button is pressed.  Will pop top controller from stack.
    @IBAction func backPressed(sender: AnyObject) {
        pop(animated: true)
    }
    
    /// action that is run when next button is pressed.  Will either push next controller if currentVC conforms to NavControllerPushable or send notice to delegate for dismissal
    @IBAction func nextPressed(sender: AnyObject) {
        if let current = currentVC as? NavControllerPushable {
            if let nextBoard = current.nextBoard {
                push(nextBoard, animated: true)
                return
            }
        }
        
        delegate?.shouldDismiss(self)
    }
    
    /// pushes new boardType onto stack
    private func push(board: BoardType, animated: Bool) {
        removeTopView()
        saveCurrentBoard()
        boardStack.append(BoardInfo(boardType: board, saveContext: nil))
        createVC(forBoardType: board)
        updateNavButtons()
        addTopView()
    }
    
    /// pops last boardType from stack
    private func pop(animated animated: Bool) {
        removeTopView()
        boardStack.removeLast()
        createVC(forBoardType: boardStack.last!.boardType)
        updateNavButtons()
        addTopView()
    }
    
    /// creates NSViewController from a board type.  Sets delegates as appropriate.
    private func createVC(forBoardType boardtype: BoardType) {
        
        // create and assign new currentVC
        currentVC = boardtype.create()
        
        // assign self to vc.nav if currentVC conforms to NavControllerReferrable
        if var ncr = currentVC as? NavControllerReferrable {
            ncr.nav = self
        }
    }
    
    /// removes top view from container
    private func removeTopView() {
        currentVC?.view.removeFromSuperview()
    }
    
    /// adds top view to container
    private func addTopView() {
        if let view = currentVC?.view {
            container.addSubview(view)
        }
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
            
            switch vc.nextLocation {
            case .bottomLeft: leftNext()
            case .bottomCenter: centerNext()
            case .bottomRight: rightNext()
            }
        } else {
            next.title = "Finished"
            if back.hidden { centerNext() }
            else { rightNext() }
        }
        
        self.view.layoutSubtreeIfNeeded()
    }
    
    /// sets next button on left side on nav controller
    private func leftNext() {
        self.view.removeConstraint(mutableNextConstraint)
        mutableNextConstraint = NSLayoutConstraint(item: next, attribute: .Leading, relatedBy: .Equal, toItem: view, attribute: .Leading, multiplier: 1, constant: 20.0)
        self.view.addConstraint(mutableNextConstraint)
    }
    
    /// sets next button in center of nav controller
    private func centerNext() {
        self.view.removeConstraint(mutableNextConstraint)
        mutableNextConstraint = NSLayoutConstraint(item: next, attribute: .CenterX, relatedBy: .Equal, toItem: view, attribute: .CenterX, multiplier: 1, constant: 0.0)
        self.view.addConstraint(mutableNextConstraint)
    }
    
    /// sets next button on right side on nav controller
    private func rightNext() {
        self.view.removeConstraint(mutableNextConstraint)
        mutableNextConstraint = NSLayoutConstraint(item: next, attribute: .Trailing, relatedBy: .Equal, toItem: view, attribute: .Trailing, multiplier: 1, constant: -20.0)
        self.view.addConstraint(mutableNextConstraint)
    }
}
