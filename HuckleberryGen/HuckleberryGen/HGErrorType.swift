//
//  BoardHandler.swift
//  HuckleberryGen
//
//  Created by David Vallas on 7/16/15.
//  Copyright © 2015 Phoenix Labs.
//
//  All Rights Reserved.

import Foundation

enum HGErrorType: Int {

	case info = 0
	case warn = 1
	case error = 2
	case alert = 3
	case assert = 4

	var string: String {
		switch self {
		case .info: return "Info"
		case .warn: return "Warn"
		case .error: return "Error"
		case .alert: return "Alert"
		case .assert: return "Assert"
		}
	}
}

extension HGErrorType: HGEncodable {
    
    static var encodeError: HGErrorType {
        return .info
    }

	var encode: Any {
		return self.rawValue
	}

	static func decode(object: Any) -> HGErrorType {
		if let int = object as? Int { return int.hGErrorType }
		if let string = object as? String { return string.hGErrorType }
		HGReportHandler.shared.report("object \(object) is not |HGErrorType| decodable, returning Info", type: .error)
		return .info
	}
}
