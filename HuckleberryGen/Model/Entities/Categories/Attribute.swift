//
//  Attribute.swift
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
//
//  You should have received a copy of the GNU General Public License
//  along with HuckleberryGen.  If not, see <http://www.gnu.org/licenses/>.

import CoreData
import AppKit
import Cocoa

struct Attribute: HashRepresentable {
    
    var varRep: String
    let typeRep: String
    let decodeRep: String
    let isPrimitive: Bool
    var optional: Bool
    
    var isEntity: Bool { return false }
    
    init(varRep v: String, primitive p: Primitive) {
        varRep = v
        typeRep = p.typeRep
        decodeRep = p.varRep
        isPrimitive = true
        optional = false
    }
    
    init(primitive p: Primitive, oldAttribute o: Attribute) {
        varRep = o.varRep
        typeRep = p.typeRep
        decodeRep = p.varRep
        isPrimitive = true
        optional = o.optional
    }
    
    init(enuM e: Enum, oldAttribute o: Attribute) {
        varRep = o.varRep
        typeRep = e.typeRep
        decodeRep = e.varRep
        isPrimitive = false
        optional = o.optional
    }
    
    init(typeRep t: String, varRep v: String, decodeRep d: String, isPrimitive ip: Bool, optional o: Bool) {
        typeRep = t
        varRep = v
        decodeRep = d
        isPrimitive = ip
        optional = o
    }
    
    var image: NSImage {
        return NSImage.image(named: "attributeIcon", title: varRep)
    }
    
    var typeImage: NSImage {
        if isPrimitive {
            let prim = Primitive.create(string: typeRep)
            return prim.image
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
        dict["optional"] = optional
        return dict
    }
    
    static func decode(object object: AnyObject) -> Attribute {
        let dict = hgdict(fromObject: object, decoderName: "Attribute")
        let typeRep = dict["typeRep"].string
        let varRep = dict["varRep"].string
        let decodeRep = dict["decodeRep"].string
        let isPrimitive = dict["isPrimitive"].bool
        let optional = dict["optional"].bool
        return Attribute(typeRep: typeRep, varRep: varRep, decodeRep: decodeRep, isPrimitive: isPrimitive, optional: optional)
    }
}

enum SpecialAttribute {
    
    // Attribute Special Types (for random)
    case Title  // will generate random titles
    case Name  // will generate random names
    case LongText // will generate random text
    case ImageURL // will generate random images / stores and sets these images
    
    case IndexedSet  // will treat the object as a set of its relationship
    case TimeRange // will create a Date Index
    case FirstLetter // will create a FirstLetter Index
    case Folder // will create a folder index
    
    case EnumAttribute // will create a Enum Index
    
    case IsSpecial // tag that actual object is Special
    
    static func specialTypeFrom(varRep v: String) -> SpecialAttribute? {
        
        if v == "title" { return .Title }
        if v == "name" { return .Name }
        if v == "summary" { return .LongText }
        if v == "imageURL" { return .ImageURL }
        if v == "timeRange" { return .TimeRange }
        if v == "firstLetter" { return .FirstLetter }
        if v == "folder" { return .Folder }
        if v.getLast(3) == "Num" { return .IndexedSet }
        
        // check if enums type is same as var, if so, return enum attribute
        let checkEnums = appDelegate.store.project.enums.map { $0.varRep }.filter { $0 == v }.count
        if checkEnums > 0 { return .EnumAttribute }
        
        return nil
    }
    
    var color: NSColor {
        
        switch self {
        case .TimeRange, .FirstLetter, .IndexedSet, .Folder: return HGColor.Green.color() // Indexes
        case .EnumAttribute: return HGColor.Cyan.color() // Enums
        case .Title, .Name, .LongText, .ImageURL: return HGColor.Orange.color() // Special Random
        default:
            HGReportHandler.shared.report("HGColor not found for Special Attribute, returning green", type: .Error)
            return HGColor.Green.color()
        }
    }
    
    var image: NSImage {
        
        switch self {
        case .TimeRange, .FirstLetter, .IndexedSet, .Folder: return NSImage(named: "specialGreen")!
        case .EnumAttribute: return NSImage(named: "specialCyan")!
        case .Title, .Name, .LongText, .ImageURL: return NSImage(named: "specialOrange")!
        default:
            HGReportHandler.shared.report("Special Type image not found for Special Attribute, returning specialGreen image", type: .Error)
            return NSImage(named: "specialGreen")!
        }
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
    
    static var count = 9
    
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
        return NSImage.image(named: "typeIcon", title: varRep)
    }
    
    static var array: [Primitive] = [_Int, _Int16, _Int32, _Double, _Float, _String, _Bool, _Date, _Binary]
    
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
        case "": return nil
        case "Int", "Integer 64", "int": return ._Int
        case "Integer 16", "int16", "Int16": return ._Int16
        case "Integer 32", "int32", "Int32": return ._Int32
        case "String", "string": return ._String
        case "Decimal", "Float", "float": return ._Float
        case "Double", "double": return ._Double
        case "Boolean", "Bool", "bool": return ._Bool
        case "Date", "NSDate", "date", "nSDate": return ._Date
        case "Binary Data", "NSData", "Transformable", "data", "nSData": return ._Binary
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