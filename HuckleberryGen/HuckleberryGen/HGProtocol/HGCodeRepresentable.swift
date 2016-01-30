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
    
    func typeRep() -> String
}

/// A string representation of the objects variable.  Example: recordingState || recordingStateSet
protocol HGVarRepresentable {
    
    func varRep() -> String
}

/// A string representation of the objects default return value.  Example: Float, "0.0".  Entity, Entity.new
protocol HGDefaultRepresentable {
    
    func defaultRep() -> String
}

/// A string representation of the objects default return value.  Example: Thing is Float, defaultRep -> "0.0".  Thing is enum HGErrorType, defaultRep -> "Warn"
protocol HGDecodeRepresentable {
    
    func decodeRep() -> String
}

/// whether object is let vs var object when typed
protocol HGLetCheckable: HGTypeRepresentable {
    
    func isLet() -> Bool
}
