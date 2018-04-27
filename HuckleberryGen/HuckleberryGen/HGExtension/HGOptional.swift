
import Foundation
import CoreData

//extension Optional where .Some == HGPrimitiveEncodable {
//    
//}

extension Optional {
    
    var importFile: ImportFile {
        if let dict = self as? HGDICT { return ImportFile.decode(object: dict as AnyObject) }
        HGReport.shared.report("optional: |\(String(describing: self ?? nil))| is not Entity mapable, returning new ImportFile", type: .error)
        return ImportFile.new
    }
    
    var importFiles: [ImportFile] {
        if let array = self as? HGARRAY { return ImportFile.decodeArray(objects: array as [AnyObject]) }
        HGReport.shared.report("optional: |\(String(describing: self))| is not [ImportFile] mapable, returning []", type: .error)
        return []
    }
    
    var huckleberryGen: HuckleberryGen {
        if let dict = self as? HGDICT { return HuckleberryGen.decode(object: dict as AnyObject) }
        HGReport.shared.report("optional: |\(String(describing: self))| is not HuckleberryGen mapable, returning new HuckleberryGen", type: .error)
        return HuckleberryGen.new
    }
    
    var project: Project {
        if let dict = self as? HGDICT { return Project.decode(object: dict as AnyObject) }
        HGReport.shared.report("optional: |\(String(describing: self))| is not Project mapable, returning new Project", type: .error)
        return Project.new
    }
    
    var licenseInfo: LicenseInfo {
        if let dict = self as? HGDICT { return LicenseInfo.decode(object: dict as AnyObject) }
        HGReport.shared.report("optional: |\(String(describing: self))| is not License mapable, returning new Attribute", type: .error)
        return LicenseInfo.new
    }
    
    var entity: Entity {
        if let dict = self as? HGDICT { return Entity.decode(object: dict as AnyObject) }
        HGReport.shared.report("optional: |\(String(describing: self))| is not Entity mapable, returning new Entity", type: .error)
        return Entity(name: "Error", attributes: [], hashes: [])
    }
    
    var entities: [Entity] {
        if let array = self as? HGARRAY { return Entity.decodeArray(objects: array as [AnyObject]) }
        HGReport.shared.report("optional: |\(String(describing: self))| is not [Entity] mapable, returning []", type: .error)
        return []
    }
    
    var attributeType: AttributeType {
        return AttributeType.decode(object: self as Any)
    }
    
    var hGtype: HGType {
        return HGType.decode(object: self as Any)
    }
    
    var attribute: Attribute {
        if let dict = self as? HGDICT { return Attribute.decode(object: dict) }
        HGReport.shared.report("optional: |\(String(describing: self))| is not Attribute mapable, returning new Attribute", type: .error)
        return Attribute.encodeError
    }
    
    var attributeArray: [Attribute] {
        if let array = self as? HGARRAY { return Attribute.decodeArray(objects: array as [AnyObject]) }
        HGReport.shared.report("optional: |\(String(describing: self))| is not [Attribute] mapable, returning []", type: .error)
        return []
    }
    
    var attributeSet: Set<Attribute2> {
        if let array = self as? HGARRAY { return Attribute2.decodeSet(objects: array as [AnyObject]) }
        HGReport.shared.report("optional: |\(String(describing: self))| is not [Attribute2] mapable, returning []", type: .error)
        return []
    }
    
    var relationship: Relationship {
        if let dict = self as? HGDICT { return Relationship.decode(object: dict) }
        HGReport.shared.report("optional: |\(String(describing: self))| is not Relationship mapable, returning new Attribute", type: .error)
        return Relationship.encodeError
    }
    
    var relationshipArray: [Relationship] {
        if let array = self as? HGARRAY { return Relationship.decodeArray(objects: array as [AnyObject]) }
        HGReport.shared.report("optional: |\(String(describing: self))| is not [Relationship] mapable, returning []", type: .error)
        return []
    }
    
    var relationshipSet: Set<Relationship> {
        if let array = self as? HGARRAY { return Relationship.decodeSet(objects: array as [AnyObject]) }
        HGReport.shared.report("optional: |\(String(describing: self))| is not [Relationship] mapable, returning []", type: .error)
        return []
    }
    
    var usedName: UsedName {
        if let dict = self as? HGDICT { return UsedName.decode(object: dict) }
        HGReport.shared.report("optional: |\(String(describing: self))| is not UsedName mapable, returning new UsedName", type: .error)
        return UsedName.encodeError
    }
    
    var usedNameArray: [UsedName] {
        if let array = self as? HGARRAY { return UsedName.decodeArray(objects: array as [AnyObject]) }
        HGReport.shared.report("optional: |\(String(describing: self))| is not [UsedName] mapable, returning []", type: .error)
        return []
    }
    
    var usedNameSet: Set<UsedName> {
        if let array = self as? HGARRAY { return UsedName.decodeSet(objects: array as [AnyObject]) }
        HGReport.shared.report("optional: |\(String(describing: self))| is not [UsedName] mapable, returning []", type: .error)
        return []
    }
    
    var enuM: Enum {
        if let dict = self as? HGDICT { return Enum.decode(object: dict as AnyObject) }
        HGReport.shared.report("optional: |\(String(describing: self))| is not Enum mapable, returning new Enum", type: .error)
        return Enum.encodeError
    }
    
    var enums: [Enum] {
        if let array = self as? HGARRAY { return Enum.decodeArray(objects: array as [AnyObject]) }
        HGReport.shared.report("optional: |\(String(describing: self))| is not [Enum] mapable, returning []", type: .error)
        return []
    }
    
    var deletionRule: DeletionRule {
        return DeletionRule.decode(object: self as Any)
    }
    
    var licenseType: LicenseType {
        if let int = self as? Int { return LicenseType.create(int: int) }
        HGReport.shared.report("optional: |\(String(describing: self))| is not LicenseType mapable, using .MIT", type: .error)
        return .mit
    }
    
    var primitive: Primitive {
        if let int = self as? Int { return Primitive.create(int: int) }
        if let string = self as? String { return Primitive.create(string: string) }
        HGReport.shared.report("self: |\(String(describing: self))| is not AttributeType mapable, using ._Int16", type: .error)
        return ._int
    }
    
    var importFileType: ImportFileType {
        if let int = self as? Int { return ImportFileType.create(int: int) }
        HGReport.shared.report("optional: |\(String(describing: self))| is not an ImportFileType mapable, using .XCODE_XML", type: .error)
        return .xcode_XML
    }
    
    var interval: TimeInterval {
        if let interval = self as? Double { return interval }
        HGReport.shared.report("optional: |\(String(describing: self))| is not NSTimeInterval mapable, using 0", type: .error)
        return 0
    }
    
    var int: Int {
        if let int = self as? Int { return int }
        HGReport.shared.report("optional: |\(String(describing: self))| is not Int mapable, using 0", type: .error)
        return 0
    }
    
    var int16: Int16 {
        if let int = self as? Int {
            if abs(int) > Int(Int16.max) { return Int16(int) }
        }
        HGReport.shared.report("optional: |\(String(describing: self))| is not Int16 mapable, using 0", type: .error)
        return 0
    }
    
    var int32: Int32 {
        if let int = self as? Int {
            if abs(int) > Int(Int32.max) { return Int32(int) }
        }
        HGReport.shared.report("optional: |\(String(describing: self))| is not Int32 mapable, using 0", type: .error)
        return 0
    }
    
    var string: String {
        if let string = self as? String { return string }
        HGReport.shared.report("optional: |\(String(describing: self))| is not String mapable, using Empty String", type: .error)
        return ""
    }
    
    var stringOptional: String? {
        if self == nil { return nil }
        if let string = self as? String { return string }
        HGReport.shared.report("optional: |\(String(describing: self))| is not Optional String mapable, using nil String?", type: .error)
        return nil
    }
    
    var stringArray: [String] {
        if let array = self as? [String] { return array }
        if let string = self as? String {
            if string == "" { return [] }
            let strings = string.components(separatedBy: " ")
            return strings
        }
        HGReport.shared.report("optional: |\(String(describing: self))| is not [String] mapable, using Empty [String]", type: .error)
        return []
    }
    
    var intArray: [Int] {
        if let array = self as? [Int] { return array }
        HGReport.shared.report("optional: |\(String(describing: self))| is not [Int] String mapable, using Empty [Int]", type: .error)
        return []
    }
    
    var bool: Bool {
        
        if let bool = self as? Bool { return bool }
        if let string = self as? String {
            switch string {
            case "YES", "TRUE", "Yes", "1", "true", "True", "yes": return true
            case "NO", "FALSE", "No", "0", "false", "False",  "no": return false
            default: break;
            }
        }
        HGReport.shared.report("optional: |\(String(describing: self))| is not Bool mapable, using false", type: .error)
        return false
    }
}

extension Optional {
    
    
    
    
}
