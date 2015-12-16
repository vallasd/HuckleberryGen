//
//  Relationship.swift
//  HuckleberryGen
//
//  Created by David Vallas on 7/11/15.
//  Copyright © 2015 Phoenix Labs. All rights reserved.
//

import AppKit
import CoreData

struct Relationship {
    var name: String
    var entity: String
    var type: RelationshipType
    var deletionRule: DeletionRule
    
}

extension Relationship: Hashable { var hashValue: Int { return name.hashValue } }
extension Relationship: Equatable {}; func ==(lhs: Relationship, rhs: Relationship) -> Bool { return lhs.name == rhs.name }

extension Relationship: HGEncodable {
    
    static var new: Relationship {
        return Relationship(name: "New Relationship", entity: "NotDefined", type: .TooOne, deletionRule: .NoAction)
    }
    
    var encode: AnyObject {
        var dict = HGDICT()
        dict["name"] = name
        dict["entity"] = entity
        dict["type"] = type.int
        dict["deletionRule"] = deletionRule.int
        return dict
    }
    
    static func decode(object object: AnyObject) -> Relationship {
        let dict = hgdict(fromObject: object, decoderName: "Relationship")
        let name = dict["name"].string
        let entity = dict["entity"].string
        let type = dict["type"].relationshipType
        let deletionRule =  dict["deletionRule"].deletionRule
        return Relationship(name: name, entity: entity, type: type, deletionRule: deletionRule)
    }
}

enum DeletionRule: Int16 {
    
    case NoAction = 0
    case Nullify = 1 
    case Cascade = 2
    case Deny = 3
    
    static var set: [DeletionRule] { return [.NoAction, .Nullify, .Cascade, .Deny] }
    
    var int: Int {
        return Int(self.rawValue)
    }
    
    var string: String {
        switch self {
        case NoAction: return "No Action"
        case Nullify: return "Nullify"
        case Cascade: return "Cascade"
        case Deny: return "Deny"
        }
    }
    
    static func create(int int: Int) -> DeletionRule {
        switch int {
        case 0: return .NoAction
        case 1: return .Nullify
        case 2: return .Cascade
        case 3: return .Deny
        default:
            HGReportHandler.report("int: |\(int)| is not DeletionRule mapable, using .NoAction", response: .Error)
            return .NoAction
        }
    }
    
    static func create(string string: String) -> DeletionRule {
        switch string {
        case "No Action": return .NoAction
        case "Nullify": return .Nullify
        case "Cascade": return .Cascade
        case "Deny": return .Deny
        default:
            HGReportHandler.report("string: |\(string)| is not DeletionRule mapable, using .NoAction", response: .Error)
            return .NoAction
        }
    }
}

enum RelationshipType: Int16 {
    
    case TooMany = 0
    case TooOne = 1
    
    static var set: [RelationshipType] = [.TooMany, .TooOne]
    static var imageStringSet = ["toManyIcon", "toOneIcon"]
    
    var image: NSImage {
        get {
            switch self {
            case TooMany: return NSImage(named: "toManyIcon")!
            case TooOne: return NSImage(named: "toOneIcon")!
            }
        }
    }
    
    var int: Int {
        switch self {
        case TooMany: return 0
        case TooOne: return 1
        }
    }
    
    static func create(int int: Int) -> RelationshipType {
        switch int {
        case 0: return .TooMany
        case 1: return .TooOne
        default:
            HGReportHandler.report("int: |\(int)| is not RelationshipType mapable, using .Nullify", response: .Error)
            return .TooOne
        }
    }
    
    static func create(string string: String) -> RelationshipType {
        switch string {
        case "YES", "TooMany": return .TooMany
        case "NO", "TooOne": return .TooOne
        default:
            HGReportHandler.report("string: |\(string)| is not RelationshipType mapable, using .Nullify", response: .Error)
            return .TooOne
        }
    }
    
}