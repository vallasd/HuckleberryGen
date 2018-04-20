//
//  HGNotifType.swift
//  HuckleberryGen
//
//  Created by David Vallas on 1/4/16.
//  Copyright © 2016 Phoenix Labs.
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

import Foundation

enum HGNotifType {
    
    case projectChanged
    case entityUpdated
    case entitySelected
    case enumUpdated
    case enumSelected
    case enumCaseUpdated
    case enumCaseSelected
    case attributeUpdated
    case attributeSelected
    case relationshipUpdated
    case relationshipSelected
    case indexUpdated
    
    /// returns a string that identifies the HGNotifType
    var string: String {
        switch self {
        case .projectChanged: return "ProjectChanged"
        case .entityUpdated: return "EntityUpdated"
        case .entitySelected: return "EntitySelected"
        case .enumUpdated: return "EnumUpdated"
        case .enumSelected: return "EnumSelected"
        case .enumCaseUpdated: return "EnumCaseUpdated"
        case .enumCaseSelected: return "EnumCaseSelected"
        case .attributeUpdated: return "AttributeUpdated"
        case .attributeSelected: return "AttributeSelected"
        case .relationshipUpdated: return "RelationshipUpdated"
        case .relationshipSelected: return "RelationshipSelected"
        case .indexUpdated: return "IndexUpdate"
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
