//
//  EntityExport.swift
//  HuckleberryGen
//
//  Created by David Vallas on 5/18/18.
//  Copyright © 2018 Phoenix Labs. All rights reserved.
//

import Foundation

struct EntityExport {
    let name: String
    let attributes: [PrimitiveAttribute]
    let enums: [EnumAttribute]
    let entities: [EntityAttribute]
    let joins: [JoinAttribute]
}
