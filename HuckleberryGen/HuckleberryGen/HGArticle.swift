//   InfiniteUI
//   HGArticle created (on: 01-28-2016 for: David Vallas)
//
//   Copyright (c) 2016 Cisco  
//
//   All Rights Reserved.

import Foundation

enum HGArticle {

	case The
	case Any
	case One
	case That
	case Most
	case Some
	case AKindOf
	case TheLeast
	case AParticularly
	case AClearly
	case TheOriginal
	case AFairly
	case Another
	case Oh
	case ACompletely
	case OneCrazy
	case DefinatelyOne
	case BewareOfThe
	case AHistoryOfThe
	case AStoryAboutThe

	var int: Int {
		switch self {
		case The: return 0
		case Any: return 1
		case One: return 2
		case That: return 3
		case Most: return 4
		case Some: return 5
		case AKindOf: return 6
		case TheLeast: return 7
		case AParticularly: return 8
		case AClearly: return 9
		case TheOriginal: return 10
		case AFairly: return 11
		case Another: return 12
		case Oh: return 13
		case ACompletely: return 14
		case OneCrazy: return 15
		case DefinatelyOne: return 16
		case BewareOfThe: return 17
		case AHistoryOfThe: return 18
		case AStoryAboutThe: return 19
		}
	}

	var string: String {
		switch self {
		case The: return "The"
		case Any: return "Any"
		case One: return "One"
		case That: return "That"
		case Most: return "Most"
		case Some: return "Some"
		case AKindOf: return "A Kind of"
		case TheLeast: return "The Least"
		case AParticularly: return "A Particularly"
		case AClearly: return "A Clearly"
		case TheOriginal: return "The Original"
		case AFairly: return "A Fairly"
		case Another: return "Another"
		case Oh: return "Oh !!!@$#!%^&*(){}//,.';:!!!"
		case ACompletely: return "A Completely"
		case OneCrazy: return "One !Crazy!"
		case DefinatelyOne: return "Definately! One"
		case BewareOfThe: return "Beware of the"
		case AHistoryOfThe: return "A History of the"
		case AStoryAboutThe: return "A Story about the"
		}
	}
}

extension HGArticle: HGEncodable {

	static var new: HGArticle {
		return HGArticle.The
	}

	var encode: AnyObject {
		return self.int
	}

	static func decode(object object: AnyObject) -> HGArticle {
		if let int = object as? Int { return int.hGArticle }
		if let string = object as? String { return string.hGArticle }
		appDelegate.error.report("object \(object) is not |HGArticle| decodable, returning The", type: .Error)
		return HGArticle.new
	}
}
