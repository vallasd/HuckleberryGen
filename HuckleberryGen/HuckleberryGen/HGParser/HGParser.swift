//
//  HGParser.swift
//  HuckleberryGen
//
//  Created by David Vallas on 8/27/15.
//  Copyright © 2015 Phoenix Labs. All rights reserved.
//

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
    func parserDidParse(importFile: ImportFile, success: Bool, model: HGModel)
}

/// Huckleberry Gen factory for the creation of different file parsers.  These parsers deconstruct specific types of files and turn the data into different model objects.
class HGParse {
    
    /// returns initialized HGImportParser that can be used to parse the file and create a project
    static func importParser(forImportFile importFile: ImportFile) -> HGImportParser? {
        switch importFile.type {
        case .XCODE_XML: return XCODE_XMLParser(importFile: importFile)
        }
    }
    
}