//
//  HGSplitVC.swift
//  HuckleberryGen
//
//  Created by David Vallas on 9/6/15.
//  Copyright © 2015 Phoenix Labs.
//
//  This file is part of HuckleberryGen.
//
//  HuckleberryGen is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  HuckleberryGen is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with HuckleberryGen.  If not, see <http://www.gnu.org/licenses/>.

import Cocoa

class HGSplitVC: NSViewController {
    
    let hgsplit = HGSplit()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        controlSplits(inView: view)
        hgsplit.openall(false)
        
    }
    
    fileprivate func controlSplits(inView view: NSView) {
        for subview in view.subviews {
            if let splitview = subview as? NSSplitView {
                let dividers = splitview.numDividers()
                if dividers == 1 {
                    if splitview.isVertical  { hgsplit.add(splitview, proportion: .half, reverse: false) }
                    else { hgsplit.add(splitview, proportion: .half, reverse: true) }
                } else {
                    hgsplit.add(splitview, proportion: .fifth, reverse: false)
                }
            }
        } 
    }
}

