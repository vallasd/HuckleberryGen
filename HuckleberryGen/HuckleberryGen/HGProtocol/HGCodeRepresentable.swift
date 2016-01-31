//
//  HGCodeRepresentable.swift
//  HuckleberryGen
//
//  Created by David Vallas on 1/28/16.
//  Copyright © 2016 Phoenix Labs. All rights reserved.
//

import Foundation

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
protocol HashRepresentable {
    
    var string: [VarRepresentable] { get }
}

/// whether object is let vs var object when typed
protocol Mutable {
    
    var mutable: Bool { get }
}
