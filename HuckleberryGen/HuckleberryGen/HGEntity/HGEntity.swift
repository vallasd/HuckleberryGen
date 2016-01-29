//
//  HGEntity.swift
//  HuckleberryGen
//
//  Created by David Vallas on 8/13/15.
//  Copyright © 2015 Phoenix Labs. All rights reserved.
//

import Foundation


enum HGEntity: Int {
    
    case Attribute = 0
    case Entity = 1
    case Folder = 2
    case LicenseHeader = 3
    case Model = 4
    case Relationship = 5
    case User = 6
    case NotDefined = -99
    
    // TEST ENTITIES
    case HGPerson = 1000
    case HGPie = 1001
    
    var name: String {
        get {
            switch self {
            case .Attribute: return "Attribute"
            case .Entity: return "Entity"
            case .Folder: return "Folder"
            case .LicenseHeader: return "LicenseHeader"
            case .Model: return "Model"
            case .Relationship: return "Relationship"
            case .User: return "User"
            case .NotDefined: return "Not Defined"
                
            // TEST ENTITIES
            case .HGPerson: return "HGPerson"
            case .HGPie: return "HGPie"
            }
        }
    }
}

extension String {
    
    func hgEntity() -> HGEntity {
        switch self {
        case "Attribute": return .Attribute
        case "Entity": return .Entity
        case "Folder": return .Folder
        case "LicenseHeader": return .LicenseHeader
        case "Model": return .Model
        case "Relationship": return .Relationship
        case "User": return .User
        default:
            appDelegate.error.report("string: |\(self)| is not an HGEntity mapable", type: .Error)
            return .NotDefined
        }
    }
}

extension Int16 {
    
    func hgEntity() -> HGEntity {
        switch self {
        case 0: return .Attribute
        case 1: return .Entity
        case 2: return .Folder
        case 3: return .LicenseHeader
        case 4: return .Model
        case 5: return .Relationship
        case 6: return .User
        case -99: return .NotDefined
        default:
            appDelegate.error.report("int16: |\(self)| is not an HGEntity mapable", type: .Error)
            return .NotDefined
        }
    }
}