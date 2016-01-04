//
//  HGNotif.swift
//  HuckleberryGen
//
//  Created by David Vallas on 9/10/15.
//  Copyright © 2015 Phoenix Labs. All rights reserved.
//

import Foundation

class HGNotif {
    
    static func removeObserver(object: AnyObject) {
        NSNotificationCenter.defaultCenter().removeObserver(object)
    }
    
    static func addObserverForName(name: String, usingBlock block: (NSNotification) -> Void) {
        asyncObserveOnMainThreadForName(name, usingBlock: block)
    }
    
    static func postNotification(name: String, withObject object: AnyObject) {
        asyncPostOnMainThreadWithName([name], object: object)
    }
    
    static func postNotification(name: String) {
        asyncPostOnMainThreadWithName([name], object: nil)
    }
    
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