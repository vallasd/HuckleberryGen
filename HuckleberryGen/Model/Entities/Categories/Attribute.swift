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
    
    var image: NSImage {
        if type.isEmpty {
            HGReportHandler.report("Attribute type is empty, using Error Image", response: .Error)
            return NSImage(named: "removeIcon")!
        }
        if Primitive.strings.contains(type) {
            return NSImage.image(named: "typeIcon", title: type)
        }
        return NSImage.image(named: "enumIcon", title: type)
    }

}

extension Attribute: Hashable { var hashValue: Int { return name.hashValue } }
extension Attribute: Equatable {}; func ==(lhs: Attribute, rhs: Attribute) -> Bool { return lhs.name == rhs.name }

extension Attribute: HGEncodable {
    
    static var new: Attribute {
        return Attribute(name: "New Attribute", type: "Integer 16")
    }
    
    var encode: AnyObject {
        var dict = HGDICT()
        dict["name"] = name
        dict["type"] = type
        return dict
    }
    
    static func decode(object object: AnyObject) -> Attribute {
        let dict = hgdict(fromObject: object, decoderName: "Attribute")
        let name = dict["name"].string
        let type = dict["type"].string
        return Attribute(name: name, type: type)
    }
}


enum Primitive: Int {
 
    case _Int16 = 0
    case _Int32 = 1
    case _Int64 = 2
    case _Decimal = 3
    case _Double = 4
    case _Float = 5
    case _String = 6
    case _Boolean = 7
    case _Date = 8
    case _Binary = 9
    case _Transformable = 10
    
    var string: String {
        return Primitive.strings[rawValue]
    }
    
    var int: Int {
        return Int(self.rawValue)
    }

    static var set: [Primitive] {
        return [._Int16, ._Int32, ._Int64, ._Decimal, ._Double, ._Float, ._String, ._Boolean, ._Date, ._Binary, ._Transformable]
    }
    
    static var strings = ["Integer 16", "Integer 32", "Integer 64", "Decimal", "Double", "Float", "String", "Boolean", "Date", "Binary Data", "Transformable"]
    
    var image: NSImage {
        return NSImage.image(named: "typeIcon", title: Primitive.strings[self.int])
    }
    
    static func create(int int: Int) -> Primitive {
        switch(int) {
        case 0: return ._Int16
        case 1: return ._Int32
        case 2: return ._Int64
        case 3: return ._Decimal
        case 4: return ._Double
        case 5: return ._Float
        case 6: return ._String
        case 7: return ._Boolean
        case 8: return ._Date
        case 9: return ._Binary
        case 10: return ._Transformable
        default:
            HGReportHandler.report("int: |\(int)| is not Primitive mapable, using ._Int16", response: .Error)
            return ._Int16
        }
    }
    
    static func create(string string: String) -> Primitive {
        switch string {
        case "Integer 16": return ._Int16
        case "Integer 32": return ._Int32
        case "Integer 64": return ._Int64
        case "Decimal": return ._Decimal
        case "Double": return ._Double
        case "Float": return ._Float
        case "String": return ._String
        case "Boolean": return ._Boolean
        case "Date": return ._Date
        case "Binary Data": return ._Binary
        case "Transformable": return ._Transformable
        default:
            HGReportHandler.report("string: |\(string)| is not Primitive mapable, using ._Int16", response: .Error)
            return ._Int16
        }
    }
}

extension Primitive: HGEncodable {
    
    static var new: Primitive {
        return ._Int16
    }
    
    var encode: AnyObject {
        return int
    }
    
    static func decode(object object: AnyObject) -> Primitive {
        if let int = object as? Int { return create(int: int) }
        if let string = object as? String { return create(string: string) }
        HGReportHandler.report("object: |\(object)| is not AttributeType mapable, using ._Int16", response: .Error)
        return ._Int16
    }
}