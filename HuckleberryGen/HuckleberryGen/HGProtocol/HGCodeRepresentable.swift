//
//  HGCodeRepresentable.swift
//  HuckleberryGen
//
//  Created by David Vallas on 1/28/16.
//  Copyright © 2016 Phoenix Labs. All rights reserved.
//

import Foundation

// This objects used for Exporting Code.  They should be string representations of XCODE key terms.  Stuff that will turn Blue.

// A string representation of the objects Type. Example: Thing is Recording State so typeRep -> RecordingState
protocol HGTypeRepresentable {
    
    func typeRep() -> String
}

// A string representation of the objects variable.  Example: Thing is Recording State so varRep -> recordingState, varArrayRep -> recordingStateArray
protocol HGVarRepresentable: HGTypeRepresentable {
    
    func varRep() -> String
    func varArrayRep() -> String
}

// A string representation of the objects default return value.  Example: Thing is Float, defaultRep -> "0.0".  Thing is enum HGErrorType, defaultRep -> "Warn"
protocol HGDefaultRepresentable: HGTypeRepresentable {
    
    func defaultRep() -> String
}

// whether object is optional
protocol OptionalCheckable {
    
    func isOptional() -> Bool
}

// whether object is Array
protocol HGArrayCheckable {
    
    func isArray() -> Bool
}

// whether object is let vs var object when typed
protocol HGLetCheckable: HGTypeRepresentable {
    
    func isLet() -> Bool
}
