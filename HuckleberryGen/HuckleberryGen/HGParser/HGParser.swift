//
//  HGParser.swift
//  HuckleberryGen
//
//  Created by David Vallas on 8/27/15.
//  Copyright © 2015 Phoenix Labs.
//
//  All Rights Reserved.

import Foundation


/// protocol that for a Huckleberry Gen parser that can parse files
protocol HGParser {
    func parse() // starts a new parse
    func resetParse()  // stops the current parse
}

/// protocol that defines a Huckleberry Gen parser that parses Import Files
protocol HGImportParser: HGParser {
    var delegate: HGImportParserDelegate? { get set }
}

/// protocol that defines a Huckleberry Gen parser delegate that parses Import Files and produces a project
protocol HGImportParserDelegate: AnyObject {
    func parserDidParse(_ importFile: ImportFile, success: Bool, project: Project)
}

/// Huckleberry Gen factory for the creation of different file parsers.  These parsers deconstruct specific types of files and turn the data into different project objects.
class HGParse {
    
    /// returns initialized HGImportParser that can be used to parse the file and create a project
    static func importParser(forImportFile importFile: ImportFile) -> HGImportParser? {
        switch importFile.type {
        case .xcode_XML: return XCODE_XMLParser(importFile: importFile)
        }
    }
    
}
