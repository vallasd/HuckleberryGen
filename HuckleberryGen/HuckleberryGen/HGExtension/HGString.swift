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
		case "Info": return .info 
		case "Warn": return .warn 
		case "Error": return .error 
		case "Alert": return .alert 
		case "Assert": return .assert 
		default:
			HGReportHandler.shared.report("int: |\(self)| is not enum |HGErrorType| mapable, using Info", type: .error)
		}
		return .info
	}
	/// returns HGArticles.  Logs error and returns The if not a valid Int.
	var hGArticle: HGArticle {
 		switch self {
		case "The": return .the 
		case "Any": return .any 
		case "One": return .one 
		case "That": return .that 
		case "Most": return .most 
		case "Some": return .some 
		case "A Kind of": return .aKindOf 
		case "The Least": return .theLeast 
		case "A Particularly": return .aParticularly 
		case "A Clearly": return .aClearly 
		case "The Original": return .theOriginal 
		case "A Fairly": return .aFairly 
		case "Another": return .another 
		case "Oh !!!@$#!%^&*(){}//,.';:!!!": return .oh
		case "A Completely": return .aCompletely 
		case "One !Crazy!": return .oneCrazy 
		case "Definately! One": return .definatelyOne 
		case "Beware of the": return .bewareOfThe 
		case "A History of the": return .aHistoryOfThe 
		case "A Story about the": return .aStoryAboutThe 
		default:
			HGReportHandler.shared.report("int: |\(self)| is not enum |HGArticle| mapable, using The", type: .error)
		}
		return .the
	}
	/// returns HGAdjectives.  Logs error and returns Exceptional if not a valid Int.
	var hGAdjective: HGAdjective {
 		switch self {
		case "Exceptional": return .exceptional 
		case "Great": return .great 
		case "Good": return .good 
		case "Ugly": return .ugly 
		case "Timid": return .timid 
		case "Fantastic": return .fantastic 
		case "Humble": return .humble 
		case "Lost": return .lost 
		case "Petulant": return .petulant 
		case "Irksome": return .irksome 
		case "Zealous": return .zealous 
		case "Wretched": return .wretched 
		case "Curious": return .curious 
		case "Naive": return .naive 
		case "Wicked": return .wicked 
		case "Poor": return .poor 
		case "Fantastic": return .fantastic 
		case "Futuristic": return .futuristic 
		case "Crappy": return .crappy 
		case "Excellent": return .excellent 
		default:
			HGReportHandler.shared.report("int: |\(self)| is not enum |HGAdjective| mapable, using Exceptional", type: .error)
		}
		return .exceptional
	}
	/// returns HGNouns.  Logs error and returns Boy if not a valid Int.
	var hGNoun: HGNoun {
 		switch self {
		case "Boy": return .boy 
		case "Girl": return .girl 
		case "Man": return .man 
		case "Woman": return .woman 
		case "Dancer": return .dancer 
		case "Cowboy": return .cowboy 
		case "Spy": return .spy 
		case "Monster": return .monster 
		case "Banshee": return .banshee 
		case "Fella": return .fella 
		case "Balloon": return .balloon 
		case "Whale": return .whale 
		case "Swan": return .swan 
		case "Film": return .film 
		case "Individual": return .individual 
		case "Pyscho": return .pyscho 
		case "Violin": return .violin 
		case "Show": return .show 
		case "Kid": return .kid 
		case "Movie": return .movie 
		default:
			HGReportHandler.shared.report("int: |\(self)| is not enum |HGNoun| mapable, using Boy", type: .error)
		}
		return .boy
	}
}
