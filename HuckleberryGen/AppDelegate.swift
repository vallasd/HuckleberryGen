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
        
        // let store
        var testStore: Set<Attribute2>  = []
        let _ = testStore.create(entityName: "Entity1")
        let _ = testStore.create(entityName: "Entity1")
        let _ = testStore.create(entityName: "Entity2")
        let _ = testStore.delete(name: "newAttribute1", entityName: "Entity1")
        let keys: [Attribute2KeyPath] = [.name, .entityName]
        let values = ["hello", "Entity1"]
        testStore.update(keys: keys, withValues: values, name: "newAttribute", entityName: "Entity2")
        print(testStore)
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
        store.save()
    }
}

