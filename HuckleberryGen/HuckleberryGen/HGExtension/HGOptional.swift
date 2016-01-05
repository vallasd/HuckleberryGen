
import Foundation
import CoreData

//extension Optional where .Some == HGPrimitiveEncodable {
//    
//}

extension Optional {
    
    var importFile: ImportFile {
        if let dict = self as? HGDICT { return ImportFile.decode(object: dict) }
        HGReportHandler.report("optional: |\(self)| is not Entity mapable, returning new ImportFile", response: .Error)
        return ImportFile.new
    }
    
    var importFiles: [ImportFile] {
        if let array = self as? HGARRAY { return ImportFile.decodeArray(objects: array) }
        HGReportHandler.report("optional: |\(self)| is not [ImportFile] mapable, returning []", response: .Error)
        return []
    }
    
    var huckleberryGen: HuckleberryGen {
        if let dict = self as? HGDICT { return HuckleberryGen.decode(object: dict) }
        HGReportHandler.report("optional: |\(self)| is not HuckleberryGen mapable, returning new HuckleberryGen", response: .Error)
        return HuckleberryGen.new
    }
    
    var project: Project {
        if let dict = self as? HGDICT { return Project.decode(object: dict) }
        HGReportHandler.report("optional: |\(self)| is not Project mapable, returning new Project", response: .Error)
        return Project.new
    }
    
    var licenseInfo: LicenseInfo {
        if let dict = self as? HGDICT { return LicenseInfo.decode(object: dict) }
        HGReportHandler.report("optional: |\(self)| is not Licens mapable, returning new Attribute", response: .Error)
        return LicenseInfo.new
    }
    
    var entity: Entity {
        if let dict = self as? HGDICT { return Entity.decode(object: dict) }
        HGReportHandler.report("optional: |\(self)| is not Entity mapable, returning new Entity", response: .Error)
        return Entity.new
    }
    
    var entities: [Entity] {
        if let array = self as? HGARRAY { return Entity.decodeArray(objects: array) }
        HGReportHandler.report("optional: |\(self)| is not [Entity] mapable, returning []", response: .Error)
        return []
    }
    
    var attribute: Attribute {
        if let dict = self as? HGDICT { return Attribute.decode(object: dict) }
        HGReportHandler.report("optional: |\(self)| is not Attribute mapable, returning new Attribute", response: .Error)
        return Attribute.new
    }
    
    var attributes: [Attribute] {
        if let array = self as? HGARRAY { return Attribute.decodeArray(objects: array) }
        HGReportHandler.report("optional: |\(self)| is not [Attribute] mapable, returning []", response: .Error)
        return []
    }
    
    var relationship: Relationship {
        if let dict = self as? HGDICT { return Relationship.decode(object: dict) }
        HGReportHandler.report("optional: |\(self)| is not Relationship mapable, returning new Relationship", response: .Error)
        return Relationship.new
    }
    
    var relationships: [Relationship] {
        if let array = self as? HGARRAY { return Relationship.decodeArray(objects: array) }
        HGReportHandler.report("optional: |\(self)| is not [Relationship] mapable, returning []", response: .Error)
        return []
    }
    
    var enuM: Enum {
        if let dict = self as? HGDICT { return Enum.decode(object: dict) }
        HGReportHandler.report("optional: |\(self)| is not Enum mapable, returning new Enum", response: .Error)
        return Enum.new
    }
    
    var enums: [Enum] {
        if let array = self as? HGARRAY { return Enum.decodeArray(objects: array) }
        HGReportHandler.report("optional: |\(self)| is not [Enum] mapable, returning []", response: .Error)
        return []
    }
    
    var enumcase: EnumCase {
        if let dict = self as? HGDICT { return EnumCase.decode(object: dict) }
        HGReportHandler.report("optional: |\(self)| is not Relationship mapable, returning new EnumCase", response: .Error)
        return EnumCase.new
    }
    
    var enumcases: [EnumCase] {
        if let array = self as? HGARRAY { return EnumCase.decodeArray(objects: array) }
        HGReportHandler.report("optional: |\(self)| is not [EnumCase] mapable, returning []", response: .Error)
        return []
    }
    
    var deletionRule: DeletionRule {
        if let int = self as? Int { return DeletionRule.create(int: int) }
        if let string = self as? String { return DeletionRule.create(string: string) }
        HGReportHandler.report("optional: |\(self)| is not DeletionRule mapable, using .Nullify", response: .Error)
        return .Nullify
    }
    
    var licenseType: LicenseType {
        if let int = self as? Int { return LicenseType.create(int: int) }
        HGReportHandler.report("optional: |\(self)| is not LicenseType mapable, using .MIT", response: .Error)
        return .MIT
    }
    
    var relationshipType: RelationshipType {
        if let int = self as? Int { return RelationshipType.create(int: int) }
        if let string = self as? String { return RelationshipType.create(string: string) }
        // HGReportHandler.report("optional: |\(self)| is not RelationshipType mapable, using .TooOne", response: .Error)
        return .TooOne
    }
    
    var attributeType: AttributeType {
        if let int = self as? Int { return AttributeType.create(int: int) }
        if let string = self as? String { return AttributeType.create(string: string) }
        HGReportHandler.report("self: |\(self)| is not AttributeType mapable, using ._Int16", response: .Error)
        return ._Int16
    }
    
    var importFileType: ImportFileType {
        if let int = self as? Int { return ImportFileType.create(int: int) }
        HGReportHandler.report("optional: |\(self)| is not an ImportFileType mapable, using .XCODE_XML", response: .Error)
        return .XCODE_XML
    }
    
    var interval: NSTimeInterval {
        if let interval = self as? Double { return interval }
        HGReportHandler.report("optional: |\(self)| is not NSTimeInterval mapable, using 0", response: .Error)
        return 0
    }
    
    var int16: Int16 {
        if let int = self as? Int {
            if abs(int) > Int(Int16.max) { return Int16(int) }
        }
        HGReportHandler.report("optional: |\(self)| is not Int16 mapable, using 0", response: .Error)
        return 0
    }
    
    var int32: Int32 {
        if let int = self as? Int {
            if abs(int) > Int(Int32.max) { return Int32(int) }
        }
        HGReportHandler.report("optional: |\(self)| is not Int32 mapable, using 0", response: .Error)
        return 0
    }
    
    var string: String {
        if let string = self as? String { return string }
        HGReportHandler.report("optional: |\(self)| is not String mapable, using Empty String", response: .Error)
        return ""
    }
    
    var optionalString: String? {
        if self == nil { return nil }
        if let string = self as? String { return string }
        HGReportHandler.report("optional: |\(self)| is not Optional String mapable, using nil String?", response: .Error)
        return nil
    }
    
    var arrayString: [String] {
        if let array = self as? [String] { return array }
        HGReportHandler.report("optional: |\(self)| is not Optional String mapable, using Empty [String]", response: .Error)
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
        
        HGReportHandler.report("optional: |\(self)| is not Bool mapable, using false", response: .Error)
        return false
    }
}

extension Optional {
    
    
    
    
}