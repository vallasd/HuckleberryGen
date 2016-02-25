//
//  HGEntity.swift
//  HuckleberryGen
//
//  Created by David Vallas on 8/13/15.
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

import Foundation


//enum HGEntity: Int {
//    
//    case Attribute = 0
//    case Entity = 1
//    case Folder = 2
//    case LicenseHeader = 3
//    case Model = 4
//    case Relationship = 5
//    case User = 6
//    case NotDefined = -99
//    
//    // TEST ENTITIES
//    case HGPerson = 1000
//    case HGPie = 1001
//    
//    var name: String {
//        get {
//            switch self {
//            case .Attribute: return "Attribute"
//            case .Entity: return "Entity"
//            case .Folder: return "Folder"
//            case .LicenseHeader: return "LicenseHeader"
//            case .Model: return "Model"
//            case .Relationship: return "Relationship"
//            case .User: return "User"
//            case .NotDefined: return "Not Defined"
//                
//            // TEST ENTITIES
//            case .HGPerson: return "HGPerson"
//            case .HGPie: return "HGPie"
//            }
//        }
//    }
//}

//extension String {
//    
//    func hgEntity() -> HGEntity {
//        switch self {
//        case "Attribute": return .Attribute
//        case "Entity": return .Entity
//        case "Folder": return .Folder
//        case "LicenseHeader": return .LicenseHeader
//        case "Model": return .Model
//        case "Relationship": return .Relationship
//        case "User": return .User
//        default:
//            HGReportHandler.shared.report("string: |\(self)| is not an HGEntity mapable", type: .Error)
//            return .NotDefined
//        }
//    }
//}
//
//extension Int16 {
//    
//    func hgEntity() -> HGEntity {
//        switch self {
//        case 0: return .Attribute
//        case 1: return .Entity
//        case 2: return .Folder
//        case 3: return .LicenseHeader
//        case 4: return .Model
//        case 5: return .Relationship
//        case 6: return .User
//        case -99: return .NotDefined
//        default:
//            HGReportHandler.shared.report("int16: |\(self)| is not an HGEntity mapable", type: .Error)
//            return .NotDefined
//        }
//    }
//}