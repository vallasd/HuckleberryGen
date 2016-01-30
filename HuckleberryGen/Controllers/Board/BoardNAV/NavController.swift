//
//  NSNavigationController.swift
//  HuckleberryGen
//
//  Created by David Vallas on 7/16/15.
//  Copyright © 2015 Phoenix Labs. All rights reserved.
//

import Cocoa

/// structure that allows a user to create a board.
struct BoardData {
    let storyboard: String
    let nib: String
    let context: AnyObject?
}

enum BoardLocation {
    case bottomLeft
    case bottomCenter
}

/// structure that allows a user to create a board.
enum NavAction {
    case None
    case Pop
    case End
    case Home
}

// types that increase stack depth
enum ProgressionType {
    
    case Next
    case Finished
    
    init(int: Int) {
        switch int {
        case 900: self = .Next
        case 901: self = .Finished
        default:
            HGReportHandler.shared.report("Int: |\(int)| is not ProgressionType mapable, returning .Next", type: .Error)
            self = .Next
        }
    }
    
    var string: String {
        switch self {
        case .Next: return "Next"
        case .Finished: return "Finished"
        }
    }
    
    var int: Int {
        switch self {
        case .Next: return 900
        case .Finished: return 901
        }
    }
    
    static func isValid(tag: Int) -> Bool {
        if tag == 900 || tag == 901 { return true }
        return false
    }
}

// types that decrease stack depth
enum RegressionType {
    
    case Cancel
    case Back
    case Home
    
    init(int: Int) {
        switch int {
        case 800: self = .Cancel
        case 801: self = .Back
        case 802: self = .Home
        default:
            HGReportHandler.shared.report("Int: |\(int)| is not RegressionType mapable, returning .Cancel", type: .Error)
            self = .Cancel
        }
    }
    
    var string: String {
        switch self {
        case .Cancel: return "Cancel"
        case .Back: return "Back"
        case .Home: return "Home"
        }
    }
    
    var int: Int {
        switch self {
        case .Cancel: return 800
        case .Back: return 801
        case .Home: return 802
        }
    }
    
    static func isValid(tag: Int) -> Bool {
        if tag >= 800 && tag <= 802 { return true }
        return false
    }
}

// MARK: BoardNav Protocols

/// protocol that allows a board to be instantiated from a NIB
protocol BoardInstantiable {
    static var storyboard: String { get }
    static var nib: String { get }
}

extension BoardInstantiable {
    static var boardData: BoardData { return BoardData(storyboard: self.storyboard, nib: self.nib, context: nil) }
    static func boardData(withContext context: AnyObject) -> BoardData { return BoardData(storyboard: self.storyboard, nib: self.nib, context: context) }
}

/// protocol that allows a board to be set or retrieved
protocol BoardRetrievable: BoardInstantiable {
    func contextForBoard() -> AnyObject
    func set(context context: AnyObject)
}

extension BoardRetrievable {
    func boardData() -> BoardData { return BoardData(storyboard: self.dynamicType.storyboard, nib: self.dynamicType.nib, context: contextForBoard()) }
}

/// protocol which allows object to define the nav controller regression buttons.  [CANCEL || BACK] will be used as Cancel.  If two buttons are used, Nav Controller will not use progression buttons.  Note, by default, the Nav Controller will assume that the user wants a CANCEL button.
protocol NavControllerRegressable {
    func navcontrollerRegressionTypes(nav: NavController) -> [RegressionType]
    func navcontroller(nav: NavController, hitRegressWithType: RegressionType)
}

/// protocol which allows object to define the nav controller progression buttons.  If FINISHED is defined, nav controller will auto dismiss itself after hitProgressWithType is called.  If NEXT is defined, object conforming to protocol needs to push the next Board Info when hitProgressWithType is called.
protocol NavControllerProgessable {
    func navcontrollerProgressionType(nav: NavController) -> ProgressionType
    func navcontroller(nav: NavController, hitProgressWithType progressionType: ProgressionType)
}

/// protocol that allows a Nav Controller's NSViewController to gain reference to the nav controller when it is added to the stack.
protocol NavControllerReferable {
    weak var nav: NavController? { get set }
}

/// protocol that allows another object to handle delegation methods from nav controller (like dismiss)
protocol NavControllerDelegate: AnyObject {
    func navcontrollerShouldDismiss(nav: NavController)
}

class NavController: NSViewController {
    
    // MARK: Variables
    
    @IBOutlet weak var container: NSView!
    @IBOutlet weak var buttonA: NSButton!
    @IBOutlet weak var buttonB: NSButton!
    @IBOutlet weak var AConstraint: NSLayoutConstraint!
    @IBOutlet weak var BConstraint: NSLayoutConstraint!
    
    weak var delegate: NavControllerDelegate?
    
    /// board data that should be loaded when viewDidLoad is called.  Set this and the initial controller will be pushed at the appropriate time
    var loadData: BoardData?
    
    /// reference to the current view controller being displayed
    var currentVC: NSViewController? = nil
    
    /// stack that holds references to the BoardData
    private(set) var boardStack: [BoardData] = []
    
    /// tells us if this is the first View Controller in the Navigation Controller
    var onRootVC: Bool { return boardStack.count == 1 ? true : false }
    
    // MARK: Public functions

    /// enables the ability for the navigation controller to progress forward (Finish or Next)
    func disableProgression() {
        if ProgressionType.isValid(buttonA.tag) { buttonA.enabled = false }
        if ProgressionType.isValid(buttonB.tag) { buttonB.enabled = false }
    }
    
    /// disables the ability for the navigation controller to progress forward (Finish or Next)
    func enableProgression() {
        if ProgressionType.isValid(buttonA.tag) { buttonA.enabled = true }
        if ProgressionType.isValid(buttonB.tag) { buttonB.enabled = true }
    }
    
    /// pushes new boardType onto stack.  Do not use this for the first board, just set loadData for first board.
    func push(boardData: BoardData) {
        saveCurrentBoardContext()
        removeTopView()
        boardStack.append(boardData)
        setCurrentVC(withBoardData: boardData)
        updateButtons()
        addTopView()
    }
    
    /// pops the top most view controller from the navigation controller, if the stack is empty, ends() the navigation controller
    func pop() {
        
        if onRootVC {
            end()
            return
        }
        
        // pop from stack
        removeTopView()
        boardStack.removeLast()
        setCurrentVC(withBoardData: boardStack.last!)
        updateButtons()
        addTopView()
    }
    
    /// attempts to remove the navigation controller from the screen.  A call is made to the nav controller delegates that the controller wants to be dismissed.
    func end() {
        boardStack.removeAll()
        currentVC?.view.removeFromSuperview()
        currentVC = nil
        delegate?.navcontrollerShouldDismiss(self)
    }
    
    func home() {
        print("NOT IMPLEMENTED YET")
    }
    
    /// action that is run when back button is pressed.  Will pop top controller from stack.  If last controller, dismisses nav controller
    @IBAction func buttonPressed(sender: NSButton) {
        
        let tag = sender.tag
        
        if ProgressionType.isValid(tag) {
            
            // define ProgressionType and Notify currentVC if it is NavControllerProgessable
            let type = ProgressionType(int: tag)
            
            if let vc = currentVC as? NavControllerProgessable {
                vc.navcontroller(self, hitProgressWithType: type)
            }
            
            switch type {
            case .Next: break
            case .Finished: end()
            }
        }
        
        if RegressionType.isValid(tag) {
            
            // define ProgressionType and Notify currentVC if it is NavControllerProgessable
            let type = RegressionType(int: tag)
            
            if let vc = currentVC as? NavControllerRegressable {
                vc.navcontroller(self, hitRegressWithType: type)
            }
            
            switch type {
            case .Cancel: end()
            case .Back: pop()
            case .Home: home()
            }
        }
    }
    
    /// creates NSViewController from a board type.  Sets delegates as appropriate.
    private func setCurrentVC(withBoardData boardData: BoardData) {
        
        // create and assign new currentVC
        let storyboard = NSStoryboard(name: boardData.storyboard, bundle: nil)
        currentVC = storyboard.instantiateControllerWithIdentifier(boardData.nib) as? NSViewController
        
        // check success of VC instantiation from nib
        if currentVC == nil {
            HGReportHandler.shared.report("Nav Controller, currentVC was not properly instantiated from BoardData", type: .Error)
            return
        }
        
        // update context if necessary
        if let context = boardData.context {
            if let saveableVC = currentVC as? BoardRetrievable {
                saveableVC.set(context: context)
            } else {
                HGReportHandler.shared.report("Nav Controller, attempting to set context for NSViewController that is not BoardRetrievable", type: .Error)
            }
        }
        
        // assign nav reference to NavControllerReferable
        if var ncr = currentVC as? NavControllerReferable {
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
    
    func saveCurrentBoardContext() {
        if let vc = currentVC as? BoardRetrievable {
            let vcIndex = boardStack.count - 1
            boardStack[vcIndex] = vc.boardData()
        }
    }
    
    // MARK: LifeCycle
    
    override func viewDidLoad() {
        
        // make background transparent
        view.backgroundColor(HGColor.Clear)
        
        // load initial data for the Nav Controller
        if let ld = loadData { push(ld) }
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
        
        // performs multiple analysis to determine the proper buttons to be displayed on nav controller
        updateButtonsForBoard()
        
        // enables progression on buttons
        enableProgression()
    }
    
    /// updates button titles and display based on multiple aspects that affect the state of the nav controller.  The Nav controller has two buttons (A and B), we assign them tasks, maybe hide them, depending on what the nav controller delegates (NavControllerProgessable / NavControllerRegressable) tells us to do.
    private func updateButtonsForBoard() {
        
        // tags to be used on buttons, currently set to 0
        var atag = 0
        var btag = 0
        
        // determine progression and regression types asked from currentVC
        let progressVC = currentVC as? NavControllerProgessable
        let regressVC = currentVC as? NavControllerRegressable
        let progressType = progressVC?.navcontrollerProgressionType(self)
        let regressTypes = regressVC?.navcontrollerRegressionTypes(self)
        
        let asksNext = progressType == .Next ? true : false
        let asksFinished = progressType == .Finished ? true : false
        
        var asksCancel = true // default is for a cancel button
        var asksHome = false
        
        if let rt = regressTypes {
            asksCancel = rt.contains(.Cancel) || rt.contains(.Back) ? true : false
            asksHome = rt.contains(.Home) ? true : false
        }
        
        // we determine four possible button types that could be needed (at most 2 of 4 will be needed because these are two mutually exclusive sets)
        let needsBack = !onRootVC
        let needsFinish = asksFinished ? true : false
        let needsNext = asksNext ? true : false
        let needsCancel = asksCancel && !needsBack
        let needsHome = asksHome && !onRootVC
        
        // needsBack and needsCancel are mutually exclusive and tags are always assigned to buttonA if they are needed
        if needsBack { atag = RegressionType.Back.int }
        if needsCancel { atag = RegressionType.Cancel.int }
        
        // check if we need HOME
        if atag == 0 && needsHome { atag = RegressionType.Home.int }
        else if btag == 0 && needsHome { btag = RegressionType.Home.int }
        
        // needsFinish and needsNext are mutually exclusive and tags are are assigned to first available button ( A if available or B ).  Not if we already used two regressions (like back and home), we will not have a button for a Progression (we allow just two buttons)
        if atag == 0 {
            if needsFinish { atag = ProgressionType.Finished.int }
            if needsNext { atag = ProgressionType.Next.int }
        } else if btag == 0 {
            if needsFinish { btag = ProgressionType.Finished.int }
            if needsNext { btag = ProgressionType.Next.int }
        }
        
        // hide buttons that did not get new types, else make sure they are unhidden
        buttonA.hidden = atag == 0 ? true : false
        buttonB.hidden = btag == 0 ? true : false
        
        // set titles and tags for buttons that are not hidden
        if atag != 0 { buttonA.title = string(fromTag: atag); buttonA.tag = atag }
        if btag != 0 { buttonB.title = string(fromTag: btag); buttonB.tag = btag }
        
        // if there are two buttons (we have a btype) - move buttonA left, else move buttonA center *** buttonB always stays right
        if btag == 0 { buttonACenter() }
        else { buttonALeft() }
    }
    
    
    /// creates a string given the tag number presented
    func string(fromTag tag: Int) -> String {
    
        if ProgressionType.isValid(tag) {
            return ProgressionType(int: tag).string
        }
        if RegressionType.isValid(tag) {
            return RegressionType(int: tag).string
        }
        
        HGReportHandler.shared.report("\(tag) is Not A Regression or Progression Type Tag", type: .Error)
        return ""
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


