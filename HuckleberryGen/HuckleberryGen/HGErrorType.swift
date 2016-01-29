//   InfiniteUI
//   HGErrorType created (on: 01-28-2016 for: David Vallas)
//
//   Copyright (c) 2016 Cisco  
//
//   All Rights Reserved.

import Foundation

enum HGErrorType {

	case Info
	case Warn
	case Error
	case Alert
	case Assert

	var int: Int {
		switch self {
		case Info: return 0
		case Warn: return 1
		case Error: return 2
		case Alert: return 3
		case Assert: return 4
		}
	}

	var string: String {
		switch self {
		case Info: return "Info"
		case Warn: return "Warn"
		case Error: return "Error"
		case Alert: return "Alert"
		case Assert: return "Assert"
		}
	}
}

extension HGErrorType: HGEncodable {

	static var new: HGErrorType {
		return HGErrorType.Info
	}

	var encode: AnyObject {
		return self.int
	}

	static func decode(object object: AnyObject) -> HGErrorType {
		if let int = object as? Int { return int.hGErrorType }
		if let string = object as? String { return string.hGErrorType }
		appDelegate.error.report("object \(object) is not |HGErrorType| decodable, returning Info", type: .Error)
		return HGErrorType.new
	}
}
