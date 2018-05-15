//
//  File.swift
//  HuckleberryGen
//
//  Created by David Vallas on 4/25/18.
//  Copyright © 2018 Phoenix Labs. All rights reserved.
//

import Foundation

enum DeletionRule: Int8 {
    
    case noAction = 0
    case nullify = 1
    case cascade = 2
    case deny = 3
    
    static var set: [DeletionRule] { return [.noAction, .nullify, .cascade, .deny] }
    
    var int: Int {
        return Int(self.rawValue)
    }
    
    init(int8: Int8) {
        switch int8 {
        case 0: self = .noAction
        case 1: self = .nullify
        case 2: self = .cascade
        case 3: self = .deny
        default:
            HGReport.shared.report("int: |\(int8)| is not DeletionRule mapable, using .NoAction", type: .error)
            self = .noAction
        }
    }
    
    var string: String {
        switch self {
        case .noAction: return "No Action"
        case .nullify: return "Nullify"
        case .cascade: return "Cascade"
        case .deny: return "Deny"
        }
    }
    
    static func create(string: String) -> DeletionRule {
        switch string {
        case "No Action": return .noAction
        case "Nullify": return .nullify
        case "Cascade": return .cascade
        case "Deny": return .deny
        default:
            HGReport.shared.report("string: |\(string)| is not DeletionRule mapable, using .NoAction", type: .error)
            return .noAction
        }
    }
    
    // MARK: - HGCodable
    
    static var encodeError: DeletionRule {
        return .nullify
    }
    
    var encode: Any {
        return Int(self.rawValue)
    }
    
    static func decode(object: Any) -> DeletionRule {
        let int8 = HG.decode(int8: object, decoder: DeletionRule.self)
        return DeletionRule(int8: int8)
    }
}
