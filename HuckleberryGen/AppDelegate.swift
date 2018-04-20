//
//  AppDelegate.swift
//  HuckleberryGen
//
//  Created by David Vallas on 7/11/15.
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

/// global reference to the app Delegate.
let appDelegate = NSApplication.shared().delegate as! AppDelegate

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    weak var mainWindowController: MainWindowController!
    
    var store: HuckleberryGen = HuckleberryGen(uniqIdentifier: "defaultStore")
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        
        // Insert code here to initialize your application
        
        // Nice For Debugging
        // NSUserDefaults.standardUserDefaults().setBool(true, forKey: "NSConstraintBasedLayoutVisualizeMutuallyExclusiveConstraints")
        
        // clear store
        // store.clear()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
        store.save()
    }
}

