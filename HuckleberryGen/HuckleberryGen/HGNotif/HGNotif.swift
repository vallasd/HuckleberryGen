//
//  HGNotif.swift
//  HuckleberryGen
//
//  Created by David Vallas on 9/10/15.
//  Copyright © 2015 Phoenix Labs. All rights reserved.
//

import Foundation

/// This class posts and observes Notifications through the NSNotificationCenter.  This class is thread safe.
class HGNotif {
    
    /// removes object from observing Notifications
    static func removeObserver(object: AnyObject) {
        NSNotificationCenter.defaultCenter().removeObserver(object)
    }
    
    /// adds an observer for a specific notificationName and will perform the block once notification is heard.
    static func addObserverForName(name: String, usingBlock block: (NSNotification) -> Void) {
        asyncObserveOnMainThreadForName(name, usingBlock: block)
    }
    
    /// posts a single notification with an object
    static func postNotification(name: String, withObject object: AnyObject) {
        asyncPostOnMainThreadWithName([name], object: object)
    }
    
    /// posts a single notification without an object
    static func postNotification(name: String) {
        asyncPostOnMainThreadWithName([name], object: nil)
    }
    
    /// posts a multiple notifications without objects
    static func postNotifications(names: [String]) {
        asyncPostOnMainThreadWithName(names, object: nil)
    }
    
    private static func asyncPostOnMainThreadWithName(names: [String], object: AnyObject?) {
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            for name in names {
                NSNotificationCenter.defaultCenter().postNotificationName(name, object: object)
            }
        }
    }
    
    private static func asyncObserveOnMainThreadForName(name: String, usingBlock block: (NSNotification) -> Void) {
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            NSNotificationCenter.defaultCenter().addObserverForName(name, object: nil, queue: nil, usingBlock: block)
        }
    }
    
}