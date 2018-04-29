//
//  Entity.swift
//  HuckleberryGen
//
//  Created by David Vallas on 7/24/15.
//  Copyright © 2015 Phoenix Labs.
//
//  All Rights Reserved.

import Cocoa

enum EntityKey {
    case name
}

/// a struct that represents a model entity
struct Entity: HGEncodable {
    
    let name: String
    fileprivate(set) var attributes: Set<Attribute>
    
    init(name n: String, attributes a: Set<Attribute>) {
        name = n
        attributes = a
    }
    
    fileprivate func update(name n: String?, attributes a: Set<Attribute>?) -> Entity {
        let name = n == nil ? self.name : n!
        let attributes = a == nil ? self.attributes : a!
        return Entity(name: name, attributes: attributes)
    }
    
    static func image(withName name: String) -> NSImage {
        return NSImage.image(named: "entityIcon", title: name)
    }
    
    // MARK: HGEcodable
    
    static var encodeError: Entity {
        return Entity(name: "Error", attributes: [])
    }
    
    var encode: Any {
        var dict = HGDICT()
        dict["name"] = name
        dict["attributes"] = attributes.encode
        return dict as AnyObject
    }
    
    static func decode(object: Any) -> Entity {
        let dict = HG.decode(hgdict: object, decoderName: "Entity")
        let n = dict["name"].string
        let a = dict["attributes"].attributeSet
        return Entity(name: n, attributes: a)
    }
    
    mutating func createIteratedAttribute() -> Attribute? {
        return attributes.createIterated()
    }
    
    mutating func deleteAttribute(name n: String) -> Bool {
        return attributes.delete(name: n)
    }
    
    func getAttribute(name n: String) -> Attribute? {
        return attributes.get(name: n)
    }
    
    mutating func updateAttribute(keys: [AttributeKey], withValues vs: [Any], name n: String) -> Attribute? {
        return attributes.update(keys: keys, withValues: vs, name: n)
    }
}

extension Set where Element == Entity {
    
    mutating func create(entity e: Entity) -> Entity? {
        if !insert(e).inserted {
            HGReport.shared.insertFailed(set: Entity.self, object: e)
            return nil
        }
        return e
    }
    
    mutating func createIterated() -> Entity? {
        let name = map { $0.name }.iteratedTypeRepresentable(string: "New Entity")
        let e = Entity(name: name, attributes: [])
        return create(entity: e)
    }
    
    mutating func delete(name n: String) -> Bool {
        let entity = Entity(name: n, attributes: [])
        let o = remove(entity)
        if o == nil {
            HGReport.shared.deleteFailed(set: Entity.self, object: entity)
            return false
        }
        return true
    }
    
    func get(name n: String) -> Entity? {
        let entities = self.filter { $0.name == n }
        if entities.count == 0 {
            HGReport.shared.getFailed(set: Entity.self, keys: ["name"], values: [n])
            return nil
        }
        return entities.first!
    }
    
    mutating func update(keys: [EntityKey], withValues vs: [Any], name n: String) -> Entity? {
        
        // if keys dont match values, return
        if keys.count != vs.count {
            HGReport.shared.updateFailedKeyMismatch(set: Entity.self)
            return nil
        }
        
        // get the entity from the set
        guard let oldEntity = get(name: n) else {
            return nil
        }
        
        // set key variables to nil
        var name: String?, attributes: Set<Attribute>?
        
        // validate and assign properties
        var i = 0
        for key in keys {
            let v = vs[i]
            switch key {
            case .name: name = HGValidate.validate(value: v, key: key, decoder: Entity.self)
            }
            i += 1
        }
        
        // make sure name is iterated, we are going to delete old record and add new
        if name != nil {
            name = self.map { $0.name }.iteratedTypeRepresentable(string: name!)
        }
        
        // use traditional update
        let newEntity = oldEntity.update(name: name, attributes: attributes)
        let _ = delete(name: oldEntity.name)
        let updated = create(entity: newEntity)
        
        return updated
    }
}


// MARK: Hashing

extension Entity: Hashable { var hashValue: Int { return name.hashValue } }
extension Entity: Equatable {};
func ==(lhs: Entity, rhs: Entity) -> Bool { return lhs.name == rhs.name }



