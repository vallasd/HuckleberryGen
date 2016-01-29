//   InfiniteUI
//   HGInt created (on: 01-28-2016 for: David Vallas)
//
//   Copyright (c) 2016 Cisco  
//
//   All Rights Reserved.

import Foundation

// MARK: Enums
extension Int {

	/// returns HGErrorTypes.  Logs error and returns Info if not a valid Int.
	var hGErrorType: HGErrorType {
 		switch self {
		case 0: return .Info 
		case 1: return .Warn 
		case 2: return .Error 
		case 3: return .Alert 
		case 4: return .Assert 
		default:
			appDelegate.error.report("int: |\(self)| is not enum |HGErrorType| mapable, using Info", type: .Error)
		}
		return .Info
	}
	/// returns HGArticles.  Logs error and returns The if not a valid Int.
	var hGArticle: HGArticle {
 		switch self {
		case 0: return .The 
		case 1: return .Any 
		case 2: return .One 
		case 3: return .That 
		case 4: return .Most 
		case 5: return .Some 
		case 6: return .AKindOf 
		case 7: return .TheLeast 
		case 8: return .AParticularly 
		case 9: return .AClearly 
		case 10: return .TheOriginal 
		case 11: return .AFairly 
		case 12: return .Another 
		case 13: return .Oh 
		case 14: return .ACompletely 
		case 15: return .OneCrazy 
		case 16: return .DefinatelyOne 
		case 17: return .BewareOfThe 
		case 18: return .AHistoryOfThe 
		case 19: return .AStoryAboutThe 
		default:
			appDelegate.error.report("int: |\(self)| is not enum |HGArticle| mapable, using The", type: .Error)
		}
		return .The
	}
	/// returns HGAdjectives.  Logs error and returns Exceptional if not a valid Int.
	var hGAdjective: HGAdjective {
 		switch self {
		case 0: return .Exceptional 
		case 1: return .Great 
		case 2: return .Good 
		case 3: return .Ugly 
		case 4: return .Timid 
		case 5: return .Fantastic 
		case 6: return .Humble 
		case 7: return .Lost 
		case 8: return .Petulant 
		case 9: return .Irksome 
		case 10: return .Zealous 
		case 11: return .Wretched 
		case 12: return .Curious 
		case 13: return .Naive 
		case 14: return .Wicked 
		case 15: return .Poor 
		case 16: return .Fantastic 
		case 17: return .Futuristic 
		case 18: return .Crappy 
		case 19: return .Excellent 
		default:
			appDelegate.error.report("int: |\(self)| is not enum |HGAdjective| mapable, using Exceptional", type: .Error)
		}
		return .Exceptional
	}
	/// returns HGNouns.  Logs error and returns Boy if not a valid Int.
	var hGNoun: HGNoun {
 		switch self {
		case 0: return .Boy 
		case 1: return .Girl 
		case 2: return .Man 
		case 3: return .Woman 
		case 4: return .Dancer 
		case 5: return .Cowboy 
		case 6: return .Spy 
		case 7: return .Monster 
		case 8: return .Banshee 
		case 9: return .Fella 
		case 10: return .Balloon 
		case 11: return .Whale 
		case 12: return .Swan 
		case 13: return .Film 
		case 14: return .Individual 
		case 15: return .Pyscho 
		case 16: return .Violin 
		case 17: return .Show 
		case 18: return .Kid 
		case 19: return .Movie 
		default:
			appDelegate.error.report("int: |\(self)| is not enum |HGNoun| mapable, using Boy", type: .Error)
		}
		return .Boy
	}
}
