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

class DecisionBoard: NSViewController, NavControllerReferable {
    
    /// a context that will allow the Decision Board to execute
    private var context: DecisionBoardDelegate!
    
    /// action that decision board will take after Button is pressed.  Action is performed after didChoose is executed by delegate, so you are able to change the action in your delegate at that moment.
    var action: NavAction = .End
    
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
        switch action {
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
        HGReportHandler.report("DecisionBoard Context \(context) not valid", response: .Error)
    }
}

extension DecisionBoard: NavControllerRegressable {
    
    func navcontrollerRegressionTypes(nav: NavController) -> [RegressionType] {
        return [] // we do not want a cancel option
    }
    
    func navcontroller(nav: NavController, hitRegressWithType: RegressionType) {
        // do nothing
    }
}

