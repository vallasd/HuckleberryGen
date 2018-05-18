//
//  Join.swift
//  HuckleberryGen
//
//  Created by David Vallas on 5/17/18.
//  Copyright © 2018 Phoenix Labs. All rights reserved.
//

enum JoinKey {
    case name
    case entityName1
    case entityName2
}

typealias JoinKeyDict = Dictionary<JoinKey, Any>

struct Join: HGCodable {
    
    let name: String
    let entityName1: String
    let entityName2: String
    
    fileprivate func update(name n: String?, entityName1 en1: String?, entityName2 en2: String?) -> Join {
        let name = n == nil ? self.name : n!
        let entityName1 = en1 == nil ? self.entityName1 : en1!
        let entityName2 = en2 == nil ? self.entityName2 : en2!
        return Join(name: name,
                    entityName1: entityName1,
                    entityName2: entityName2)
    }
    
    // MARK: - HGCodable
    
    static var encodeError: Join {
        let e = "Error"
        return Join(name: e,
                    entityName1: e,
                    entityName2: e)
    }
    
    var encode: Any {
        var dict = HGDICT()
        dict["name"] = name
        dict["entityName1"] = entityName1
        dict["entityName2"] = entityName2
        return dict
    }
    
    static func decode(object: Any) -> Join {
        let dict = HG.decode(hgdict: object, decoder: EntityAttribute.self)
        let name = dict["name"].string
        let entityName1 = dict["entityName1"].string
        let entityName2 = dict["entityName2"].string
        return Join(name: name,
                    entityName1: entityName1,
                    entityName2: entityName2)
    }
}

extension Set where Element == Join {
    
    // this function is private because we dont want others just creating one entity, use create iterated
    mutating func create(join: Join) -> Join? {
        if insert(join).inserted == false {
            HGReport.shared.insertFailed(set: Join.self, object: join)
            return nil
        }
        return join
    }
    
    // creates Join and its inverse iterated if names already exist
    mutating func createIterated(entityName1 en1: String, entityName2 en2: String) -> Join? {
        
        // create iterated versions of Join names
        let name = self.map { $0.name }.iteratedTypeRepresentable(string: "New Join")
        
        let join = Join(name: name,
                        entityName1: en1,
                        entityName2: en2)
        
        return create(join: join)
    }
    
    mutating func delete(name n: String) -> Bool {
        let join = Join(name: n, entityName1: "", entityName2: "")
        let o = remove(join)
        if o == nil {
            HGReport.shared.deleteFailed(set: Join.self, object: join)
            return false
        }
        return true
    }
    
    func get(name n: String) -> Join? {
        let joins = self.filter { $0.name == n }
        if joins.count == 0 {
            HGReport.shared.getFailed(set: Join.self, keys: ["name"], values: [n])
            return nil
        }
        return joins.first!
    }
    
    mutating func update(keyDict: JoinKeyDict, name n: String) -> Join? {
        
        // get the entity from the set
        guard let oldJoin = get(name: n) else {
            return nil
        }
        
        // set key variables to nil
        var name: String?, entityName1: String?, entityName2: String?
        
        // validate and assign properties
        for key in keyDict.keys {
            switch key {
            case .name: name = HGValidate.validate(value: keyDict[key]!, key: key, decoder: Join.self)
            case .entityName1: entityName1 = HGValidate.validate(value: keyDict[key]!, key: key, decoder: Join.self)
            case .entityName2: entityName2 = HGValidate.validate(value: keyDict[key]!, key: key, decoder: Join.self)
            }
        }
        
        // make sure name is iterated, we are going to delete old record and add new
        if name != nil { name = self.map { $0.name }.iteratedTypeRepresentable(string: name!) }
        
        // use traditional update
        let newJoin = oldJoin.update(name: name,
                                     entityName1: entityName1,
                                     entityName2: entityName2)
        let _ = delete(name: oldJoin.name)
        let updated = create(join: newJoin)
        
        return updated
    }
}

extension Join: Hashable { var hashValue: Int { return name.hashValue } }
extension Join: Equatable {}; func ==(lhs: Join, rhs: Join) -> Bool {
    return lhs.name == rhs.name
}
