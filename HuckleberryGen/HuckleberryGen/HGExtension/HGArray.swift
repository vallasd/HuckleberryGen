//
//  HGArray.swift
//  HuckleberryGen
//
//  Created by David Vallas on 7/17/15.
//  Copyright © 2015 Phoenix Labs. All rights reserved.
//

import Foundation

extension Array where Element: Hashable {
    
    /// returns the unique values in a Hashable array
    var unique: [Element] {
        return Array(Set(self))
    }
}

extension Array {
    
    /// Removes all indexes from the Array if they are valid indexes.  Checks for array bounds and redundant indexes and appropriately handles.
    mutating func removeIndexes(indexes: [Int]) {
        
        // creates a uniq / sorted list
        let uniq = indexes.unique.sort()
        
        // only uses acceptable index set in bounds of array
        let bounded = uniq.filter { $0 >= 0 && $0 < self.count }
        
        // removes all uniq / sorted / bounded index values
        var index_offset = 0
        for index in bounded {
            self.removeAtIndex(index - index_offset)
            index_offset++
        }
    }
    
    /// checks if object is within the index, if so, returns object, else creates error and returns nil
    func object(atIndex index: Int) -> Element? {
    
        if self.indices.contains(index) {
            return self[index]
        }
        
        HGReportHandler.shared.report("Array: |\(self)| attempting to return index that is out of bounds, returning nil", type: .Error)
        return nil
    }
    
    /// checks if object is within the index, if so, returns object, else, if user sets error to true, reports error and returns nil
    func object(atIndex index: Int, reportError error: Bool) -> Element? {
        
        if self.indices.contains(index) {
            return self[index]
        }
        
        if (error) { HGReportHandler.shared.report("Array: |\(self)| attempting to return index that is out of bounds, returning nil", type: .Error) }
        return nil
    }
    
}

