//
//  HGTabVC.swift
//  HuckleberryGen
//
//  Created by David Vallas on 9/29/15.
//  Copyright © 2015 Phoenix Labs. All rights reserved.
//

import Cocoa

/// This class is not implemented yet
class HGTabView: NSTabView {
    
    override func keyDown(theEvent: NSEvent) {
        executeCommand(fromKeyEvent: theEvent)
    }
    
    func executeCommand(fromKeyEvent event: NSEvent) {
        let command = event.command()
        if command == .HGCommandTabLeft { selectPreviousTabViewItem(nil)  }
        else if command == .HGCommandTabRight { selectNextTabViewItem(nil) }

    }
    
    
//    func set(state: NSTabState) {
//        selectedTabViewItem?.setValue(state, forKey: "tabState")
//    }
}
