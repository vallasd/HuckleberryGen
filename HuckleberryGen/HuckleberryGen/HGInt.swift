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
		case 0: return .info 
		case 1: return .warn 
		case 2: return .error 
		case 3: return .alert 
		case 4: return .assert 
		default:
			HGReportHandler.shared.report("int: |\(self)| is not enum |HGErrorType| mapable, using Info", type: .error)
		}
		return .info
	}
	/// returns HGArticles.  Logs error and returns The if not a valid Int.
	var hGArticle: HGArticle {
 		switch self {
		case 0: return .the 
		case 1: return .any 
		case 2: return .one 
		case 3: return .that 
		case 4: return .most 
		case 5: return .some 
		case 6: return .aKindOf 
		case 7: return .theLeast 
		case 8: return .aParticularly 
		case 9: return .aClearly 
		case 10: return .theOriginal 
		case 11: return .aFairly 
		case 12: return .another 
		case 13: return .oh 
		case 14: return .aCompletely 
		case 15: return .oneCrazy 
		case 16: return .definatelyOne 
		case 17: return .bewareOfThe 
		case 18: return .aHistoryOfThe 
		case 19: return .aStoryAboutThe 
		default:
			HGReportHandler.shared.report("int: |\(self)| is not enum |HGArticle| mapable, using The", type: .error)
		}
		return .the
	}
	/// returns HGAdjectives.  Logs error and returns Exceptional if not a valid Int.
	var hGAdjective: HGAdjective {
 		switch self {
		case 0: return .exceptional 
		case 1: return .great 
		case 2: return .good 
		case 3: return .ugly 
		case 4: return .timid 
		case 5: return .fantastic 
		case 6: return .humble 
		case 7: return .lost 
		case 8: return .petulant 
		case 9: return .irksome 
		case 10: return .zealous 
		case 11: return .wretched 
		case 12: return .curious 
		case 13: return .naive 
		case 14: return .wicked 
		case 15: return .poor 
		case 16: return .fantastic 
		case 17: return .futuristic 
		case 18: return .crappy 
		case 19: return .excellent 
		default:
			HGReportHandler.shared.report("int: |\(self)| is not enum |HGAdjective| mapable, using Exceptional", type: .error)
		}
		return .exceptional
	}
	/// returns HGNouns.  Logs error and returns Boy if not a valid Int.
	var hGNoun: HGNoun {
 		switch self {
		case 0: return .boy 
		case 1: return .girl 
		case 2: return .man 
		case 3: return .woman 
		case 4: return .dancer 
		case 5: return .cowboy 
		case 6: return .spy 
		case 7: return .monster 
		case 8: return .banshee 
		case 9: return .fella 
		case 10: return .balloon 
		case 11: return .whale 
		case 12: return .swan 
		case 13: return .film 
		case 14: return .individual 
		case 15: return .pyscho 
		case 16: return .violin 
		case 17: return .show 
		case 18: return .kid 
		case 19: return .movie 
		default:
			HGReportHandler.shared.report("int: |\(self)| is not enum |HGNoun| mapable, using Boy", type: .error)
		}
		return .boy
	}
}
