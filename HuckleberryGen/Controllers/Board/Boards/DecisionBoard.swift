//
//  DecisionBoard.swift
//  HuckleberryGen
//
//  Created by David Vallas on 10/26/15.
//  Copyright © 2015 Phoenix Labs. All rights reserved.
//

import Cocoa

protocol DecisionBoardDelegate: AnyObject {
    func decisionBoard(db db: DecisionBoard, selected: Bool)
}

class DecisionBoard: NSViewController, NavControllerReferrable {
    
    /// conforms to DecisionBoardDelegate protocol
    weak var delegate: DecisionBoardDelegate?
    
    weak var nav: NavController?
    
    /// pops the decision board from the nav controller when answer selected if this is true
    var popWhenPressed = true
    
    @IBOutlet weak var question: NSTextField!
    
    @IBAction func yesPressed(sender: NSButton) {
        delegate?.decisionBoard(db: self, selected: true)
        if popWhenPressed { nav?.pop() }
    }
    
    @IBAction func noPressed(sender: NSButton) {
        delegate?.decisionBoard(db: self, selected: false)
        if popWhenPressed { nav?.pop() }
    }
}
