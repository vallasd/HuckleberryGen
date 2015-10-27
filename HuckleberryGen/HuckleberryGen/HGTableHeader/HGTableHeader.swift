//
//  HGTableHeader.swift
//  HuckleberryGen
//
//  Created by David Vallas on 9/3/15.
//  Copyright © 2015 Phoenix Labs. All rights reserved.
//

import Cocoa

protocol HGTableHeaderDelegate: AnyObject {
    func hgtableheaderDidAdd(header: HGTableHeader)
}

class HGTableHeader: NSTableHeaderView {
    
    weak var delegate: HGTableHeaderDelegate?
    
    @IBAction func pressedAdd(sender: AnyObject) {
        delegate?.hgtableheaderDidAdd(self)
    }
    
}