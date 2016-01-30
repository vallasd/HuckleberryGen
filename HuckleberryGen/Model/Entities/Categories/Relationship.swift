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
    var entity: Entity
    var type: RelationshipType
    var deletionRule: DeletionRule
}

extension Relationship: HGTypeRepresentable {
    
    var typeRep: String {
        switch type {
        case .TooMany: return entity.typeRep + "?"
        case .TooOne: return entity.typeRep.pluralRep
        }
    }
}

extension Relationship: HGVarRepresentable {
    
    var varRep: String {
        switch type {
        case .TooMany: return entity.varRep.lowerCaseFirstLetter.setRep
        case .TooOne: return entity.varRep.lowerCaseFirstLetter
        }
    }
}

extension Relationship: HGDefaultRepresentable {
    
    var defaultRep: String {
        switch type {
        case .TooMany: return "nil"
        case .TooOne: return "[]"
        }
    }
}

extension Relationship: HGDecodeRepresentable {
    
    var decodeRep: String {
        switch type {
        case .TooMany: return varRep
        case .TooOne: return entity.varRep.nilRep
        }
    }
}

extension Relationship: Hashable { var hashValue: Int { return entity.name.hashValue } }
extension Relationship: Equatable {}; func ==(lhs: Relationship, rhs: Relationship) -> Bool { return lhs.entity.name == rhs.entity.name }

extension Relationship: HGEncodable {
    
    static var new: Relationship {
        return Relationship(entity: Entity.new, type: .TooOne, deletionRule: .NoAction)
    }
    
    var encode: AnyObject {
        var dict = HGDICT()
        dict["entity"] = entity.encode
        dict["type"] = type.int
        dict["deletionRule"] = deletionRule.int
        return dict
    }
    
    static func decode(object object: AnyObject) -> Relationship {
        
        let dict = hgdict(fromObject: object, decoderName: "Relationship")
        let entity = dict["entity"].entity
        let type = dict["type"].relationshipType
        let deletionRule =  dict["deletionRule"].deletionRule
        var relationship = Relationship(entity: entity, type: type, deletionRule: deletionRule)
        
        // append relationship to below array
        relationship.entity.relationships.append(relationship)
        
        return relationship
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
            HGReportHandler.shared.report("int: |\(int)| is not DeletionRule mapable, using .NoAction", type: .Error)
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
            HGReportHandler.shared.report("string: |\(string)| is not DeletionRule mapable, using .NoAction", type: .Error)
            return .NoAction
        }
    }
}

enum RelationshipType {
    
    case TooMany
    case TooOne
    
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
            HGReportHandler.shared.report("int: |\(int)| is not RelationshipType mapable, using .Nullify", type: .Error)
            return .TooOne
        }
    }
    
    static func create(string string: String) -> RelationshipType {
        switch string {
        case "YES", "TooMany": return .TooMany
        case "NO", "TooOne": return .TooOne
        default:
            HGReportHandler.shared.report("string: |\(string)| is not RelationshipType mapable, using .TooOne", type: .Error)
            return .TooOne
        }
    }
    
}


