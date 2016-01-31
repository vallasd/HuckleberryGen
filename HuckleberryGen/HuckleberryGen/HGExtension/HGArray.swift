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
    
    func bounded(indexes: [Int]) -> [Int] {
        
        // creates a unique / sorted list
        let sorted = indexes.unique.sort()
        
        // only uses acceptable index set in bounds of array
        return sorted.filter { $0 >= 0 && $0 < self.count }
    }
    
    /// Removes all indexes from the Array if they are valid indexes.  Checks for array bounds and redundant indexes and appropriately handles.
    mutating func removeIndexes(indexes: [Int]) {
        
        // only uses acceptable index set in bounds of array
        let bounded = self.bounded(indexes)
        
        // removes all uniq / sorted / bounded index values
        var index_offset = 0
        for index in bounded {
            self.removeAtIndex(index - index_offset)
            index_offset++
        }
    }
    
    
    /// checks if object is within the index, if so, returns object, else creates error and returns nil
    func objects(atIndexes a: [Int]) -> [Element] {
        
        let goodIndexes = a.filter { self.indices.contains($0) == true }
        
        if goodIndexes.count < a.count {
            let difference = goodIndexes.count - a.count
            HGReportHandler.shared.report("objects: |\(difference)| indexe(s) out of bounds", type: .Error)
        }
        
        // get objects from good indexes
        var objects: [Element] = []
        for index in goodIndexes {
            objects.append(self[index])
        }
        
        return objects
    }
    
    
    /// checks if object is within the index, if so, returns object, else creates error and returns nil
    func object(atIndex index: Int) -> Element? {
    
        if self.indices.contains(index) {
            return self[index]
        }
        
        HGReportHandler.shared.report("Array: |\(self)| attempting to return index that is out of bounds, returning nil", type: .Error)
        return nil
    }
}

