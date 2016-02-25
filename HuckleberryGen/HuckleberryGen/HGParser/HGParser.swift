//
//  HGParser.swift
//  HuckleberryGen
//
//  Created by David Vallas on 8/27/15.
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


/// protocol that for a Huckleberry Gen parser that can parse files
protocol HGParser {
    func parse() // starts a new parse
    func resetParse()  // stops the current parse
}

/// protocol that defines a Huckleberry Gen parser that parses Import Files
protocol HGImportParser: HGParser {
    weak var delegate: HGImportParserDelegate? { get set }
}

/// protocol that defines a Huckleberry Gen parser delegate that parses Import Files and produces a project
protocol HGImportParserDelegate: AnyObject {
    func parserDidParse(importFile: ImportFile, success: Bool, project: Project)
}

/// Huckleberry Gen factory for the creation of different file parsers.  These parsers deconstruct specific types of files and turn the data into different project objects.
class HGParse {
    
    /// returns initialized HGImportParser that can be used to parse the file and create a project
    static func importParser(forImportFile importFile: ImportFile) -> HGImportParser? {
        switch importFile.type {
        case .XCODE_XML: return XCODE_XMLParser(importFile: importFile)
        }
    }
    
}