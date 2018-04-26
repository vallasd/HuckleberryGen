//
//  Primitive.swift
//  HuckleberryGen
//
//  Created by David Vallas on 4/25/18.
//  Copyright © 2018 Phoenix Labs. All rights reserved.
//

import Cocoa

enum Primitive: Int {
    
    case _int = 0
    case _int16 = 1
    case _int32 = 2
    case _double = 3
    case _float = 4
    case _string = 5
    case _bool = 6
    case _date = 7
    case _lastUpdate = 8
    case _imageURL = 9
    
    static var count = 10
    
    var defaultRep: String {
        switch self {
        case ._int: return "0"
        case ._int16: return "0"
        case ._int32: return "0"
        case ._double: return "0.0"
        case ._float: return "0.0"
        case ._string: return "\"notDefined\""
        case ._bool: return "false"
        case ._date: return "Date()"
        case ._lastUpdate: return "Date()"
        case ._imageURL: return "\"notDefined\""
        }
    }
    
    var name: String {
        switch self {
        case ._int: return "Int"
        case ._int16: return "Int16"
        case ._int32: return "Int32"
        case ._double: return "Double"
        case ._float: return "Float"
        case ._string: return "String"
        case ._bool: return "Bool"
        case ._date: return "Date"
        case ._lastUpdate: return "Date"
        case ._imageURL: return "String"
        }
    }
    
    var image: NSImage {
        return NSImage.image(named: "typeIcon", title: name.varRepresentable)
    }
    
    static var array: [Primitive] = [_int, _int16, _int32, _double, _float, _string, _bool, _date, _lastUpdate, _imageURL]
    
    static func create(int: Int) -> Primitive {
        switch(int) {
        case 0: return ._int
        case 1: return ._int16
        case 2: return ._int32
        case 3: return ._double
        case 4: return ._float
        case 5: return ._string
        case 6: return ._bool
        case 7: return ._date
        case 8: return ._lastUpdate
        case 9: return ._imageURL
        default:
            HGReportHandler.shared.report("int: |\(int)| is not Primitive mapable, using ._Int", type: .error)
            return ._int
        }
    }
    
    // create unique return statements for Primitive.  use for exporting optionals.
    func optionalReturnStatement(withInitialIndent iInd: String) -> String {
        
        // get indent
        let ind = HGIndent.indent
        
        // create default string
        var string = ""
        
        // return Int16 || Int32
        if self == Primitive._int16 || self == Primitive._int32 {
            string += "\(iInd)if let int = self as? Int {\n"
            string += "\(iInd)\(ind)if abs(int) <= Int(\(name).max) {\n"
            string += "\(iInd)\(ind)\(ind)return \(name)(int)\n"
            string += "\(iInd)\(ind)}\n"
            string += "\(iInd)}\n"
            return string
        }
        
        // return Bool
        if self == Primitive._bool {
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
        if self == Primitive._int16 || self == Primitive._int32 {
            
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
    
    static func create(string: String) -> Primitive {
        if let primitive = optionalPrimitive(string: string) { return primitive }
        HGReportHandler.shared.report("string: |\(string)| is not Primitive mapable, using ._Int", type: .error)
        return ._int
    }
    
    static func optionalPrimitive(string: String) -> Primitive? {
        let pArray = Primitive.array
        let pVarReps = Primitive.array.map { $0.name.varRepresentable }
        if let index = pVarReps.index(of: string) {
            return pArray[index]
        }
        return nil
    }
}

extension Primitive: HGEncodable {
    
    static var new: Primitive {
        return ._int
    }
    
    static var encodeError: Primitive {
        return ._int
    }
    
    var encode: Any {
        return self.rawValue
    }
    
    static func decode(object: Any) -> Primitive {
        if let int = object as? Int { return create(int: int) }
        if let string = object as? String { return create(string: string) }
        HGReportHandler.shared.report("object: |\(object)| is not AttributeType mapable, using ._Int", type: .error)
        return ._int
    }
}
