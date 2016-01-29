//   InfiniteUI
//   HGNoun created (on: 01-28-2016 for: David Vallas)
//
//   Copyright (c) 2016 Cisco  
//
//   All Rights Reserved.

import Foundation

enum HGNoun {

	case Boy
	case Girl
	case Man
	case Woman
	case Dancer
	case Cowboy
	case Spy
	case Monster
	case Banshee
	case Fella
	case Balloon
	case Whale
	case Swan
	case Film
	case Individual
	case Pyscho
	case Violin
	case Show
	case Kid
	case Movie

	var int: Int {
		switch self {
		case Boy: return 0
		case Girl: return 1
		case Man: return 2
		case Woman: return 3
		case Dancer: return 4
		case Cowboy: return 5
		case Spy: return 6
		case Monster: return 7
		case Banshee: return 8
		case Fella: return 9
		case Balloon: return 10
		case Whale: return 11
		case Swan: return 12
		case Film: return 13
		case Individual: return 14
		case Pyscho: return 15
		case Violin: return 16
		case Show: return 17
		case Kid: return 18
		case Movie: return 19
		}
	}

	var string: String {
		switch self {
		case Boy: return "Boy"
		case Girl: return "Girl"
		case Man: return "Man"
		case Woman: return "Woman"
		case Dancer: return "Dancer"
		case Cowboy: return "Cowboy"
		case Spy: return "Spy"
		case Monster: return "Monster"
		case Banshee: return "Banshee"
		case Fella: return "Fella"
		case Balloon: return "Balloon"
		case Whale: return "Whale"
		case Swan: return "Swan"
		case Film: return "Film"
		case Individual: return "Individual"
		case Pyscho: return "Pyscho"
		case Violin: return "Violin"
		case Show: return "Show"
		case Kid: return "Kid"
		case Movie: return "Movie"
		}
	}
}

extension HGNoun: HGEncodable {

	static var new: HGNoun {
		return HGNoun.Boy
	}

	var encode: AnyObject {
		return self.int
	}

	static func decode(object object: AnyObject) -> HGNoun {
		if let int = object as? Int { return int.hGNoun }
		if let string = object as? String { return string.hGNoun }
		appDelegate.error.report("object \(object) is not |HGNoun| decodable, returning Boy", type: .Error)
		return HGNoun.new
	}
}
