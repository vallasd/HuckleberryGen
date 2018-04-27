//
//  BoardHandler.swift
//  HuckleberryGen
//
//  Created by David Vallas on 7/16/15.
//  Copyright © 2015 Phoenix Labs.
//
//  All Rights Reserved.

import Foundation

extension Int {

	/// returns HGErrorTypes.  Logs error and returns Info if not a valid Int.
	var hGErrorType: HGErrorType {
 		switch self {
		case 0: return .info 
		case 1: return .warn 
		case 2: return .error 
		case 3: return .alert 
		case 4: return .assert 
		default:
			HGReport.shared.report("int: |\(self)| is not enum |HGErrorType| mapable, using Info", type: .error)
		}
		return .info
	}
    
    /// returns HGErrorTypes.  Logs error and returns Info if not a valid Int.
    var hGType: HGType {
        switch self {
        case 0: return .primitive
        case 1: return .enuM
        case 2: return .entity
        default:
            HGReport.shared.report("int: |\(self)| is not enum |HGType| mapable, using Info", type: .error)
        }
        return .primitive
    }
}
