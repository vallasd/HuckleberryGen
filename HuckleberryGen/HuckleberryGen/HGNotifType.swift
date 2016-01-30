//
//  HGNotifType.swift
//  HuckleberryGen
//
//  Created by David Vallas on 1/4/16.
//  Copyright © 2016 Phoenix Labs. All rights reserved.
//

import Foundation

enum HGNotifType {
    
    case ProjectChanged
    case EntityUpdated
    case EntitySelected
    case EnumUpdated
    case EnumSelected
    case EnumCaseUpdated
    case EnumCaseSelected
    case AttributeUpdated
    case AttributeSelected
    case RelationshipUpdated
    case RelationshipSelected
    
    /// returns a string that identifies the HGNotifType
    var string: String {
        switch self {
        case ProjectChanged: return "ProjectChanged"
        case EntityUpdated: return "EntityUpdated"
        case EntitySelected: return "EntitySelected"
        case EnumUpdated: return "EnumUpdated"
        case EnumSelected: return "EnumSelected"
        case EnumCaseUpdated: return "EnumCaseUpdated"
        case EnumCaseSelected: return "EnumCaseSelected"
        case AttributeUpdated: return "AttributeUpdated"
        case AttributeSelected: return "AttributeSelected"
        case RelationshipUpdated: return "RelationshipUpdated"
        case RelationshipSelected: return "RelationshipSelected"
        }
    }
}

extension HGNotifType {
    
    /// returns a unique string that identifies an HGNotifType for a particular uniq ID
    func uniqString(forUniqId uniqID: String) -> String {
        let string = self.string
        return string + "_" + uniqID
    }
    
    /// returns a list of uniq strings that identifies an HGNotifTypes for a particular uniq ID
    static func uniqStrings(forNotifTypes notifTypes: [HGNotifType], uniqID: String) -> [String] {
        var strings: [String] = []
        for notif in notifTypes {
            let string = notif.uniqString(forUniqId: uniqID)
            strings.append(string)
        }
        return strings
    }
}