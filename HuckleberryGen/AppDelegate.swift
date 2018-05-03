//
//  AppDelegate.swift
//  HuckleberryGen
//
//  Created by David Vallas on 7/11/15.
//  Copyright © 2015 Phoenix Labs.
//
//  All Rights Reserved.

import Cocoa

/// global reference to the app Delegate.
let appDelegate = NSApplication.shared.delegate as! AppDelegate
var project: Project { return appDelegate.store.project }

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    weak var mainWindowController: MainWindowController!
    
    var store: HuckleberryGen = HuckleberryGen(uniqIdentifier: "defaultStore")
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        
        // Insert code here to initialize your application
        
        // Nice For Debugging
        UserDefaults.standard.set(true, forKey: "NSConstraintBasedLayoutVisualizeMutuallyExclusiveConstraints")
        
        // clear store
        // store.clear()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
        store.save()
    }
}

