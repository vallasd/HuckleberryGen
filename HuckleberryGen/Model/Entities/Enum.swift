//
//  Enum.swift
//  HuckleberryGen
//
//  Created by David Vallas on 8/19/15.
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


import Cocoa

struct Enum: TypeRepresentable {
    
    var name: String { didSet { typeRep = name.typeRepresentable } }
    var typeRep: String
    var editable: Bool
    var cases: [EnumCase]
    
    
    init(editable: Bool, name: String, cases: [EnumCase]) {
        self.editable = editable
        self.name = name
        self.cases = cases
        self.typeRep = name.typeRepresentable
    }
    
    static func image(withName name: String) -> NSImage {
        return NSImage.image(named: "enumIcon", title: name)
    }
}

extension Enum: HGEncodable {
    
    static var new: Enum {
        return Enum(editable: true, name: "New Enum", cases: [EnumCase.new])
    }
    
    var encode: AnyObject {
        var dict = HGDICT()
        dict["editable"] = editable as AnyObject
        dict["name"] = name as AnyObject
        dict["cases"] = cases.encode as AnyObject
        return dict as AnyObject
    }
    
    static func decode(object: AnyObject) -> Enum {
        let dict = hgdict(fromObject: object, decoderName: "Enum")
        let editable = dict["editable"].bool
        let name = dict["name"].string
        let cases = dict["cases"].enumcases
        return Enum(editable: editable, name: name, cases: cases)
    }
}

extension Enum: VarRepresentable {
    
    var varRep: String { return name.varRepresentable }
}

extension Enum: DefaultRepresentable {
    
    var defaultRep: String { return cases.count > 0 ? cases.first!.typeRep : "Missing Cases!!!" }
}

extension Enum {
    
    static func genericEnums() -> [Enum] {
        
        var generics: [Enum] = []
        
        // generics are not editable
        let editable = false
        
        // create HGErrorType
        let error = "HGErrorType"
        let error1 = EnumCase(string: "Info")
        let error2 = EnumCase(string: "Warn")
        let error3 = EnumCase(string: "Error")
        let error4 = EnumCase(string: "Alert")
        let error5 = EnumCase(string: "Assert")
        let enum1 = Enum(editable: editable, name: error, cases: [error1, error2, error3, error4, error5])
        generics.append(enum1)
        
        // create HGErrorType
        let artic = "HGArticle"
        let artic1 = EnumCase(string: "The")
        let artic2 = EnumCase(string: "Any")
        let artic3 = EnumCase(string: "One")
        let artic4 = EnumCase(string: "That")
        let artic5 = EnumCase(string: "Most")
        let artic6 = EnumCase(string: "Some")
        let artic7 = EnumCase(string: "A Kind of")
        let artic8 = EnumCase(string: "The Least")
        let artic9 = EnumCase(string: "A Particularly")
        let artic10 = EnumCase(string: "A Clearly")
        let artic11 = EnumCase(string: "The Original")
        let artic12 = EnumCase(string: "A Fairly")
        let artic13 = EnumCase(string: "Another")
        let artic14 = EnumCase(string: "Oh !!!@$#!%^&\\*(){}//,.';:!!!")
        let artic15 = EnumCase(string: "A Completely")
        let artic16 = EnumCase(string: "One !Crazy!")
        let artic17 = EnumCase(string: "Definately! One")
        let artic18 = EnumCase(string: "Beware of the")
        let artic19 = EnumCase(string: "A History of the")
        let artic20 = EnumCase(string: "A Story about the")
        let artics = [artic1, artic2, artic3, artic4, artic5, artic6, artic7, artic8, artic9, artic10, artic11, artic12, artic13, artic14, artic15, artic16, artic17, artic18, artic19, artic20]
        let enum2 = Enum(editable: editable, name: artic, cases: artics)
        generics.append(enum2)
        
        // create HGErrorType
        let adjec = "HGAdjective"
        let adjec1 = EnumCase(string: "Exceptional")
        let adjec2 = EnumCase(string: "Great")
        let adjec3 = EnumCase(string: "Good")
        let adjec4 = EnumCase(string: "Ugly")
        let adjec5 = EnumCase(string: "Timid")
        let adjec6 = EnumCase(string: "Fantastic")
        let adjec7 = EnumCase(string: "Humble")
        let adjec8 = EnumCase(string: "Lost")
        let adjec9 = EnumCase(string: "Petulant")
        let adjec10 = EnumCase(string: "Irksome")
        let adjec11 = EnumCase(string: "Zealous")
        let adjec12 = EnumCase(string: "Wretched")
        let adjec13 = EnumCase(string: "Curious")
        let adjec14 = EnumCase(string: "Naive")
        let adjec15 = EnumCase(string: "Wicked")
        let adjec16 = EnumCase(string: "Poor")
        let adjec17 = EnumCase(string: "Fantastic")
        let adjec18 = EnumCase(string: "Futuristic")
        let adjec19 = EnumCase(string: "Crappy")
        let adjec20 = EnumCase(string: "Excellent")
        let adjecs = [adjec1, adjec2, adjec3, adjec4, adjec5, adjec6, adjec7, adjec8, adjec9, adjec10, adjec11, adjec12, adjec13, adjec14, adjec15, adjec16, adjec17, adjec18, adjec19, adjec20]
        let enum3 = Enum(editable: editable, name: adjec, cases: adjecs)
        generics.append(enum3)
        
        // create HGErrorType
        let noun = "HGNoun"
        let noun1 = EnumCase(string: "Boy")
        let noun2 = EnumCase(string: "Girl")
        let noun3 = EnumCase(string: "Man")
        let noun4 = EnumCase(string: "Woman")
        let noun5 = EnumCase(string: "Dancer")
        let noun6 = EnumCase(string: "Cowboy")
        let noun7 = EnumCase(string: "Spy")
        let noun8 = EnumCase(string: "Monster")
        let noun9 = EnumCase(string: "Banshee")
        let noun10 = EnumCase(string: "Fella")
        let noun11 = EnumCase(string: "Balloon")
        let noun12 = EnumCase(string: "Whale")
        let noun13 = EnumCase(string: "Swan")
        let noun14 = EnumCase(string: "Film")
        let noun15 = EnumCase(string: "Individual")
        let noun16 = EnumCase(string: "Pyscho")
        let noun17 = EnumCase(string: "Violin")
        let noun18 = EnumCase(string: "Show")
        let noun19 = EnumCase(string: "Kid")
        let noun20 = EnumCase(string: "Movie")
        let nouns = [noun1, noun2, noun3, noun4, noun5, noun6, noun7, noun8, noun9, noun10, noun11, noun12, noun13, noun14, noun15, noun16, noun17, noun18, noun19, noun20]
        let enum4 = Enum(editable: editable, name: noun, cases: nouns)
        generics.append(enum4)
        
        // return enums
        return generics
    }
}

extension Enum: Hashable { var hashValue: Int { return name.hashValue } }
extension Enum: Equatable {}; func ==(lhs: Enum, rhs: Enum) -> Bool { return lhs.name == rhs.name }
