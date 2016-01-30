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
protocol HGTypeRepresentable {
    
    var typeRep: String { get }
}

/// A string representation of the objects variable.  Example: recordingState || recordingStateSet
protocol HGVarRepresentable {
    
    var varRep: String { get }
}

/// A string representation of the objects default return value.  Example: Float, "0.0".  Entity, Entity.new
protocol HGDefaultRepresentable {
    
    var defaultRep: String { get }
}

/// A string representation of the objects default return value.  Example: Thing is Float, defaultRep -> "0.0".  Thing is enum HGErrorType, defaultRep -> "Warn"
protocol HGDecodeRepresentable {
    
    var decodeRep: String { get }
}

/// whether object has
protocol HashRepresentable {
    
    var string: [HGVarRepresentable] { get }
}

/// whether object is let vs var object when typed
protocol Mutable {
    
    var mutable: Bool { get }
}
