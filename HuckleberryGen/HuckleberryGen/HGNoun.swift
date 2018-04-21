//
//  BoardHandler.swift
//  HuckleberryGen
//
//  Created by David Vallas on 7/16/15.
//  Copyright © 2015 Phoenix Labs.
//
//  All Rights Reserved.

import Foundation

enum HGNoun {

	case boy
	case girl
	case man
	case woman
	case dancer
	case cowboy
	case spy
	case monster
	case banshee
	case fella
	case balloon
	case whale
	case swan
	case film
	case individual
	case pyscho
	case violin
	case show
	case kid
	case movie

	var int: Int {
		switch self {
		case .boy: return 0
		case .girl: return 1
		case .man: return 2
		case .woman: return 3
		case .dancer: return 4
		case .cowboy: return 5
		case .spy: return 6
		case .monster: return 7
		case .banshee: return 8
		case .fella: return 9
		case .balloon: return 10
		case .whale: return 11
		case .swan: return 12
		case .film: return 13
		case .individual: return 14
		case .pyscho: return 15
		case .violin: return 16
		case .show: return 17
		case .kid: return 18
		case .movie: return 19
		}
	}

	var string: String {
		switch self {
		case .boy: return "Boy"
		case .girl: return "Girl"
		case .man: return "Man"
		case .woman: return "Woman"
		case .dancer: return "Dancer"
		case .cowboy: return "Cowboy"
		case .spy: return "Spy"
		case .monster: return "Monster"
		case .banshee: return "Banshee"
		case .fella: return "Fella"
		case .balloon: return "Balloon"
		case .whale: return "Whale"
		case .swan: return "Swan"
		case .film: return "Film"
		case .individual: return "Individual"
		case .pyscho: return "Pyscho"
		case .violin: return "Violin"
		case .show: return "Show"
		case .kid: return "Kid"
		case .movie: return "Movie"
		}
	}
}

extension HGNoun: HGEncodable {

	static var new: HGNoun {
		return HGNoun.boy
	}

	var encode: AnyObject {
		return self.int as AnyObject
	}

	static func decode(object: AnyObject) -> HGNoun {
		if let int = object as? Int { return int.hGNoun }
		if let string = object as? String { return string.hGNoun }
		HGReportHandler.shared.report("object \(object) is not |HGNoun| decodable, returning Boy", type: .error)
		return HGNoun.new
	}
}
