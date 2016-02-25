//
//  HGKeyGen.swift
//  HuckleberryPi
//
//  Created by David Vallas on 7/3/15.
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

//  You should have received a copy of the GNU General Public License
//  along with HuckleberryGen.  If not, see <http://www.gnu.org/licenses/>.

import CoreData
import Foundation



let hgGenMinAge: UInt32 = 15
let hgGenMaxAge: UInt32 = 85
let hgGenCurrentDate: String = NSDate().mmddyy
let hgGenCurrentYear: String = NSDate().yyyy

//class HGGen {
//    
//    static let shared = HGGen()
//    
//    lazy var adjectives: [String] = [ "Smelly", "Tiny" , "Large", "Small", "Strange", "Mysterious", "Simple", "Stupendous", "Incredible", "Delicious" ]
//    
//    lazy var pies: [String] = [ "Apple", "Bacon and Egg", "Banana Cream", "Bean", "Blackberry", "Blueberry", "Bumbleberry", "Butter Tart", "Buttermilk",
//        "Caramel Tart", "Cheese", "Cherry", "Curry", "Huckleberry", "Meat", "Mince", "Pecan", "Pot", "Raisen", "Raspberry", "Shoofly", "Sugar" ]
//    
//    lazy var names: [String] = [ "Larry", "David", "George", "Allen", "Gary", "John", "Tim", "Colin", "Christopher", "Vicky", "Ava", "Olivia", "Abigail",
//        "Emily", "Adeline", "Gianna", "Mike", "Waldo", "Frank", "Bernard", "Roger", "Harry", "Beth", "Biance" ]
//    
//    static var randAge: UInt32 = hgGenMaxAge - hgGenMinAge
//    static var minAge: Int = Int(hgGenMinAge)
//    
//    static func generateSGReport(hgEntity hgEntity: HGEntity) -> HGReport { return HGReport(entity: hgEntity.name) }
//    
//    static func randomPie() -> String {
//        let a = HGGen.shared.adjectives[Int(arc4random_uniform(UInt32(HGGen.shared.adjectives.count)))]
//        let p = HGGen.shared.pies[Int(arc4random_uniform(UInt32(HGGen.shared.pies.count)))]
//        return a + " " + p + " Pie"
//    }
//    
//    // MARK: RANDOM PRIMITIVES
//    
//    static func randomName() -> String {
//        return HGGen.shared.names[Int(arc4random_uniform(UInt32(HGGen.shared.names.count)))]
//    }
//    
//    static func randomAge() -> Int {
//        return Int(arc4random_uniform(HGGen.randAge)) + HGGen.minAge
//    }
//    
//    static func randomInt16() -> Int {
//        return Int(arc4random_uniform(UInt32(Int16.max)))
//    }
//    
//    static func randomInt32() -> Int {
//        return Int(arc4random_uniform(UInt32(Int32.max)))
//    }
//    
//    static func uniqString() -> String {
//        let s = NSMutableData(length: 32)!
//        SecRandomCopyBytes(kSecRandomDefault, s.length, UnsafeMutablePointer<UInt8>(s.mutableBytes))
//        return s.base64EncodedStringWithOptions([])
//    }
//    
//    // MARK: RANDOM LARGE DATA SETS
//    
//    static func randomDicts(count count: UInt32, withAttributes: UInt32) -> HGARRAY {
//        var array = HGARRAY()
//        if count == 0 { return array }
//        for _ in 1...count { array.append(randomAttributeDict(withAttributes)) }
//        return array
//    }
//    
//    static func randomAttributeDict(count: UInt32) -> HGDICT {
//        var dict = HGDICT()
//        dict["String"] = uniqString()
//        dict["Int16"] = randomInt16()
//        dict["Int32"] = randomInt32()
//        if count == 0 { return dict }
//        for _ in 1...count { dict[uniqString()] = uniqString() }
//        return dict
//    }
//    
//    // MARK: PRIVATE METHODS
//    
//    
//    
//    
//}