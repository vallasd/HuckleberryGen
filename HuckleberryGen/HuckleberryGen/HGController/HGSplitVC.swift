//
//  HGSplitVC.swift
//  HuckleberryGen
//
//  Created by David Vallas on 9/6/15.
//  Copyright © 2015 Phoenix Labs. All rights reserved.
//

import Cocoa

class HGSplitVC: NSViewController {
    
    let hgsplit = HGSplit()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        controlSplits(inView: view)
        hgsplit.openall(false)
        
    }
    
    private func controlSplits(inView view: NSView) {
        for subview in view.subviews {
            if let splitview = subview as? NSSplitView {
                let dividers = splitview.numDividers()
                if dividers == 1 {
                    if splitview.vertical  { hgsplit.add(splitview, proportion: .Half, reverse: false) }
                    else { hgsplit.add(splitview, proportion: .Half, reverse: true) }
                } else {
                    hgsplit.add(splitview, proportion: .Fifth, reverse: false)
                }
            }
        } 
    }
}

