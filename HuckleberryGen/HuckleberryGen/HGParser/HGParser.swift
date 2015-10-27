//
//  HGParser.swift
//  HuckleberryGen
//
//  Created by David Vallas on 8/27/15.
//  Copyright © 2015 Phoenix Labs. All rights reserved.
//

import Foundation

protocol HGParserDelegate: AnyObject {
    func parserDidParseImportFile(importFile: ImportFile, success: Bool, model: HGModel)
}

protocol HGImportParser {
    weak var delegate: HGParserDelegate? { get set }
    func parse()
    func resetParse()  // Stops Parsing in its tracks
}

class HGParser {
    
    
    static func parserForImportFile(importFile: ImportFile) -> HGImportParser? {
        switch importFile.type {
        case .XCODE_XML: return XCODE_XMLParser(importFile: importFile)
        }
    }
    
    
}