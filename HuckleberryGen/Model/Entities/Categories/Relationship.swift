//
//  Relationship.swift
//  HuckleberryGen
//
//  Created by David Vallas on 4/26/18.
//  Copyright © 2018 Phoenix Labs. All rights reserved.
//

import Foundation

struct Relationship {
    let name: String
    let entityName: String
    let inverseName: String
    let inverseEntityName: String
    let array: Bool
    let hashed: Bool
    let deletionRule: DeletionRule
}

extension Relationship: Hashable { var hashValue: Int { return (name + entityName).hashValue } }
extension Relationship: Equatable {}; func ==(lhs: Relationship, rhs: Relationship) -> Bool {
    return lhs.name == rhs.name && lhs.entityName == rhs.entityName
}
