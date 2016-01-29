
import Foundation
import CoreData

//extension Optional where .Some == HGPrimitiveEncodable {
//    
//}

extension Optional {
    
    var importFile: ImportFile {
        if let dict = self as? HGDICT { return ImportFile.decode(object: dict) }
        appDelegate.error.report("optional: |\(self)| is not Entity mapable, returning new ImportFile", type: .Error)
        return ImportFile.new
    }
    
    var importFiles: [ImportFile] {
        if let array = self as? HGARRAY { return ImportFile.decodeArray(objects: array) }
        appDelegate.error.report("optional: |\(self)| is not [ImportFile] mapable, returning []", type: .Error)
        return []
    }
    
    var huckleberryGen: HuckleberryGen {
        if let dict = self as? HGDICT { return HuckleberryGen.decode(object: dict) }
        appDelegate.error.report("optional: |\(self)| is not HuckleberryGen mapable, returning new HuckleberryGen", type: .Error)
        return HuckleberryGen.new
    }
    
    var project: Project {
        if let dict = self as? HGDICT { return Project.decode(object: dict) }
        appDelegate.error.report("optional: |\(self)| is not Project mapable, returning new Project", type: .Error)
        return Project.new
    }
    
    var licenseInfo: LicenseInfo {
        if let dict = self as? HGDICT { return LicenseInfo.decode(object: dict) }
        appDelegate.error.report("optional: |\(self)| is not Licens mapable, returning new Attribute", type: .Error)
        return LicenseInfo.new
    }
    
    var entity: Entity {
        if let dict = self as? HGDICT { return Entity.decode(object: dict) }
        appDelegate.error.report("optional: |\(self)| is not Entity mapable, returning new Entity", type: .Error)
        return Entity.new
    }
    
    var entities: [Entity] {
        if let array = self as? HGARRAY { return Entity.decodeArray(objects: array) }
        appDelegate.error.report("optional: |\(self)| is not [Entity] mapable, returning []", type: .Error)
        return []
    }
    
    var attribute: Attribute {
        if let dict = self as? HGDICT { return Attribute.decode(object: dict) }
        appDelegate.error.report("optional: |\(self)| is not Attribute mapable, returning new Attribute", type: .Error)
        return Attribute.new
    }
    
    var attributes: [Attribute] {
        if let array = self as? HGARRAY { return Attribute.decodeArray(objects: array) }
        appDelegate.error.report("optional: |\(self)| is not [Attribute] mapable, returning []", type: .Error)
        return []
    }
    
    var relationship: Relationship {
        if let dict = self as? HGDICT { return Relationship.decode(object: dict) }
        appDelegate.error.report("optional: |\(self)| is not Relationship mapable, returning new Relationship", type: .Error)
        return Relationship.new
    }
    
    var relationships: [Relationship] {
        if let array = self as? HGARRAY { return Relationship.decodeArray(objects: array) }
        appDelegate.error.report("optional: |\(self)| is not [Relationship] mapable, returning []", type: .Error)
        return []
    }
    
    var enuM: Enum {
        if let dict = self as? HGDICT { return Enum.decode(object: dict) }
        appDelegate.error.report("optional: |\(self)| is not Enum mapable, returning new Enum", type: .Error)
        return Enum.new
    }
    
    var enums: [Enum] {
        if let array = self as? HGARRAY { return Enum.decodeArray(objects: array) }
        appDelegate.error.report("optional: |\(self)| is not [Enum] mapable, returning []", type: .Error)
        return []
    }
    
    var enumcase: EnumCase {
        if let dict = self as? HGDICT { return EnumCase.decode(object: dict) }
        appDelegate.error.report("optional: |\(self)| is not Relationship mapable, returning new EnumCase", type: .Error)
        return EnumCase.new
    }
    
    var enumcases: [EnumCase] {
        if let array = self as? HGARRAY { return EnumCase.decodeArray(objects: array) }
        appDelegate.error.report("optional: |\(self)| is not [EnumCase] mapable, returning []", type: .Error)
        return []
    }
    
    var deletionRule: DeletionRule {
        if let int = self as? Int { return DeletionRule.create(int: int) }
        if let string = self as? String { return DeletionRule.create(string: string) }
        appDelegate.error.report("optional: |\(self)| is not DeletionRule mapable, using .Nullify", type: .Error)
        return .Nullify
    }
    
    var licenseType: LicenseType {
        if let int = self as? Int { return LicenseType.create(int: int) }
        appDelegate.error.report("optional: |\(self)| is not LicenseType mapable, using .MIT", type: .Error)
        return .MIT
    }
    
    var relationshipType: RelationshipType {
        if let int = self as? Int { return RelationshipType.create(int: int) }
        if let string = self as? String { return RelationshipType.create(string: string) }
        // appDelegate.error.report("optional: |\(self)| is not RelationshipType mapable, using .TooOne", type: .Error)
        return .TooOne
    }
    
    var primitive: Primitive {
        if let int = self as? Int { return Primitive.create(int: int) }
        if let string = self as? String { return Primitive.create(string: string) }
        appDelegate.error.report("self: |\(self)| is not AttributeType mapable, using ._Int16", type: .Error)
        return ._Int
    }
    
    var importFileType: ImportFileType {
        if let int = self as? Int { return ImportFileType.create(int: int) }
        appDelegate.error.report("optional: |\(self)| is not an ImportFileType mapable, using .XCODE_XML", type: .Error)
        return .XCODE_XML
    }
    
    var interval: NSTimeInterval {
        if let interval = self as? Double { return interval }
        appDelegate.error.report("optional: |\(self)| is not NSTimeInterval mapable, using 0", type: .Error)
        return 0
    }
    
    var int: Int {
        if let int = self as? Int { return int }
        appDelegate.error.report("optional: |\(self)| is not Int mapable, using 0", type: .Error)
        return 0
    }
    
    var int16: Int16 {
        if let int = self as? Int {
            if abs(int) > Int(Int16.max) { return Int16(int) }
        }
        appDelegate.error.report("optional: |\(self)| is not Int16 mapable, using 0", type: .Error)
        return 0
    }
    
    var int32: Int32 {
        if let int = self as? Int {
            if abs(int) > Int(Int32.max) { return Int32(int) }
        }
        appDelegate.error.report("optional: |\(self)| is not Int32 mapable, using 0", type: .Error)
        return 0
    }
    
    var string: String {
        if let string = self as? String { return string }
        appDelegate.error.report("optional: |\(self)| is not String mapable, using Empty String", type: .Error)
        return ""
    }
    
    var stringOptional: String? {
        if self == nil { return nil }
        if let string = self as? String { return string }
        appDelegate.error.report("optional: |\(self)| is not Optional String mapable, using nil String?", type: .Error)
        return nil
    }
    
    var stringArray: [String] {
        if let array = self as? [String] { return array }
        appDelegate.error.report("optional: |\(self)| is not Optional String mapable, using Empty [String]", type: .Error)
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
        
        appDelegate.error.report("optional: |\(self)| is not Bool mapable, using false", type: .Error)
        return false
    }
}

extension Optional {
    
    
    
    
}