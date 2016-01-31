//
//  Attribute.swift
//  HuckleberryGen
//
//  Created by David Vallas on 7/11/15.
//  Copyright © 2015 Phoenix Labs. All rights reserved.
//

import CoreData
import AppKit

struct Attribute: TypeRepresentable, DecodeRepresentable, VarRepresentable {
    
    var varRep: String
    let typeRep: String
    let decodeRep: String
    let isPrimitive: Bool
    var mutable: Bool
    
    init(varRep: String, primitive: Primitive) {
        self.varRep = varRep
        self.typeRep = primitive.typeRep
        self.decodeRep = primitive.varRep
        self.isPrimitive = true
        mutable = false
    }
    
    init(primitive: Primitive, oldAttribute o: Attribute) {
        varRep = o.varRep
        typeRep = primitive.typeRep
        decodeRep = primitive.varRep
        isPrimitive = true
        mutable = o.mutable
    }
    
    init(enuM: Enum, oldAttribute o: Attribute) {
        varRep = o.varRep
        typeRep = enuM.typeRep
        decodeRep = enuM.varRep
        isPrimitive = false
        mutable = o.mutable
    }
    
    init(typeRep: String, varRep: String, decodeRep: String, isPrimitive: Bool, mutable: Bool) {
        self.typeRep = typeRep
        self.varRep = varRep
        self.decodeRep = decodeRep
        self.isPrimitive = isPrimitive
        self.mutable = mutable
    }
    
    var image: NSImage {
        if isPrimitive {
            return NSImage.image(named: "typeIcon", title: varRep)
        }
        return NSImage.image(named: "enumIcon", title: typeRep)
    }
}

extension Attribute: Hashable { var hashValue: Int { return varRep.hashValue } }
extension Attribute: Equatable {}; func ==(lhs: Attribute, rhs: Attribute) -> Bool { return lhs.varRep == rhs.varRep }

extension Attribute: HGEncodable {
    
    static var new: Attribute {
        return Attribute(varRep: "newAttribute", primitive: ._Int)
    }
    
    var encode: AnyObject {
        var dict = HGDICT()
        dict["typeRep"] = typeRep
        dict["varRep"] = varRep
        dict["decodeRep"] = decodeRep
        dict["isPrimitive"] = isPrimitive
        dict["mutable"].bool
        return dict
    }
    
    static func decode(object object: AnyObject) -> Attribute {
        let dict = hgdict(fromObject: object, decoderName: "Attribute")
        let typeRep = dict["typeRep"].string
        let varRep = dict["varRep"].string
        let decodeRep = dict["decodeRep"].string
        let isPrimitive = dict["isPrimitive"].bool
        let mutable = dict["mutable"].bool
        return Attribute(typeRep: typeRep, varRep: varRep, decodeRep: decodeRep, isPrimitive: isPrimitive, mutable: mutable)
    }
}

enum Primitive: TypeRepresentable, VarRepresentable, DefaultRepresentable {
 
    case _Int
    case _Int16
    case _Int32
    case _Double
    case _Float
    case _String
    case _Bool
    case _Date
    case _Binary
    case _TimeRange
    case _ImageURL
    
    static var count = 11
    
    var defaultRep: String {
        
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
        case _TimeRange: return "TimeRange"
        case _ImageURL: return "ImageURL"
        }
    }
    
    var typeRep: String {
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
        case _TimeRange: return "TimeRange"
        case _ImageURL: return "ImageURL"
        }
    }
    
    var varRep: String {
        switch self {
        case _Int: return "int"
        case _Int16: return "int16"
        case _Int32: return "int32"
        case _Double: return "double"
        case _Float: return "float"
        case _String: return "string"
        case _Bool: return "bool"
        case _Date: return "date"
        case _Binary: return "data"
        case _TimeRange: return "timeRange"
        case _ImageURL: return "imageURL"
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
        case _TimeRange: return 9
        case _ImageURL: return 10
        }
    }
    
    var image: NSImage {
        return NSImage.image(named: "typeIcon", title: varRep)
    }
    
    static var array: [Primitive] = [_Int, _Int16, _Int32, _Double, _Float, _String, _Bool, _Date, _Binary, _TimeRange, _ImageURL]
    
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
        case 9: return ._TimeRange
        case 10: return ._ImageURL
        default:
            HGReportHandler.shared.report("int: |\(int)| is not Primitive mapable, using ._Int", type: .Error)
            return ._Int
        }
    }
    
    // create unique return statements for Primitive.  use for exporting optionals.
    func optionalReturnStatement(withInitialIndent iInd: String) -> String {
        
        // get indent
        let ind = HGIndent.indent
        
        // create default string
        var string = ""
        
        // return Int16 || Int32
        if self == _Int16 || self == _Int32 {
            
            string += "\(iInd)if let int = self as? Int {\n"
            string += "\(iInd)\(ind)if abs(int) <= Int(\(typeRep).max) {\n"
            string += "\(iInd)\(ind)\(ind)return \(typeRep)(int)\n"
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
            
            string += "\(iInd)if let intArray = self as? [Int] {\n"
            string += "\(iInd)\(ind)var arrayContainsAll\(typeRep) = true\n"
            string += "\(iInd)\(ind)for int in intArray {\n"
            string += "\(iInd)\(ind)\(ind)if abs(int) > Int(\(typeRep).max) {\n"
            string += "\(iInd)\(ind)\(ind)\(ind)arrayContainsAll\(typeRep) = false\n"
            string += "\(iInd)\(ind)\(ind)\(ind)break\n"
            string += "\(iInd)\(ind)\(ind)}\n"
            string += "\(iInd)\(ind)}\n"
            string += "\(iInd)\(ind)if arrayContainsAll\(typeRep) == true {\n"
            string += "\(iInd)\(ind)\(ind)return intArray.map { \(typeRep)($0) }\n"
            string += "\(iInd)\(ind)}\n"
            string += "\(iInd)}\n"
            return string
        }
        
        return string
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
        case "Int", "Integer 64", "int": return ._Int
        case "Integer 16", "int16": return ._Int16
        case "Integer 32", "int32": return ._Int32
        case "Decimal", "Float", "float": return ._Float
        case "Double", "double": return ._Double
        case "String", "string": return ._String
        case "Boolean", "Bool", "bool": return ._Bool
        case "Date", "NSDate", "date": return ._Date
        case "Binary Data", "NSData", "Transformable", "data": return ._Binary
        case "TimeRange", "timeRange": return ._TimeRange
        case "ImageURL", "imageURL": return ._ImageURL
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