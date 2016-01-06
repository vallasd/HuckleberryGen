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

enum ButtonType {
    
    case Cancel
    case Back
    case Next
    case Finished
    
    init(int: Int) {
        switch int {
        case 1: self = .Cancel
        case 2: self = .Back
        case 3: self = .Next
        case 4: self = .Finished
        default:
            HGReportHandler.report("ButtonType: |\(int)| is not ButtonType mapable, returning .Cancel", response: .Error)
            self = .Cancel
        }
    }
    
    var string: String {
        switch self {
        case .Cancel: return "Cancel"
        case .Back: return "Back"
        case .Next: return "Next"
        case .Finished: return "Finished"
        }
    }
    
    var int: Int {
        switch self {
        case .Cancel: return 1
        case .Back: return 2
        case .Next: return 3
        case .Finished: return 4
        }
    }
    
    static func isProgressionType(tag: Int) -> Bool {
        if tag == 3 || tag == 4 { return true }
        return false
    }
    
}

// MARK: NavController Protocols

/// Protocol that allows boards to decide whether or not a Cancel button is presented when the board is last in the stack.  Nav Controller will always add Cancel button (if Board is last left in stack) unless this protocol is used by the board.
protocol NavControllerCancelable {
    var canCancel: Bool { get }
}

/// Protocol that allows boards to define the navigation for the next Board.  If BoardType is left as nil, user will have a finished option that will end the entire navigation controller.
protocol NavControllerPushable {
    var nextBoard: BoardType? { get }
}

/// Protocol that allows boards to gain reference to NavController.  If board conforms to protocol, NavController will assign itself to nav value immediately after board is instantiated.
protocol NavControllerReferrable {
    var nav: NavController? { get set }
}

// Protocol that allows boards to sav and retrieve context from Nav Controller.
protocol NavSavable {
    var saveContext: AnyObject { get }
    func updateWithSavedContext(saveContext: AnyObject)
}

/// Protocol that allows another object to handle delegation methods from nav controller (like dismiss)
protocol NavControllerDelegate: AnyObject {
    func shouldDismiss(nav: NavController)
}

class NavController: NSViewController {
    
    // MARK: Variables
    
    @IBOutlet weak var container: NSView!
    @IBOutlet weak var buttonA: NSButton!
    @IBOutlet weak var buttonB: NSButton!
    @IBOutlet weak var AConstraint: NSLayoutConstraint!
    @IBOutlet weak var BConstraint: NSLayoutConstraint!
    
    weak var delegate: NavControllerDelegate?
    
    /// reference to the root view controllers board type
    var root: BoardType? = nil
    
    /// reference to the current view controller being displayed
    var currentVC: NSViewController? = nil
    
    /// reference to the decision board if it is currently popped over, set to nil when board is not presented on screen
    private(set) var decisionBoard: DecisionBoard?
    
    /// tells user last button pressed in the nav controller, resets to None once next view is displayed
    private(set) var lastButtonPressed: ButtonType?
    
    /// stack of boards currently in the nav controller
    private var boardStack: [BoardInfo] = []
    
    /// struct that contains information about a particular board.  Used for board and state retrieval during navigation.
    private struct BoardInfo {
        let boardType: BoardType
        var saveContext: AnyObject?
    }
    
    // MARK: Public functions

    /// enables the ability for the navigation controller to progress forward
    func disableProgression() {
        if ButtonType.isProgressionType(buttonA.tag) { buttonA.enabled = false }
        if ButtonType.isProgressionType(buttonB.tag) { buttonB.enabled = false }
    }
    
    /// disables the ability for the navigation controller to progress forward
    func enableProgression() {
        if ButtonType.isProgressionType(buttonA.tag) { buttonA.enabled = true }
        if ButtonType.isProgressionType(buttonB.tag) { buttonB.enabled = true }
    }
    
    /// pushes new boardType onto stack
    func push(board: BoardType, animated: Bool) {
        removeTopView()
        saveCurrentBoard()
        boardStack.append(BoardInfo(boardType: board, saveContext: nil))
        createVC(forBoardType: board)
        updateButtons()
        addTopView()
    }
    
    /// pops the top most view controller from the navigation controller, if the stack is empty, ends() the navigation controller
    func pop() {
        if boardStack.count == 1 {
            end()
        } else {
            pop(animated: true)
        }
    }
    
    /// attempts to remove the navigation controller from the screen.  A call is made to the nav controller delegates that the controller wants to be dismissed.
    func end() {
        delegate?.shouldDismiss(self)
    }
    
    /// creates a decision board pop over that will return a YES or NO user inputted answer to your question.  It is the delegates responsibility to run popDecision and handle the DecisionBoardDelegate method.
    func popoverDecision(withTitle title: String, delegate: DecisionBoardDelegate) {
        decisionBoard = BoardType.Decision.create() as? DecisionBoard
        currentVC?.view.hidden = true
        container.addSubview(decisionBoard!.view)
        decisionBoard?.question.stringValue = title
        decisionBoard?.delegate = delegate
        decisionBoard?.popWhenPressed = false
        updateButtons()
    }
    
    /// pops decision board from nav controller
    func popDecision() {
        decisionBoard?.view.removeFromSuperview()
        decisionBoard = nil
        currentVC?.view.hidden = false
        updateButtons()
    }

    // MARK: Button Control
    
    /// action that is run when back button is pressed.  Will pop top controller from stack.  If last controller, dismisses nav controller
    @IBAction func buttonPressed(sender: NSButton) {
        
        let buttontype = ButtonType(int: sender.tag)
        lastButtonPressed = buttontype
        
        // if this is a decision board we just pop that board which is not part of the boardstack and return out of function
        if decisionBoard != nil {
            popDecision()
            return
        }
        
        // we take appropriate action based on button's ButtonType
        switch buttontype {
        case .Cancel:
            end()
        case .Back:
            pop()
        case .Next:
            let current = currentVC as! NavControllerPushable
            let nextBoard = current.nextBoard!
            push(nextBoard, animated: true)
        case .Finished:
            end()
        }
    }
    
    // MARK: Navigation Control
    
    /// pops last boardType from stack
    private func pop(animated animated: Bool) {
        removeTopView()
        boardStack.removeLast()
        createVC(forBoardType: boardStack.last!.boardType)
        updateButtons()
        addTopView()
    }
    
    /// creates NSViewController from a board type.  Sets delegates as appropriate.
    private func createVC(forBoardType boardtype: BoardType) {
        
        // create and assign new currentVC
        currentVC = boardtype.create()
        
        // reset last button pressed to nothing
        lastButtonPressed = nil
        
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
    
    // MARK: Navigation State Persistence
    
    func saveCurrentBoard() {
        if let saveableVC = currentVC as? NavSavable {
            let oldboardinfo = boardStack.last!
            let newboardinfo = BoardInfo(boardType: oldboardinfo.boardType, saveContext: saveableVC.saveContext)
            boardStack[boardStack.count - 1] = newboardinfo
        }
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

}

// MARK: Button Update

extension NavController {
    
    /// top level update Button Titles that handles all cases
    private func updateButtons() {
        
        // If we are displaying a decision board, show buttons for the Board, else display regular buttons
        if decisionBoard != nil {
            updateButtonsForDecision()
        } else {
            updateButtonsForGenericBoard()
        }
        
        // enables progression on buttons
        enableProgression()
    }
    
    
    /// updates button titles and display based on multiple aspects that affect the state of the nav controller
    private func updateButtonsForGenericBoard() {
        
        // we will determine
        var atype: ButtonType? = nil
        var btype: ButtonType? = nil
        
        // we check certain nav controller and board states that will be used to determine buttons
        let vc = currentVC as? NavControllerPushable
        let cancelvc = currentVC as? NavControllerCancelable
        let isNavControllerPushable = vc != nil ? true : false
        let hasNextBoard = vc?.nextBoard != nil ? true : false
        let firstBoard = boardStack.count == 1 ? true : false
        let canCancel = cancelvc?.canCancel == false ? false : true
        
        
        // we determine four possible button types that could be needed (at most 2 of 4 will be needed because these are two mutually exclusive sets)
        let needsBack = !firstBoard ? true : false
        let needsFinish = (isNavControllerPushable && !hasNextBoard) ? true : false
        let needsNext = (isNavControllerPushable && hasNextBoard) ? true : false
        let needsCancel = firstBoard && !needsFinish && canCancel
        
        // needsBack and needsCancel are mutually exclusive and tags are always assigned to buttonA if they are needed
        if needsBack { atype = .Back }
        if needsCancel { atype = .Cancel }
        
        // needsFinish and needsNext are mutually exclusive and tags are are assigned to first available button ( A if available or B )
        if atype == nil {
            if needsFinish { atype = .Finished }
            if needsNext { atype = .Next }
        } else {
            if needsFinish { btype = .Finished }
            if needsNext { btype = .Next }
        }
        
        // hide buttons that did not get new types, else make sure they are unhidden
        buttonA.hidden = atype == nil ? true : false
        buttonB.hidden = btype == nil ? true : false
        
        // set titles and tags for buttons that are not hidden
        if let a = atype { buttonA.title = a.string; buttonA.tag = a.int }
        if let b = btype { buttonB.title = b.string; buttonB.tag = b.int }
        
        // if there are two buttons (we have a btype) - move buttonA left, else move buttonA center *** buttonB always stays right
        if btype == nil { buttonACenter() }
        else { buttonALeft() }
    }
    
    /// updates button titles and display based if a Decision Board is popped over.  Always has a cancel button so user can back out.
    private func updateButtonsForDecision() {
        
        let a = ButtonType.Cancel
        buttonA.title = a.string
        buttonA.hidden = false
        buttonACenter()
        
        buttonB.hidden = true
    }
}


// MARK: Determine Button Locations

extension NavController {
    
    /// sets buttonA button on left side on nav controller
    private func buttonALeft() {
        self.view.removeConstraint(AConstraint)
        AConstraint = NSLayoutConstraint(item: buttonA, attribute: .Leading, relatedBy: .Equal, toItem: view, attribute: .Leading, multiplier: 1, constant: 20.0)
        self.view.addConstraint(AConstraint)
    }
    
    /// sets buttonA in center of nav controller
    private func buttonACenter() {
        self.view.removeConstraint(AConstraint)
        AConstraint = NSLayoutConstraint(item: buttonA, attribute: .CenterX, relatedBy: .Equal, toItem: view, attribute: .CenterX, multiplier: 1, constant: 0.0)
        self.view.addConstraint(AConstraint)
    }
    
}


