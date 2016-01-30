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

extension Attribute: TypeRepresentable {
    
    var typeRep: String { return type.typeRepresentable }
}

extension Attribute: VarRepresentable {
    
    var varRep: String { return name }
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
    case _Int16
    case _Int32
    case _Double
    case _Float
    case _String
    case _Bool
    case _Date
    case _Binary
    
    static var count = 9
    
    var defaultValue: String {
        switch self {
        case _Int: return "0"
        case _Int16: return "0"
        case _Int32: return "0"
        case _Double: return "0.0"
        case _Float: return "0.0"
        case _String: return "\"notDefined\""
        case _Bool: return "false"
        case _Date: return "NSDate()"
        case _Binary: return "NSData()"
        }
    }
    
    var string: String {
        switch self {
        case _Int: return "Int"
        case _Int16: return "Int16"
        case _Int32: return "Int32"
        case _Double: return "Double"
        case _Float: return "Float"
        case _String: return "String"
        case _Bool: return "Bool"
        case _Date: return "NSDate"
        case _Binary: return "NSData"
        }
    }
    
    var int: Int {
        switch self {
        case _Int: return 0
        case _Int16: return 1
        case _Int32: return 2
        case _Double: return 3
        case _Float: return 4
        case _String: return 5
        case _Bool: return 6
        case _Date: return 7
        case _Binary: return 8
        }
    }
    
    var image: NSImage {
        return NSImage.image(named: "typeIcon", title: self.string)
    }
    
    static var array: [Primitive] = [_Int, _Int16, _Int32, _Double, _Float, _String, _Bool, _Date, _Binary]
    
    // create unique return statements for Primitive.  use for exporting optionals.
    func optionalReturnStatement(withInitialIndent iInd: String) -> String {
        
        // get indent
        let ind = HGIndent.indent
        
        // create default string
        var string = ""
        
        // return Int16 || Int32
        if self == _Int16 || self == _Int32 {
            
            // set name
            let name = self.string
            
            string += "\(iInd)if let int = self as? Int {\n"
            string += "\(iInd)\(ind)if abs(int) <= Int(\(name).max) {\n"
            string += "\(iInd)\(ind)\(ind)return \(name)(int)\n"
            string += "\(iInd)\(ind)}\n"
            string += "\(iInd)}\n"
            return string
        }
        
        // return Bool
        if self == _Bool {
            string += "\(iInd)if let string = self as? String {\n"
            string += "\(iInd)\(ind)switch string {\n"
            string += "\(iInd)\(ind)case \"YES\", \"TRUE\", \"Yes\", \"1\", \"true\", \"True\", \"yes\": return true\n"
            string += "\(iInd)\(ind)case \"NO\", \"FALSE\", \"No\", \"0\", \"false\", \"False\",  \"no\": return false\n"
            string += "\(iInd)\(ind)default: break;\n"
            string += "\(iInd)\(ind)}\n"
            string += "\(iInd)}\n"
            return string
        }
        
        return string
    }
    
    // create unique array return statements for Primitive.  use for exporting optionals.
    func optionalArrayReturnStatement(withInitialIndent iInd: String) -> String {
        
        // get indent
        let ind = HGIndent.indent
        
        // create default string
        var string = ""
        
        // return Int16 || Int32
        if self == _Int16 || self == _Int32 {
            
            // set name
            let name = self.string
            
            string += "\(iInd)if let intArray = self as? [Int] {\n"
            string += "\(iInd)\(ind)var arrayContainsAll\(name) = true\n"
            string += "\(iInd)\(ind)for int in intArray {\n"
            string += "\(iInd)\(ind)\(ind)if abs(int) > Int(\(name).max) {\n"
            string += "\(iInd)\(ind)\(ind)\(ind)arrayContainsAll\(name) = false\n"
            string += "\(iInd)\(ind)\(ind)\(ind)break\n"
            string += "\(iInd)\(ind)\(ind)}\n"
            string += "\(iInd)\(ind)}\n"
            string += "\(iInd)\(ind)if arrayContainsAll\(name) == true {\n"
            string += "\(iInd)\(ind)\(ind)return intArray.map { \(name)($0) }\n"
            string += "\(iInd)\(ind)}\n"
            string += "\(iInd)}\n"
            return string
        }
        
        return string
    }
    
    static func create(int int: Int) -> Primitive {
        switch(int) {
        case 0: return ._Int
        case 1: return ._Int16
        case 2: return ._Int32
        case 3: return ._Double
        case 4: return ._Float
        case 5: return ._String
        case 6: return ._Bool
        case 7: return ._Date
        case 8: return ._Binary
        default:
            HGReportHandler.shared.report("int: |\(int)| is not Primitive mapable, using ._Int", type: .Error)
            return ._Int
        }
    }
    
    static func create(string string: String) -> Primitive {
        if let primitive = prim(fromString: string) {
            return primitive
        }
        HGReportHandler.shared.report("string: |\(string)| is not Primitive mapable, using ._Int", type: .Error)
        return ._Int
    }
    
    static func optionalPrimitive(string string: String) -> Primitive? {
        if let primitive = prim(fromString: string) {
            return primitive
        }
        return nil
    }
    
    private static func prim(fromString string: String) -> Primitive? {
        switch string {
        case "Int", "Integer 64": return ._Int
        case "Integer 16": return ._Int16
        case "Integer 32": return ._Int32
        case "Decimal", "Float": return ._Float
        case "Double": return ._Double
        case "String": return ._String
        case "Boolean", "Bool": return ._Bool
        case "Date", "NSDate": return ._Date
        case "Binary Data", "NSData", "Transformable": return ._Binary
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
        HGReportHandler.shared.report("object: |\(object)| is not AttributeType mapable, using ._Int", type: .Error)
        return ._Int
    }
}