//
//  DecisionBoard.swift
//  HuckleberryGen
//
//  Created by David Vallas on 10/26/15.
//  Copyright © 2015 Phoenix Labs. All rights reserved.
//

import Cocoa

protocol DecisionBoardDelegate: AnyObject {
    func decisionboardQuestion(db: DecisionBoard) -> String
    func decisionboard(db: DecisionBoard, didChoose: Bool)
}

/// lets DecisionBoardDelegate decide what action to perform after DidChoose is called.  Default is .End, so implement this protocol if you want the Decision Board to do something else besides remove itself
protocol DecisionBoardDelegateProgressable: DecisionBoardDelegate {
    func decisionboardNavAction(db: DecisionBoard) -> NavAction
}

/// lets DecisionBoardDelegate display options with a cancel button
protocol DecisionBoardDelegateCancelable: DecisionBoardDelegate {
    func decisionboardCanCancel(db: DecisionBoard) -> Bool
}

class DecisionBoard: NSViewController, NavControllerReferable {
    
    /// a context that will allow the Decision Board to execute
    private var context: DecisionBoardDelegate! {
        didSet {
            if let c = context as? DecisionBoardDelegateProgressable { contextProgressable = c }
            if let c = context as? DecisionBoardDelegateCancelable { contextCancelable = c }
        }
    }
    
    private weak var contextProgressable: DecisionBoardDelegateProgressable?
    private weak var contextCancelable: DecisionBoardDelegateCancelable?
    
    /// reference to the Nav Controller
    weak var nav: NavController?
    
    /// the text field that contains the decision question posed to the user ( like ... Do you want to delete items? )
    @IBOutlet weak var question: NSTextField!
    
    @IBAction func yesPressed(sender: NSButton) {
        context?.decisionboard(self, didChoose: true)
        performAction()
    }
    
    @IBAction func noPressed(sender: NSButton) {
        context?.decisionboard(self, didChoose: false)
        performAction()
    }
    
    private func performAction() {
        
        /// default action is End if we do not have a DecisionBoardDelegateCancelable delegate.
        let navAction = contextProgressable?.decisionboardNavAction(self) ?? .End
        
        switch navAction {
        case .End: nav?.end()
        case .Pop: nav?.pop()
        case .Home: nav?.home()
        default: break // do nothing
        }
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // load question to board from the delegate
        let dQuestion = context.decisionboardQuestion(self)
        question.stringValue = dQuestion
    }
}

extension DecisionBoard: BoardInstantiable {
    
    static var storyboard: String { return "Board" }
    static var nib: String { return "DecisionBoard" }
}

extension DecisionBoard: BoardRetrievable {
    
    func contextForBoard() -> AnyObject { return context }
    
    func set(context context: AnyObject) {
        // assign context if it is of type DecisionBoard
        if let c = context as? DecisionBoardDelegate { self.context = c; return }
        HGReportHandler.report("DecisionBoard Context \(context) not valid", type: .Error)
    }
}

extension DecisionBoard: NavControllerRegressable {
    
    func navcontrollerRegressionTypes(nav: NavController) -> [RegressionType] {
        let canCancel = contextCancelable?.decisionboardCanCancel(self) ?? false
        if canCancel { return [.Cancel] }
        return [] // we do not want a cancel option
    }
    
    func navcontroller(nav: NavController, hitRegressWithType: RegressionType) {
        // do nothing
    }
}

