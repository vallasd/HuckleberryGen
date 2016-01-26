//
//  AppDelegate.swift
//  HuckleberryGen
//
//  Created by David Vallas on 7/11/15.
//  Copyright © 2015 Phoenix Labs. All rights reserved.
//

import Cocoa

/// global reference to the app Delegate.
let appDelegate = NSApplication.sharedApplication().delegate as! AppDelegate

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    weak var mainWindowController: MainWindowController!
    
    var store: HuckleberryGen = HuckleberryGen(uniqIdentifier: "defaultStore")
    
    func applicationDidFinishLaunching(aNotification: NSNotification) {
        
        // Insert code here to initialize your application
        
        // Nice For Debugging
        // NSUserDefaults.standardUserDefaults().setBool(true, forKey: "NSConstraintBasedLayoutVisualizeMutuallyExclusiveConstraints")
        
//         // clear store
//         store.clear()
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
        store.save()
    }
}

