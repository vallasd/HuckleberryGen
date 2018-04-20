//   InfiniteUI
//   HGErrorType created (on: 01-28-2016 for: David Vallas)
//
//   Copyright (c) 2016 Cisco  
//
//   All Rights Reserved.

import Foundation

enum HGErrorType {

	case info
	case warn
	case error
	case alert
	case assert

	var int: Int {
		switch self {
		case .info: return 0
		case .warn: return 1
		case .error: return 2
		case .alert: return 3
		case .assert: return 4
		}
	}

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

	static var new: HGErrorType {
		return HGErrorType.info
	}

	var encode: AnyObject {
		return self.int as AnyObject
	}

	static func decode(object: AnyObject) -> HGErrorType {
		if let int = object as? Int { return int.hGErrorType }
		if let string = object as? String { return string.hGErrorType }
		HGReportHandler.shared.report("object \(object) is not |HGErrorType| decodable, returning Info", type: .error)
		return HGErrorType.new
	}
}
