//
//  BoardHandler.swift
//  HuckleberryGen
//
//  Created by David Vallas on 7/16/15.
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

enum HGAdjective {

	case exceptional
	case great
	case good
	case ugly
	case timid
	case fantastic
	case humble
	case lost
	case petulant
	case irksome
	case zealous
	case wretched
	case curious
	case naive
	case wicked
	case poor
	case stupendous
	case futuristic
	case crappy
	case excellent

	var int: Int {
		switch self {
		case .exceptional: return 0
		case .great: return 1
		case .good: return 2
		case .ugly: return 3
		case .timid: return 4
		case .fantastic: return 5
		case .humble: return 6
		case .lost: return 7
		case .petulant: return 8
		case .irksome: return 9
		case .zealous: return 10
		case .wretched: return 11
		case .curious: return 12
		case .naive: return 13
		case .wicked: return 14
		case .poor: return 15
		case .stupendous: return 16
		case .futuristic: return 17
		case .crappy: return 18
		case .excellent: return 19
		}
	}

	var string: String {
		switch self {
		case .exceptional: return "Exceptional"
		case .great: return "Great"
		case .good: return "Good"
		case .ugly: return "Ugly"
		case .timid: return "Timid"
		case .fantastic: return "Fantastic"
		case .humble: return "Humble"
		case .lost: return "Lost"
		case .petulant: return "Petulant"
		case .irksome: return "Irksome"
		case .zealous: return "Zealous"
		case .wretched: return "Wretched"
		case .curious: return "Curious"
		case .naive: return "Naive"
		case .wicked: return "Wicked"
		case .poor: return "Poor"
		case .stupendous: return "Stupendous"
		case .futuristic: return "Futuristic"
		case .crappy: return "Crappy"
		case .excellent: return "Excellent"
		}
	}
}

extension HGAdjective: HGEncodable {

	static var new: HGAdjective {
		return HGAdjective.exceptional
	}

	var encode: AnyObject {
		return self.int as AnyObject
	}

	static func decode(object: AnyObject) -> HGAdjective {
		if let int = object as? Int { return int.hGAdjective }
		if let string = object as? String { return string.hGAdjective }
		HGReportHandler.shared.report("object \(object) is not |HGAdjective| decodable, returning Exceptional", type: .error)
		return HGAdjective.new
	}
}
