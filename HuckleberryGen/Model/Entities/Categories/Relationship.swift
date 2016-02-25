//
//  Relationship.swift
//  HuckleberryGen
//
//  Created by David Vallas on 7/11/15.
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

//  You should have received a copy of the GNU General Public License
//  along with HuckleberryGen.  If not, see <http://www.gnu.org/licenses/>.

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
        case .TooMany: return entity.typeRep.pluralRep
        case .TooOne: return entity.typeRep + "?"
        }
    }
}

extension Relationship: VarRepresentable {
    
    var varRep: String {
        let tagString = tag > 0 ? "\(tag)" : ""
        switch relType {
        case .TooMany: return (entity.varRep.lowerCaseFirstLetter + tagString).setRep
        case .TooOne: return entity.varRep.lowerCaseFirstLetter + tagString
        }
    }
}

extension Relationship: DefaultRepresentable {
    
    var defaultRep: String {
        switch relType {
        case .TooMany: return "nil"
        case .TooOne: return "[]"
        }
    }
}

extension Relationship: DecodeRepresentable {
    
    var decodeRep: String {
        switch relType {
        case .TooMany: return varRep
        case .TooOne: return entity.varRep.nilRep
        }
    }
}

extension Relationship: Hashable { var hashValue: Int { return entity.hashValue } }
extension Relationship: Equatable {}; func ==(lhs: Relationship, rhs: Relationship) -> Bool { return lhs.entity.hashValue == rhs.entity.hashValue }

extension Relationship: HGEncodable {
    
    static var new: Relationship {
        return Relationship(tag: 0, entity: Entity.new, relType: .TooOne, deletionRule: .NoAction)
    }
    
    var encode: AnyObject {
        var dict = HGDICT()
        dict["tag"] = tag
        dict["eTypeRep"] = entity.typeRep
        dict["relType"] = relType.int
        dict["deletionRule"] = deletionRule.int
        return dict
    }
    
    static func decode(object object: AnyObject) -> Relationship {
        
        let dict = hgdict(fromObject: object, decoderName: "Relationship")
        let tag = dict["tag"].int
        let entity = dict["eTypeRep"].entity
        let relType = dict["relType"].relationshipType
        let deletionRule =  dict["deletionRule"].deletionRule
        return Relationship(tag: tag, entity: entity, relType: relType, deletionRule: deletionRule)
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


