//   InfiniteUI
//   HGString created (on: 01-28-2016 for: David Vallas)
//
//   Copyright (c) 2016 Cisco  
//
//   All Rights Reserved.

import Foundation

// MARK: Enums
extension String {

	/// returns HGErrorTypes.  Logs error and returns Info if not a valid Int.
	var hGErrorType: HGErrorType {
 		switch self {
		case "Info": return .Info 
		case "Warn": return .Warn 
		case "Error": return .Error 
		case "Alert": return .Alert 
		case "Assert": return .Assert 
		default:
			HGReportHandler.shared.report("int: |\(self)| is not enum |HGErrorType| mapable, using Info", type: .Error)
		}
		return .Info
	}
	/// returns HGArticles.  Logs error and returns The if not a valid Int.
	var hGArticle: HGArticle {
 		switch self {
		case "The": return .The 
		case "Any": return .Any 
		case "One": return .One 
		case "That": return .That 
		case "Most": return .Most 
		case "Some": return .Some 
		case "A Kind of": return .AKindOf 
		case "The Least": return .TheLeast 
		case "A Particularly": return .AParticularly 
		case "A Clearly": return .AClearly 
		case "The Original": return .TheOriginal 
		case "A Fairly": return .AFairly 
		case "Another": return .Another 
		case "Oh !!!@$#!%^&*(){}//,.';:!!!": return .Oh
		case "A Completely": return .ACompletely 
		case "One !Crazy!": return .OneCrazy 
		case "Definately! One": return .DefinatelyOne 
		case "Beware of the": return .BewareOfThe 
		case "A History of the": return .AHistoryOfThe 
		case "A Story about the": return .AStoryAboutThe 
		default:
			HGReportHandler.shared.report("int: |\(self)| is not enum |HGArticle| mapable, using The", type: .Error)
		}
		return .The
	}
	/// returns HGAdjectives.  Logs error and returns Exceptional if not a valid Int.
	var hGAdjective: HGAdjective {
 		switch self {
		case "Exceptional": return .Exceptional 
		case "Great": return .Great 
		case "Good": return .Good 
		case "Ugly": return .Ugly 
		case "Timid": return .Timid 
		case "Fantastic": return .Fantastic 
		case "Humble": return .Humble 
		case "Lost": return .Lost 
		case "Petulant": return .Petulant 
		case "Irksome": return .Irksome 
		case "Zealous": return .Zealous 
		case "Wretched": return .Wretched 
		case "Curious": return .Curious 
		case "Naive": return .Naive 
		case "Wicked": return .Wicked 
		case "Poor": return .Poor 
		case "Fantastic": return .Fantastic 
		case "Futuristic": return .Futuristic 
		case "Crappy": return .Crappy 
		case "Excellent": return .Excellent 
		default:
			HGReportHandler.shared.report("int: |\(self)| is not enum |HGAdjective| mapable, using Exceptional", type: .Error)
		}
		return .Exceptional
	}
	/// returns HGNouns.  Logs error and returns Boy if not a valid Int.
	var hGNoun: HGNoun {
 		switch self {
		case "Boy": return .Boy 
		case "Girl": return .Girl 
		case "Man": return .Man 
		case "Woman": return .Woman 
		case "Dancer": return .Dancer 
		case "Cowboy": return .Cowboy 
		case "Spy": return .Spy 
		case "Monster": return .Monster 
		case "Banshee": return .Banshee 
		case "Fella": return .Fella 
		case "Balloon": return .Balloon 
		case "Whale": return .Whale 
		case "Swan": return .Swan 
		case "Film": return .Film 
		case "Individual": return .Individual 
		case "Pyscho": return .Pyscho 
		case "Violin": return .Violin 
		case "Show": return .Show 
		case "Kid": return .Kid 
		case "Movie": return .Movie 
		default:
			HGReportHandler.shared.report("int: |\(self)| is not enum |HGNoun| mapable, using Boy", type: .Error)
		}
		return .Boy
	}
}
