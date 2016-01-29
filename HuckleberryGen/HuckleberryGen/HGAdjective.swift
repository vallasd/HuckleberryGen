//   InfiniteUI
//   HGAdjective created (on: 01-28-2016 for: David Vallas)
//
//   Copyright (c) 2016 Cisco  
//
//   All Rights Reserved.

import Foundation

enum HGAdjective {

	case Exceptional
	case Great
	case Good
	case Ugly
	case Timid
	case Fantastic
	case Humble
	case Lost
	case Petulant
	case Irksome
	case Zealous
	case Wretched
	case Curious
	case Naive
	case Wicked
	case Poor
	case Stupendous
	case Futuristic
	case Crappy
	case Excellent

	var int: Int {
		switch self {
		case Exceptional: return 0
		case Great: return 1
		case Good: return 2
		case Ugly: return 3
		case Timid: return 4
		case Fantastic: return 5
		case Humble: return 6
		case Lost: return 7
		case Petulant: return 8
		case Irksome: return 9
		case Zealous: return 10
		case Wretched: return 11
		case Curious: return 12
		case Naive: return 13
		case Wicked: return 14
		case Poor: return 15
		case Stupendous: return 16
		case Futuristic: return 17
		case Crappy: return 18
		case Excellent: return 19
		}
	}

	var string: String {
		switch self {
		case Exceptional: return "Exceptional"
		case Great: return "Great"
		case Good: return "Good"
		case Ugly: return "Ugly"
		case Timid: return "Timid"
		case Fantastic: return "Fantastic"
		case Humble: return "Humble"
		case Lost: return "Lost"
		case Petulant: return "Petulant"
		case Irksome: return "Irksome"
		case Zealous: return "Zealous"
		case Wretched: return "Wretched"
		case Curious: return "Curious"
		case Naive: return "Naive"
		case Wicked: return "Wicked"
		case Poor: return "Poor"
		case Stupendous: return "Stupendous"
		case Futuristic: return "Futuristic"
		case Crappy: return "Crappy"
		case Excellent: return "Excellent"
		}
	}
}

extension HGAdjective: HGEncodable {

	static var new: HGAdjective {
		return HGAdjective.Exceptional
	}

	var encode: AnyObject {
		return self.int
	}

	static func decode(object object: AnyObject) -> HGAdjective {
		if let int = object as? Int { return int.hGAdjective }
		if let string = object as? String { return string.hGAdjective }
		appDelegate.error.report("object \(object) is not |HGAdjective| decodable, returning Exceptional", type: .Error)
		return HGAdjective.new
	}
}
