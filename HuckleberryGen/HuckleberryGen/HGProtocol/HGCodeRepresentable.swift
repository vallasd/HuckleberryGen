//
//  HGCodeRepresentable.swift
//  HuckleberryGen
//
//  Created by David Vallas on 1/28/16.
//  Copyright © 2016 Phoenix Labs.
//
//  All Rights Reserved.

import Cocoa

// This objects used for Exporting Code.  They should be string representations of XCODE key terms.  Stuff that will turn Blue.

/// A string representation of the objects Type. Example: RecordingState
protocol TypeRepresentable {
    var type: String { get }
}

/// A string representation of the objects variable.  Example: recordingState || recordingStateSet
protocol VarRepresentable {
    var VAR: String { get }
}

extension Array where Element == String {
    
    func type(string: String) -> String {
        let string = string.typeRepresentable
        if self.contains(string) {
            let iterationNum = self.count + 1
            return string + "\(iterationNum)"
        }
    }
    
    func varRep(string: String) -> String {
        let string = string.varRepresentable
        if self.contains(string) {
            let iterationNum = self.count + 1
            return string + "\(iterationNum)"
        }
    }
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
