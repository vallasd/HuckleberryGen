//
//  HGNotif.swift
//  HuckleberryGen
//
//  Created by David Vallas on 9/10/15.
//  Copyright © 2015 Phoenix Labs. All rights reserved.
//

import Foundation

class HGNotif {
    
    static let shared = HGNotif()
    
    // MARK: Notifications
    
    let notifEntityUpdate: String = "notifEntityUpdate"
    let notifNewEntitySelected: String = "notifNewEntitySelected"
    let notifEnumUpdate: String = "notifEnumUpdate"
    let notifNewEnumSelected: String = "notifNewEnumSelected"
    let notifEnumCaseUpdate: String = "notifEnumCaseUpdate"
    let notifNewEnumCaseSelected: String = "notifNewEnumCaseSelected"
    let notifAttributeUpdate: String = "notifAttributeUpdate"
    let notifNewAttributeSelected: String = "notifNewAttributeSelected"
    let notifRelationshipUpdate: String = "notifRelationshipUpdate"
    let notifNewRelationshipSelected: String = "notifNewRelationshipSelected"
    
    func removeObserver(object: AnyObject) {
        NSNotificationCenter.defaultCenter().removeObserver(object)
    }
    
    func postNotificationForModelUpdate() {
        let notifs = [notifEntityUpdate, notifEnumUpdate, notifAttributeUpdate, notifEnumUpdate, notifEnumCaseUpdate]
        postNotifications(notifs)
    }
    
    func addObserverForName(name: String, usingBlock block: (NSNotification) -> Void) {
        asyncObserveOnMainThreadForName(name, usingBlock: block)
    }
    
    func postNotification(name: String, withObject object: AnyObject) {
        asyncPostOnMainThreadWithName([name], object: object)
    }
    
    func postNotification(name: String) {
        asyncPostOnMainThreadWithName([name], object: nil)
    }
    
    func postNotifications(names: [String]) {
        asyncPostOnMainThreadWithName(names, object: nil)
    }
    
    private func asyncPostOnMainThreadWithName(names: [String], object: AnyObject?) {
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            for name in names {
                NSNotificationCenter.defaultCenter().postNotificationName(name, object: object)
            }
        }
    }
    
    private func asyncObserveOnMainThreadForName(name: String, usingBlock block: (NSNotification) -> Void) {
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            NSNotificationCenter.defaultCenter().addObserverForName(name, object: nil, queue: nil, usingBlock: block)
        }
    }
    
}