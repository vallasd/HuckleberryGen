//
//  HGCodeRepresentable.swift
//  HuckleberryGen
//
//  Created by David Vallas on 1/28/16.
//  Copyright © 2016 Phoenix Labs.
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

import Cocoa

// This objects used for Exporting Code.  They should be string representations of XCODE key terms.  Stuff that will turn Blue.

/// A string representation of the objects Type. Example: RecordingState
protocol TypeRepresentable {
    
    var typeRep: String { get }
}

extension TypeRepresentable where Self: Hashable {
 
    /// returns the typeRep variable, iterated if another object in array already had value
    func iteratedTypeRep(forArray array: [Self]) -> String? {
        if array.contains(self) {
            let iterationNum = array.count + 1
            return self.typeRep + "\(iterationNum)"
        }
        return nil
    }
}

/// A string representation of the objects variable.  Example: recordingState || recordingStateSet
protocol VarRepresentable {
    
    var varRep: String { get }
}

extension VarRepresentable where Self: Hashable {
    
    /// returns the varRep variable, iterated if another object in array already had value
    func iteratedVarRep(forArray array: [Self]) -> String? {
        if array.contains(self) {
            let iterationNum = array.count + 1
            return self.varRep + "\(iterationNum)"
        }
        return nil
    }
}

/// A string representation of the objects default return value.  Example: Float, "0.0".  Entity, Entity.new
protocol DefaultRepresentable {
    
    var defaultRep: String { get }
}

/// A string representation of the objects default return value.  Example: Thing is Float, defaultRep -> "0.0".  Thing is enum HGErrorType, defaultRep -> "Warn"
protocol DecodeRepresentable {
    
    var decodeRep: String { get }
}

/// whether object has
protocol HashRepresentable: Hashable {
    var typeRep: String { get }
    var varRep: String { get }
    var isEntity: Bool { get }
}

struct HashObject: HashRepresentable {
    let typeRep: String
    let varRep: String
    let isEntity: Bool
    
    init(typeRep t: String, varRep v: String, isEntity e: Bool) {
        typeRep = t
        varRep = v
        isEntity = e
    }
    
    var hashTitle: String {
        return isEntity ? "#\(varRep)" : varRep
    }
    
    var image: NSImage {
        return NSImage.image(named: "hashIcon", title: hashTitle)
    }
}

extension HashObject: Hashable { var hashValue: Int { return typeRep.hashValue } }
extension HashObject: Equatable {}; func ==(lhs: HashObject, rhs: HashObject) -> Bool { return lhs.typeRep == rhs.typeRep }

extension HashObject: HGEncodable {
    
    var encode: AnyObject {
        var dict = HGDICT()
        dict["typeRep"] = typeRep
        dict["varRep"] = varRep
        dict["isEntity"] = isEntity
        return dict
    }
    
    static func decode(object object: AnyObject) -> HashObject {
        let dict = hgdict(fromObject: object, decoderName: "HashObject")
        let typeRep = dict["typeRep"].string
        let varRep = dict["varRep"].string
        let isEntity = dict["isEntity"].bool
        return HashObject(typeRep: typeRep, varRep: varRep, isEntity: isEntity)
    }
    
}

extension HashRepresentable  {
    
    var encodeHash: HGDICT {
        var dict = HGDICT()
        dict["typeRep"] = typeRep
        dict["varRep"] = varRep
        dict["isEntity"] = isEntity
        return dict
    }
    
    var decodeHash: HashObject {
        return HashObject(typeRep: typeRep, varRep: varRep, isEntity: isEntity)
    }
}

extension HashRepresentable where Self: Hashable {
    
    
    /// returns the typeRep variable, iterated if another object in array already had value
    func iteratedTypeRep(forArray array: [Self]) -> String? {
        if array.contains(self) {
            let iterationNum = array.count + 1
            return self.typeRep + "\(iterationNum)"
        }
        return nil
    }
    
    /// returns the varRep variable, iterated if another object in array already had value
    func iteratedVarRep(forArray array: [Self]) -> String? {
        if array.contains(self) {
            let iterationNum = array.count + 1
            return self.varRep + "\(iterationNum)"
        }
        return nil
    }
    
}


extension SequenceType where Generator.Element: HashRepresentable {
    
    var encodeHash: [HGDICT] {
        return self.map { $0.encodeHash }
    }
    
    var decodeHashes: [HashObject] {
        return self.map { $0.decodeHash }
    }
}



/// whether object is let vs var object when typed
protocol Mutable {
    
    var mutable: Bool { get }
}
