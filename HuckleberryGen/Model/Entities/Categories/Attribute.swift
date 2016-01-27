//
//  Attribute.swift
//  HuckleberryGen
//
//  Created by David Vallas on 7/11/15.
//  Copyright © 2015 Phoenix Labs. All rights reserved.
//

import CoreData
import AppKit

struct Attribute {
    
    var name: String
    var type: String
    var isPrimitive: Bool
    
    init(name: String, primitive: Primitive) {
        self.name = name
        self.type = primitive.string
        self.isPrimitive = true
    }
    
    init(name: String, enuM: Enum) {
        self.name = name
        self.type = enuM.name
        self.isPrimitive = false
    }
    
    init(name: String, type: String, isPrimitive: Bool) {
        self.name = name
        self.type = type
        self.isPrimitive = isPrimitive
    }
    
    var image: NSImage {
        if isPrimitive {
            return NSImage.image(named: "typeIcon", title: type)
        }
        return NSImage.image(named: "enumIcon", title: type)
    }

}

extension Attribute: Hashable { var hashValue: Int { return name.hashValue } }
extension Attribute: Equatable {}; func ==(lhs: Attribute, rhs: Attribute) -> Bool { return lhs.name == rhs.name }

extension Attribute: HGEncodable {
    
    static var new: Attribute {
        return Attribute(name: "New Attribute", primitive: Primitive._Int)
    }
    
    var encode: AnyObject {
        var dict = HGDICT()
        dict["name"] = name
        dict["type"] = type
        dict["isPrimitive"] = isPrimitive
        return dict
    }
    
    static func decode(object object: AnyObject) -> Attribute {
        let dict = hgdict(fromObject: object, decoderName: "Attribute")
        let name = dict["name"].string
        let type = dict["type"].string
        let isPrimitive = dict["isPrimitive"].bool
        return Attribute(name: name, type: type, isPrimitive: isPrimitive)
    }
}


enum Primitive {
 
    case _Int
    case _Double
    case _Float
    case _String
    case _Bool
    case _Date
    case _Binary
    
    static var count = 7
    
    var string: String {
        switch self {
        case _Int: return "Int"
        case _Double: return "Double"
        case _Float: return "Float"
        case _String: return "String"
        case _Bool: return "Bool"
        case _Date: return "Date"
        case _Binary: return "Binary"
        }
    }
    
    var int: Int {
        switch self {
        case _Int: return 0
        case _Double: return 0
        case _Float: return 0
        case _String: return 0
        case _Bool: return 0
        case _Date: return 0
        case _Binary: return 0
        }
    }
    
    var image: NSImage {
        return NSImage.image(named: "typeIcon", title: self.string)
    }
    
    static var set: [Primitive] = [_Int, _Double, _Float, _String, _Bool, _Date, _Binary]
    
    static func create(int int: Int) -> Primitive {
        switch(int) {
        case 0: return ._Int
        case 1: return ._Double
        case 2: return ._Float
        case 3: return ._String
        case 4: return ._Bool
        case 5: return ._Date
        case 6: return ._Binary
        default:
            HGReportHandler.report("int: |\(int)| is not Primitive mapable, using ._Int", type: .Error)
            return ._Int
        }
    }
    
    static func create(string string: String) -> Primitive {
        switch string {
        case "Int": return ._Int
        case "Integer 16": return ._Int
        case "Integer 32": return ._Int
        case "Integer 64": return ._Int
        case "Decimal": return ._Float
        case "Double": return ._Double
        case "Float": return ._Float
        case "String": return ._String
        case "Boolean": return ._Bool
        case "Bool": return ._Bool
        case "Date": return ._Date
        case "Binary Data": return ._Binary
        case "Transformable": return ._Binary
        default:
            HGReportHandler.report("string: |\(string)| is not Primitive mapable, using ._Int", type: .Error)
            return ._Int
        }
    }
    
    static func optionalPrimitive(string string: String) -> Primitive? {
        switch string {
        case "Int": return ._Int
        case "Integer 16": return ._Int
        case "Integer 32": return ._Int
        case "Integer 64": return ._Int
        case "Decimal": return ._Float
        case "Double": return ._Double
        case "Float": return ._Float
        case "String": return ._String
        case "Boolean": return ._Bool
        case "Bool": return ._Bool
        case "Date": return ._Date
        case "Binary Data": return ._Binary
        case "Transformable": return ._Binary
        default:
            return nil
        }
    }
}

extension Primitive: HGEncodable {
    
    static var new: Primitive {
        return ._Int
    }
    
    var encode: AnyObject {
        return int
    }
    
    static func decode(object object: AnyObject) -> Primitive {
        if let int = object as? Int { return create(int: int) }
        if let string = object as? String { return create(string: string) }
        HGReportHandler.report("object: |\(object)| is not AttributeType mapable, using ._Int", type: .Error)
        return ._Int
    }
}