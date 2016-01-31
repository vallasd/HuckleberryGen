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
            lastEntity = Entity(typeRep: typeRep, attributes: [], relationships: [], hashes: [])
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
                // get desitionation entity
                let dEntity = attributeDict["destinationEntity"].string
                
                // check if its currently in the set
                let eEntity = entities.filter { $0.typeRep == dEntity }
                
                // get the entity or create it
                let entity = eEntity.count > 0 ? eEntity[0] : Entity(typeRep: dEntity, attributes: [], relationships: [], hashes: [])
                
                // if entity was created, add it to set
                if eEntity.count == 0 { entities.insert(entity) }
                
                // get rest of attribute data and set it
                let type = attributeDict["toMany"].relationshipType
                let deletionRule = attributeDict["deletionRule"].deletionRule
                let relationship = Relationship(tag: 0, entity: entity, type: type, deletionRule: deletionRule)
                lastEntity!.relationships.append(relationship)
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