//
//  XCODE_XMLParser.swift
//  HuckleberryGen
//
//  Created by David Vallas on 8/27/15.
//  Copyright © 2015 Phoenix Labs. All rights reserved.
//

import Foundation

/// Turns XCODE XML from a CoreData model into a Huckleberry Gen project
class XCODE_XMLParser: NSObject, NSXMLParserDelegate, HGImportParser {

    private var xml: ImportFile
    private var xmlParser: NSXMLParser = NSXMLParser()
    private var lastEntity: Entity? = nil
    private var entities: Set<Entity> = []
    private var didError: Bool = false
    
    // MARK: Initialization
    
    init(importFile: ImportFile) {
        xml = importFile
    }
    
    // MARK: HGImportParser
    
    weak var delegate: HGImportParserDelegate? = nil
    
    func parse() {
        if let parser = NSXMLParser(contentsOfURL: NSURL(fileURLWithPath: xml.path)) {
            xmlParser = parser
            xmlParser.delegate = self
            let success = xmlParser.parse()
            if success { return }
        }
        
        didError = true
        parseErrorFile(xml)
        callDelegate()
    }
    
    func resetParse() {
        xmlParser.abortParsing()
        xmlParser.delegate = nil
        lastEntity = nil
        didError = false
        entities = []
    }
    
    // MARK: NSXMLParserDelegate
    
    func parserDidStartDocument(parser: NSXMLParser) {
        print("Started Parsing XCODE XML For \(xml.name)")
    }
    
    func parserDidEndDocument(parser: NSXMLParser) {
        if lastEntity != nil { entities.insert(lastEntity!) } // Add the final entity
        print("Completed Parsing XCODE XML For \(xml.name)")
        callDelegate()
    }
    
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        
        if elementName == ParseType.Entity.rawValue {
            
            let typeRep = attributeDict["name"]!
            if lastEntity != nil { entities.insert(lastEntity!) }
            lastEntity = Entity(typeRep: typeRep)
            return
        }
        
        if elementName == ParseType.Attribute.rawValue {
            
            if lastEntity != nil {
                let primitive = attributeDict["attributeType"].primitive
                let varRep = attributeDict["name"].string
                let attribute = Attribute(varRep: varRep, primitive: primitive)
                lastEntity!.attributes.append(attribute)
                return
            }
            
            didError = true
            parseErrorMissing(attributeDict["name"]!, type: ParseType.Attribute)
        }
        
        if elementName == ParseType.Relationship.rawValue {
            
            if lastEntity != nil {
                
                let type = attributeDict["toMany"]
                
                // This app assumes too one relationship inverses are too many.  If you need a one to one relationship, use a struct
                // nil means a too one relationship, we add the entity hash for these.
                if type == nil {
                    
                    // get destination entity
                    let typeRep = attributeDict["destinationEntity"].string
                    let hash = HashObject(typeRep: typeRep.typeRepresentable, varRep: typeRep.varRepresentable, isEntity: true)
                    lastEntity!.entityHashes.append(hash)
                }
                
                return
            }
            
            didError = true
            parseErrorMissing(attributeDict["name"]!, type: ParseType.Relationship)
        }
    }
    
    // MARK: Private Methods
    
    private func callDelegate() {
        let project = Project.new
        project.entities = project.entities + entities
        delegate?.parserDidParse(xml, success: !didError, project: project)
    }
    
    private func createStructsFromEntities() {
        
        // any one to one relationship will use an optional struct as the reference
        
        
    }
    
    private enum ParseType: String {
        case Entity = "entity"
        case Attribute = "attribute"
        case Relationship = "relationship"
    }
    
    private func parseErrorMissing(name: String, type: ParseType) {
        HGReportHandler.shared.report("HGParseError Error: Missing \(type.rawValue): \(name)" , type: .Error)
    }
    
    private func parseErrorFile(xml: ImportFile) {
        do {
            let _ = try String(contentsOfFile: xml.path, encoding: NSUTF8StringEncoding)
            HGReportHandler.shared.report("HGParse Error: can not parse at path: |\(xml.path)| error: \(xmlParser.parserError?.description)", type: .Error)
        }
        catch {
            HGReportHandler.shared.report("HGParse Error: can not parse file at path: |\(xml.path)| can not be parsed", type: .Error)
        }
    }
    
    
    
}