//
//  DecisionBoard.swift
//  HuckleberryGen
//
//  Created by David Vallas on 10/26/15.
//  Copyright © 2015 Phoenix Labs. All rights reserved.
//

import Cocoa

enum DecisionType {
    case Cancel
    case Yes
    case No
}


protocol DecisionBoardDelegate: AnyObject {
    func decisionBoard(db db: DecisionBoard, selectedDecision: DecisionType)
}

class DecisionBoard: NSViewController, NavControllerReferrable {
    
    /// conforms to DecisionBoardDelegate protocol
    weak var delegate: DecisionBoardDelegate?
    
    weak var nav: NavController?
    
    @IBOutlet weak var question: NSTextField!
    
    @IBAction func yesPressed(sender: NSButton) {
        decision = .Yes
        nav?.end()
    }
    
    @IBAction func noPressed(sender: NSButton) {
        decision = .No
        nav?.end()
    }
    
    private var decision: DecisionType = .Cancel
    
    override func viewWillDisappear() {
        super.viewWillDisappear()
        delegate?.decisionBoard(db: self, selectedDecision: decision)
    }
}

// Will Add a Cancel Button
extension DecisionBoard: NavControllerPushable {
    
    var nextBoard: BoardType? { return nil }
    var nextString: String? { return "Cancel" }
    var nextLocation: BoardLocation { return .bottomRight }
}
