//
//  HGDate.swift
//  HuckleberryGen
//
//  Created by David Vallas on 7/12/15.
//  Copyright © 2015 Phoenix Labs. All rights reserved.
//

import Foundation

extension NSDate
{
    func second() -> Int
    {
        //Get Minute
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components(.Second, fromDate: self)
        return components.second
    }
    
    func minute() -> Int
    {
        //Get Minute
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components(.Minute, fromDate: self)
        return components.minute
    }
    
    func hour() -> Int
    {
        //Get Hour
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components(.Hour, fromDate: self)
        return components.hour
    }
    
    func year() -> Int
    {
        //Get Year
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components(.Year, fromDate: self)
        return components.year
    }
    
    /// Creates a string of MM/DD/YY for NSDate
    func stringMonthDayYear() -> String
    {
        //Get Year
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Month, .Day, .Year], fromDate: self)
        return "\(components.month)/\(components.day)/\(components.year)"
    }
    
    /// Creates a string of YYYY for NSDate
    func stringYear() -> String
    {
        return "\(self.year())"
    }
    
    func stringShort() -> String
    {
        //Get Short Time String
        let formatter = NSDateFormatter()
        formatter.timeStyle = .ShortStyle
        let timeString = formatter.stringFromDate(self)
        
        //Return Short Time String
        return timeString
    }
    
}


// Sorting Dates

func <(a: NSDate, b: NSDate) -> Bool {
    return a.compare(b) == NSComparisonResult.OrderedAscending
}

func ==(a: NSDate, b: NSDate) -> Bool {
    return a.compare(b) == NSComparisonResult.OrderedSame
}
