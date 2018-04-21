//
//  Relationship.swift
//  HuckleberryGen
//
//  Created by David Vallas on 7/11/15.
//  Copyright © 2015 Phoenix Labs.
//
//  All Rights Reserved.

import AppKit
import CoreData

struct Relationship {
    var tag: Int
    var entity: Entity
    var relType: RelationshipType
    var deletionRule: DeletionRule
}

extension Relationship: TypeRepresentable {
    
    var typeRep: String {
        switch relType {
        case .tooMany: return entity.typeRep.pluralRep
        case .tooOne: return entity.typeRep + "?"
        }
    }
}

extension Relationship: VarRepresentable {
    
    var varRep: String {
        let tagString = tag > 0 ? "\(tag)" : ""
        switch relType {
        case .tooMany: return (entity.varRep.lowerFirstLetter + tagString).setRep
        case .tooOne: return entity.varRep.lowerFirstLetter + tagString
        }
    }
}

extension Relationship: DefaultRepresentable {
    
    var defaultRep: String {
        switch relType {
        case .tooMany: return "nil"
        case .tooOne: return "[]"
        }
    }
}

extension Relationship: DecodeRepresentable {
    
    var decodeRep: String {
        switch relType {
        case .tooMany: return varRep
        case .tooOne: return entity.varRep.nilRep
        }
    }
}

extension Relationship: Hashable { var hashValue: Int { return entity.hashValue } }
extension Relationship: Equatable {}; func ==(lhs: Relationship, rhs: Relationship) -> Bool { return lhs.entity.hashValue == rhs.entity.hashValue }

extension Relationship: HGEncodable {
    
    static var new: Relationship {
        return Relationship(tag: 0, entity: Entity.new, relType: .tooOne, deletionRule: .noAction)
    }
    
    var encode: AnyObject {
        var dict = HGDICT()
        dict["tag"] = tag as AnyObject?
        dict["eTypeRep"] = entity.typeRep as AnyObject?
        dict["relType"] = relType.int as AnyObject?
        dict["deletionRule"] = deletionRule.int as AnyObject?
        return dict as AnyObject
    }
    
    static func decode(object: AnyObject) -> Relationship {
        
        let dict = hgdict(fromObject: object, decoderName: "Relationship")
        let tag = dict["tag"].int
        let entity = dict["eTypeRep"].entity
        let relType = dict["relType"].relationshipType
        let deletionRule =  dict["deletionRule"].deletionRule
        return Relationship(tag: tag, entity: entity, relType: relType, deletionRule: deletionRule)
    }
}

enum DeletionRule: Int16 {
    
    case noAction = 0
    case nullify = 1 
    case cascade = 2
    case deny = 3
    
    static var set: [DeletionRule] { return [.noAction, .nullify, .cascade, .deny] }
    
    var int: Int {
        return Int(self.rawValue)
    }
    
    var string: String {
        switch self {
        case .noAction: return "No Action"
        case .nullify: return "Nullify"
        case .cascade: return "Cascade"
        case .deny: return "Deny"
        }
    }
    
    static func create(int: Int) -> DeletionRule {
        switch int {
        case 0: return .noAction
        case 1: return .nullify
        case 2: return .cascade
        case 3: return .deny
        default:
            HGReportHandler.shared.report("int: |\(int)| is not DeletionRule mapable, using .NoAction", type: .error)
            return .noAction
        }
    }
    
    static func create(string: String) -> DeletionRule {
        switch string {
        case "No Action": return .noAction
        case "Nullify": return .nullify
        case "Cascade": return .cascade
        case "Deny": return .deny
        default:
            HGReportHandler.shared.report("string: |\(string)| is not DeletionRule mapable, using .NoAction", type: .error)
            return .noAction
        }
    }
}

enum RelationshipType {
    
    case tooMany
    case tooOne
    
    static var set: [RelationshipType] = [.tooMany, .tooOne]
    static var imageStringSet = ["toManyIcon", "toOneIcon"]
    
    var image: NSImage {
        get {
            switch self {
            case .tooMany: return NSImage(named: NSImage.Name(rawValue: "toManyIcon"))!
            case .tooOne: return NSImage(named: NSImage.Name(rawValue: "toOneIcon"))!
            }
        }
    }
    
    var int: Int {
        switch self {
        case .tooMany: return 0
        case .tooOne: return 1
        }
    }
    
    static func create(int: Int) -> RelationshipType {
        switch int {
        case 0: return .tooMany
        case 1: return .tooOne
        default:
            HGReportHandler.shared.report("int: |\(int)| is not RelationshipType mapable, using .Nullify", type: .error)
            return .tooOne
        }
    }
    
    static func create(string: String) -> RelationshipType {
        switch string {
        case "YES", "TooMany": return .tooMany
        case "NO", "TooOne": return .tooOne
        default:
            HGReportHandler.shared.report("string: |\(string)| is not RelationshipType mapable, using .TooOne", type: .error)
            return .tooOne
        }
    }
    
}


