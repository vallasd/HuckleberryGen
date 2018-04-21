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
