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
        let command = theEvent.command()
        switch command {
        case .TabLeft: selectPreviousTabViewItem(self)
        case .TabRight: selectNextTabViewItem(self)
        default: break // Do Nothing
        }
    }
}
