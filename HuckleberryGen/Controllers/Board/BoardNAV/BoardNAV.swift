//
//  NSNavigationController.swift
//  HuckleberryGen
//
//  Created by David Vallas on 7/16/15.
//  Copyright © 2015 Phoenix Labs. All rights reserved.
//

import Cocoa

enum BoardLocation {
    case bottomLeft
    case bottomCenter
}

/// Protocol that allows boards to define the navigation
protocol NavControllerPushable {
    var nextBoard: BoardType? { get }
}

/// Protocol that allows boards to gain reference to NavController.  If board conforms to protocol, NavController will assign itself to nav value immediately after board is instantiated.  (Allows Board to run nav commands like disableProgression)
protocol NavControllerReferrable {
    var nav: NavController? { get set }
}

/// protocol that allows the user to take action once the NAV has returned a user inputed decision, use present decision provide a decision board to the user
protocol NavDecisionDelegate: AnyObject {
    func navController(nav: NavController, selectedDecision: DecisionType)
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
    @IBOutlet weak var mutableCancelContraint: NSLayoutConstraint!
    
    weak var delegate: NavControllerDelegate?
    weak var decisionDelegate: NavDecisionDelegate?

    /// enables the next button
    func disableProgression() {
        next.enabled = false
    }
    
    /// disables the next button
    func enableProgression() {
        next.enabled = true
    }
    
    /// removes the navigation controller from the screen
    func end() {
        delegate?.shouldDismiss(self)
    }
    
    /// pops the top most view controller from the navigation controller, if the stack is empty, ends the navigation controller
    func pop() {
        if boardStack.count == 1 {
            end()
        } else {
            pop(animated: true)
        }
    }
    
    private struct BoardInfo {
        let boardType: BoardType
        var saveContext: AnyObject?
    }
    
    var root: BoardType? = nil
    var currentVC: NSViewController? = nil
    
    private var boardStack: [BoardInfo] = []
    
    // MARK: Button Selection
    
    /// action that is run when back button is pressed.  Will pop top controller from stack.  If last controller, dismisses nav controller
    @IBAction func backPressed(sender: AnyObject) {
        pop()
    }
    
    /// action that is run when next button is pressed.  Will push next controller
    @IBAction func nextPressed(sender: AnyObject) {
        
        if let current = currentVC as? NavControllerPushable {
            push(current.nextBoard!, animated: true)
        }
    }
    
    /// present decision board that will auto dismiss once completed
    func presentDecision(withTitle title: String) {
        push(.Decision, animated: true)
        let db = currentVC as! DecisionBoard
        db.question.stringValue = title
        db.delegate = self
    }
    
    /// pushes new boardType onto stack
    func push(board: BoardType, animated: Bool) {
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
        if boardStack.count > 1 {
            back.title = "Back"
            leftCancel()
        } else {
            back.title = "Cancel"
            centerCancel()
        }
    }
    
    private func displayNext() {
        
        if let vc = currentVC as? NavControllerPushable {
            next.hidden = vc.nextBoard == nil ? true : false
        } else {
            next.hidden = true
        }
        self.view.layoutSubtreeIfNeeded()
    }
    
    
}

extension NavController: DecisionBoardDelegate {
    
    func decisionBoard(db db: DecisionBoard, selected: Bool) {
        
    }
}


extension NavController {
    
    /// sets cancel button on left side on nav controller
    private func leftCancel() {
        self.view.removeConstraint(mutableCancelContraint)
        mutableCancelContraint = NSLayoutConstraint(item: back, attribute: .Leading, relatedBy: .Equal, toItem: view, attribute: .Leading, multiplier: 1, constant: 20.0)
        self.view.addConstraint(mutableCancelContraint)
    }
    
    /// sets cancel button in center of nav controller
    private func centerCancel() {
        self.view.removeConstraint(mutableCancelContraint)
        mutableCancelContraint = NSLayoutConstraint(item: back, attribute: .CenterX, relatedBy: .Equal, toItem: view, attribute: .CenterX, multiplier: 1, constant: 0.0)
        self.view.addConstraint(mutableCancelContraint)
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


