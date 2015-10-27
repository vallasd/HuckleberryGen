//
//  HGTabVC.swift
//  HuckleberryGen
//
//  Created by David Vallas on 9/29/15.
//  Copyright © 2015 Phoenix Labs. All rights reserved.
//

import Cocoa

/// This class is not implemented yet
class HGTabVC: NSTabViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabView.delegate = self
    }
    
    override func keyDown(theEvent: NSEvent) {
        executeCommand(fromKeyEvent: theEvent)
    }
    
    func executeCommand(fromKeyEvent event: NSEvent) {
        
        let command = event.command()
        
        if command == .HGCommandTabLeft { tabView.selectPreviousTabViewItem(self)  }
        else if command == .HGCommandTabRight { tabView.selectNextTabViewItem(self) }
    }
    
}

