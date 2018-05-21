
import Foundation
import CoreData

//extension Optional where .Some == HGPrimitiveEncodable {
//    
//}

extension Optional {
    
    var importFile: ImportFile {
        if let dict = self as? HGDICT { return ImportFile.decode(object: dict) }
        HGReport.shared.report("optional: |\(String(describing: self ?? nil))| is not Entity mapable, returning new ImportFile", type: .error)
        return ImportFile.new
    }
    
    var importFiles: [ImportFile] {
        if let array = self as? HGARRAY { return ImportFile.decode(object: array) }
        HGReport.shared.report("optional: |\(String(describing: self))| is not [ImportFile] mapable, returning []", type: .error)
        return []
    }
    
    var huckleberryGen: HuckleberryGen {
        if let dict = self as? HGDICT { return HuckleberryGen.decode(object: dict) }
        HGReport.shared.report("optional: |\(String(describing: self))| is not HuckleberryGen mapable, returning new HuckleberryGen", type: .error)
        return HuckleberryGen.new
    }
    
    var project: Project {
        if let dict = self as? HGDICT { return Project.decode(object: dict) }
        HGReport.shared.report("optional: |\(String(describing: self))| is not Project mapable, returning new Project", type: .error)
        return Project.new
    }
    
    var licenseInfo: LicenseInfo {
        if let dict = self as? HGDICT { return LicenseInfo.decode(object: dict) }
        HGReport.shared.report("optional: |\(String(describing: self))| is not License mapable, returning new Attribute", type: .error)
        return LicenseInfo.new
    }
    
    var entity: Entity {
        if let dict = self as? HGDICT { return Entity.decode(object: dict) }
        HGReport.shared.report("optional: |\(String(describing: self))| is not Entity mapable, returning new Entity", type: .error)
        return Entity.encodeError
    }
    
    var entityArray: [Entity] {
        if let array = self as? HGARRAY { return Entity.decode(object: array) }
        HGReport.shared.report("optional: |\(String(describing: self))| is not [Entity] mapable, returning []", type: .error)
        return []
    }
    
    var entitySet: Set<Entity> {
        if let array = self as? HGARRAY { return Entity.decode(object: array) }
        HGReport.shared.report("optional: |\(String(describing: self))| is not Set<Entity> mapable, returning []", type: .error)
        return []
    }
    
    var join: Join {
        if let dict = self as? HGDICT { return Join.decode(object: dict) }
        HGReport.shared.report("optional: |\(String(describing: self))| is not Join mapable, returning new Entity", type: .error)
        return Join.encodeError
    }
    
    var joinArray: [Join] {
        if let array = self as? HGARRAY { return Join.decode(object: array) }
        HGReport.shared.report("optional: |\(String(describing: self))| is not [Join] mapable, returning []", type: .error)
        return []
    }
    
    var joinSet: Set<Join> {
        if let array = self as? HGARRAY { return Join.decode(object: array) }
        HGReport.shared.report("optional: |\(String(describing: self))| is not Set<Join> mapable, returning []", type: .error)
        return []
    }
    
    var attributeType: AttributeType {
        return AttributeType.decode(object: self as Any)
    }
    
    var hGtype: HGType {
        return HGType.decode(object: self as Any)
    }
    
    var primitiveAttribute: PrimitiveAttribute {
        if let dict = self as? HGDICT { return PrimitiveAttribute.decode(object: dict) }
        HGReport.shared.report("optional: |\(String(describing: self))| is not PrimitiveAttribute mapable, returning new Attribute", type: .error)
        return PrimitiveAttribute.encodeError
    }
    
    var primitiveAttributeArray: [PrimitiveAttribute] {
        if let array = self as? HGARRAY { return PrimitiveAttribute.decode(object: array) }
        HGReport.shared.report("optional: |\(String(describing: self))| is not [PrimitiveAttribute] mapable, returning []", type: .error)
        return []
    }
    
    var primitiveAttributeSet: Set<PrimitiveAttribute> {
        if let array = self as? HGARRAY { return PrimitiveAttribute.decode(object: array) }
        HGReport.shared.report("optional: |\(String(describing: self))| is not Set<PrimitiveAttribute> mapable, returning []", type: .error)
        return []
    }
    
    var enumAttribute: EnumAttribute {
        if let dict = self as? HGDICT { return EnumAttribute.decode(object: dict) }
        HGReport.shared.report("optional: |\(String(describing: self))| is not EntityAttribute mapable, returning new Attribute", type: .error)
        return EnumAttribute.encodeError
    }
    
    var enumAttributeArray: [EnumAttribute] {
        if let array = self as? HGARRAY { return EnumAttribute.decode(object: array) }
        HGReport.shared.report("optional: |\(String(describing: self))| is not [EnumAttribute] mapable, returning []", type: .error)
        return []
    }
    
    var enumAttributeSet: Set<EnumAttribute> {
        if let array = self as? HGARRAY { return EnumAttribute.decode(object: array) }
        HGReport.shared.report("optional: |\(String(describing: self))| is not Set<EnumAttribute> mapable, returning []", type: .error)
        return []
    }
    
    var entityAttribute: EntityAttribute {
        if let dict = self as? HGDICT { return EntityAttribute.decode(object: dict) }
        HGReport.shared.report("optional: |\(String(describing: self))| is not EntityAttribute mapable, returning new Attribute", type: .error)
        return EntityAttribute.encodeError
    }
    
    var entityAttributeArray: [EntityAttribute] {
        if let array = self as? HGARRAY { return EntityAttribute.decode(object: array) }
        HGReport.shared.report("optional: |\(String(describing: self))| is not [EntityAttribute] mapable, returning []", type: .error)
        return []
    }
    
    var entityAttributeSet: Set<EntityAttribute> {
        if let array = self as? HGARRAY { return EntityAttribute.decode(object: array) }
        HGReport.shared.report("optional: |\(String(describing: self))| is not Set<EntityAttribute> mapable, returning []", type: .error)
        return []
    }
    
    var joinAttribute: JoinAttribute {
        if let dict = self as? HGDICT { return JoinAttribute.decode(object: dict) }
        HGReport.shared.report("optional: |\(String(describing: self))| is not JoinAttribute mapable, returning new Attribute", type: .error)
        return JoinAttribute.encodeError
    }
    
    var joinAttributeArray: [JoinAttribute] {
        if let array = self as? HGARRAY { return JoinAttribute.decode(object: array) }
        HGReport.shared.report("optional: |\(String(describing: self))| is not [JoinAttribute] mapable, returning []", type: .error)
        return []
    }
    
    var joinAttributeSet: Set<JoinAttribute> {
        if let array = self as? HGARRAY { return JoinAttribute.decode(object: array) }
        HGReport.shared.report("optional: |\(String(describing: self))| is not Set<JoinAttribute> mapable, returning []", type: .error)
        return []
    }
    
    var usedName: UsedName {
        if let dict = self as? HGDICT { return UsedName.decode(object: dict) }
        HGReport.shared.report("optional: |\(String(describing: self))| is not UsedName mapable, returning new UsedName", type: .error)
        return UsedName.encodeError
    }
    
    var usedNameArray: [UsedName] {
        if let array = self as? HGARRAY { return UsedName.decode(object: array) }
        HGReport.shared.report("optional: |\(String(describing: self))| is not [UsedName] mapable, returning []", type: .error)
        return []
    }
    
    var usedNameSet: Set<UsedName> {
        if let array = self as? HGARRAY { return UsedName.decode(object: array) }
        HGReport.shared.report("optional: |\(String(describing: self))| is not Set<UsedName> mapable, returning []", type: .error)
        return []
    }
    
    var enuM: Enum {
        if let dict = self as? HGDICT { return Enum.decode(object: dict as AnyObject) }
        HGReport.shared.report("optional: |\(String(describing: self))| is not Enum mapable, returning new Enum", type: .error)
        return Enum.encodeError
    }
    
    var enumArray: [Enum] {
        if let array = self as? HGARRAY { return Enum.decode(object: array) }
        HGReport.shared.report("optional: |\(String(describing: self))| is not [Enum] mapable, returning []", type: .error)
        return []
    }
    
    var enumSet: Set<Enum> {
        if let array = self as? HGARRAY { return Enum.decode(object: array) }
        HGReport.shared.report("optional: |\(String(describing: self))| is not Set<Enum> mapable, returning []", type: .error)
        return []
    }
    
    var enumCase: EnumCase {
        if let dict = self as? HGDICT { return EnumCase.decode(object: dict as AnyObject) }
        HGReport.shared.report("optional: |\(String(describing: self))| is not EnumCase mapable, returning new Enum", type: .error)
        return EnumCase.encodeError
    }
    
    var enumCaseArray: [EnumCase] {
        if let array = self as? HGARRAY { return EnumCase.decode(object: array) }
        HGReport.shared.report("optional: |\(String(describing: self))| is not [EnumCase] mapable, returning []", type: .error)
        return []
    }
    
    var enumCaseSet: Set<EnumCase> {
        if let array = self as? HGARRAY { return EnumCase.decode(object: array) }
        HGReport.shared.report("optional: |\(String(describing: self))| is not Set<EnumCase> mapable, returning []", type: .error)
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
    
    var stringSet: Set<String> {
        if let set = self as? Set<String> { return set }
        if let array = self as? [String] {
            var set: Set<String> = []
            for a in array {
                set.insert(a)
            }
            return set
        }
        HGReport.shared.report("optional: |\(String(describing: self))| is not Set<String> mapable, using Empty [String]", type: .error)
        return []
    }
    
    var intArray: [Int] {
        if let array = self as? [Int] { return array }
        HGReport.shared.report("optional: |\(String(describing: self))| is not [Int] String mapable, using Empty [Int]", type: .error)
        return []
    }
}

extension Optional {
    
    
    
    
}
