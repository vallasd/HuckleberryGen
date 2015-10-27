//
//  HGScalarString.swift
//  HuckleberryGen
//
//  Created by David Vallas on 7/24/15.
//  Copyright © 2015 Phoenix Labs. All rights reserved.
//

import Foundation

/*

struct HGScalarString: Hashable {
    
    private let array: [UInt32]
    
    var hashValue : Int {
        var hash = [Int](count: Int(CC_SHA256_DIGEST_LENGTH) / sizeof(Int), repeatedValue: 0)
        withUnsafeBufferPointer { ptr in
            hash.withUnsafeMutableBufferPointer { (inout hPtr: UnsafeMutableBufferPointer<Int>) -> Void in
                CC_SHA256(UnsafePointer<Void>(ptr.baseAddress), CC_LONG(count * sizeof(Element)), UnsafeMutablePointer<UInt8>(hPtr.baseAddress))
            }
        }
        return hash[0]
    }
    
}

extension HGScalarString: Equatable {}
func ==<T>(lhs: HGScalarString, rhs: HGScalarString) -> Bool {
    return lhs.hashValue == rhs.hashValue
}

*/