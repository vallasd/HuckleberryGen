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

enum HGArticle {

	case the
	case any
	case one
	case that
	case most
	case some
	case aKindOf
	case theLeast
	case aParticularly
	case aClearly
	case theOriginal
	case aFairly
	case another
	case oh
	case aCompletely
	case oneCrazy
	case definatelyOne
	case bewareOfThe
	case aHistoryOfThe
	case aStoryAboutThe

	var int: Int {
		switch self {
		case .the: return 0
		case .any: return 1
		case .one: return 2
		case .that: return 3
		case .most: return 4
		case .some: return 5
		case .aKindOf: return 6
		case .theLeast: return 7
		case .aParticularly: return 8
		case .aClearly: return 9
		case .theOriginal: return 10
		case .aFairly: return 11
		case .another: return 12
		case .oh: return 13
		case .aCompletely: return 14
		case .oneCrazy: return 15
		case .definatelyOne: return 16
		case .bewareOfThe: return 17
		case .aHistoryOfThe: return 18
		case .aStoryAboutThe: return 19
		}
	}

	var string: String {
		switch self {
		case .the: return "The"
		case .any: return "Any"
		case .one: return "One"
		case .that: return "That"
		case .most: return "Most"
		case .some: return "Some"
		case .aKindOf: return "A Kind of"
		case .theLeast: return "The Least"
		case .aParticularly: return "A Particularly"
		case .aClearly: return "A Clearly"
		case .theOriginal: return "The Original"
		case .aFairly: return "A Fairly"
		case .another: return "Another"
		case .oh: return "Oh !!!@$#!%^&*(){}//,.';:!!!"
		case .aCompletely: return "A Completely"
		case .oneCrazy: return "One !Crazy!"
		case .definatelyOne: return "Definately! One"
		case .bewareOfThe: return "Beware of the"
		case .aHistoryOfThe: return "A History of the"
		case .aStoryAboutThe: return "A Story about the"
		}
	}
}

extension HGArticle: HGEncodable {

	static var new: HGArticle {
		return HGArticle.the
	}

	var encode: AnyObject {
		return self.int as AnyObject
	}

	static func decode(object: AnyObject) -> HGArticle {
		if let int = object as? Int { return int.hGArticle }
		if let string = object as? String { return string.hGArticle }
		HGReportHandler.shared.report("object \(object) is not |HGArticle| decodable, returning The", type: .error)
		return HGArticle.new
	}
}
