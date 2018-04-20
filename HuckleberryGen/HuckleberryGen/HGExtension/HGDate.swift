//
//  HGDate.swift
//  HuckleberryGen
//
//  Created by David Vallas on 7/12/15.
//  Copyright © 2015 Phoenix Labs.
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

import Foundation

extension Date
{
    
    /// returns second integer value of NSDate
    var second: Int {
        let calendar = Calendar.current
        let components = (calendar as NSCalendar).components(.second, from: self)
        return components.second!
    }
    
    /// returns minute integer value of NSDate
    var minute: Int {
        let calendar = Calendar.current
        let components = (calendar as NSCalendar).components(.minute, from: self)
        return components.minute!
    }
    
    /// returns hour integer value of NSDate
    var hour: Int {
        let calendar = Calendar.current
        let components = (calendar as NSCalendar).components(.hour, from: self)
        return components.hour!
    }
    
    /// returns year integer value of NSDate
    var year: Int {
        let calendar = Calendar.current
        let components = (calendar as NSCalendar).components(.year, from: self)
        return components.year!
    }
    
    /// creates a string of MM/DD/YY for NSDate
    var mmddyy: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy"
        let dateString = dateFormatter.string(from: self)
        return dateString
    }
    
    /// creates a string of MM/DD/YY h:mm:ss a for NSDate
    var mmddyymmss: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy hh:mm:ss a"
        let dateString = dateFormatter.string(from: self)
        return dateString
    }
    
    /// creates a string of yyyy for NSDate
    var yyyy: String {
        return "\(self.year)"
    }
    
    /// creates a short style string of NSDate
    var short: String {
        //Get Short Time String
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        let timeString = formatter.string(from: self)
        
        //Return Short Time String
        return timeString
    }
    
}


// Sorting Dates

func <(a: Date, b: Date) -> Bool {
    return a.compare(b) == ComparisonResult.orderedAscending
}

func ==(a: Date, b: Date) -> Bool {
    return a.compare(b) == ComparisonResult.orderedSame
}
