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

class DecisionBoard: NSViewController {
    
    weak var delegate: DecisionBoardDelegate?
    @IBOutlet weak var question: NSTextField!
    
    @IBAction func yesPressed(sender: NSButton) {
        decision = .Yes
    }
    
    @IBAction func noPressed(sender: NSButton) {
        decision = .No
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
    var nextString: String? { return nil }
    var nextLocation: BoardLocation { return .bottomRight }
}
