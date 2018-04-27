//
//  File.swift
//  HuckleberryGen
//
//  Created by David Vallas on 4/25/18.
//  Copyright © 2018 Phoenix Labs. All rights reserved.
//

import Foundation

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
            HGReport.shared.report("int: |\(int)| is not DeletionRule mapable, using .NoAction", type: .error)
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
            HGReport.shared.report("string: |\(string)| is not DeletionRule mapable, using .NoAction", type: .error)
            return .noAction
        }
    }
}
