//
//  ExportOptional.swift
//  HuckleberryGen
//
//  Created by David Vallas on 1/22/16.
//  Copyright © 2016 Phoenix Labs.
//
//  All Rights Reserved.

import Foundation

class ExportOptional {
    
    let path: String
    let licenseInfo: LicenseInfo
    let entities: [String]
    let enums: [String]
    
    /// initializes the class with a baseDir and entity
    init(baseDir: String, licenseInfo: LicenseInfo, entityNames: [String], enumNames: [String]) {
        path = baseDir
        self.licenseInfo = licenseInfo
        entities = entityNames
        enums = enumNames
    }
    
    /// creates an entity file for the given Entity.  Returns false if error.
    func exportFile() -> Bool {
        
        // Setting Default Names
        let name = "Optional"
        let filePath = path + "/\(name).swift"
        let store = appDelegate.store
        let header = licenseInfo.string(store.project.name, fileName: name)
        let primitiveExtension = primitiveDefinitions()
        let entityExtension = entityDefinitions()
        let enumExtension = enumDefinitions()
       
        // Create String File that will be written
        let file = header + "\n" + primitiveExtension + "\n" + entityExtension + "\n" + enumExtension
        
        // write to file, if there is an error, return false
        do {
        try file.write(toFile: filePath, atomically: true, encoding: String.Encoding.utf8)
        } catch {
        return false
        }
        
        return true
    }
    
    fileprivate func returnOptionalIfNil(withInitialIndent iInd: String) -> String {
        
        // get indent
        let ind = HGIndent.indent
        
        // return string
        var string = ""
        string += "\(iInd)if self == nil {\n"
        string += "\(iInd)\(ind)return nil\n"
        string += "\(iInd)}\n"
        return string
    }
    
    fileprivate func returnDefaultIfNilWithOptionalError(_ name: String, variable: String, iInd: String) -> String {
        
        // get indent
        let ind = HGIndent.indent
        
        // return string
        var string = ""
        string += "\(iInd)if self == nil {\n"
        string += "\(iInd)\(ind)if logErrorForNil {\n"
        string += "\(iInd)\(ind)\(ind)HGReport.shared.report(\"optional: \(name) returned nil value, using \\(\(variable))\", type: .Error)\n"
        string += "\(iInd)\(ind)}\n"
        string += "\(iInd)\(ind)return \(variable)\n"
        string += "\(iInd)}\n"
        return string
    }
    
    // creates an error return statement for a variable value.
    fileprivate func errorReturnStatement(_ name: String, variable: String, iInd: String) -> String  {
        
        // return string
        var string = ""
        string += "\(iInd)HGReport.shared.report(\"optional: |\\(self)| is not \(name) mapable, using \\(\(variable))\", type: .Error)\n"
        string += "\(iInd)return \(variable)\n"
        return string
    }
    
    // creates an error return statement for a string value.
    fileprivate func errorReturnStatement(_ name: String, stringValue: String, iInd: String) -> String  {
        
        // return string
        let literalString = stringValue.removeQuotes
        var string = ""
        string += "\(iInd)HGReport.shared.report(\"optional: |\\(self)| is not \(name) mapable, using \(literalString)\", type: .Error)\n"
        string += "\(iInd)return \(stringValue)\n"
        return string
    }
    
    // creates an error return statement for an array.
    fileprivate func errorReturnArrayStatement(_ name: String, iInd: String) -> String  {
        
        // return string
        var string = ""
        string += "\(iInd)HGReport.shared.report(\"optional is not [\(name)] mapable, using [] - optional: |\\(self)|\", type: .Error)\n"
        string += "\(iInd)return []\n"
        return string
    }
    
    fileprivate func returnArrayStatement(_ name: String, iInd: String) -> String {
        
        // get indent
        let ind = HGIndent.indent
        
        // return string
        var string = ""
        string += "\(iInd)if let \(name.lowerFirstLetterAndArray) = self as? [\(name)] {\n"
        string += "\(iInd)\(ind)return \(name.lowerFirstLetterAndArray)\n"
        string += "\(iInd)}\n"
        return string
    }
    
    fileprivate func returnHGDICTStatement(_ entityName: String, iInd: String) -> String {
        
        // get indent
        let ind = HGIndent.indent
        
        // return string
        var string = ""
        string += "\(iInd)if let dict = self as? HGDICT {\n"
        string += "\(iInd)\(ind)return \(entityName).decode(object: dict)\n"
        string += "\(iInd)}\n"
        return string
    }
    
    fileprivate func returnHGARRAYStatement(_ entityName: String, iInd: String) -> String {
        
        // get indent
        let ind = HGIndent.indent
        
        // return string
        var string = ""
        string += "\(iInd)if let array = self as? HGARRAY {\n"
        string += "\(iInd)\(ind)return \(entityName).decodeArray(objects: array)\n"
        string += "\(iInd)}\n"
        return string
    }
    
    fileprivate func returnIntStatement(_ name: String, iInd: String) -> String {
        
        // get indent
        let ind = HGIndent.indent
        
        // return string
        var string = ""
        string += "\(iInd)if let int = self as? Int {\n"
        string += "\(iInd)\(ind)return int.\(name.lowerFirstLetter)\n"
        string += "\(iInd)}\n"
        return string
    }
    
    fileprivate func returnStringStatement(_ name: String, iInd: String) -> String {
        
        // get indent
        let ind = HGIndent.indent
        
        // return string
        var string = ""
        string += "\(iInd)if let string = self as? String {\n"
        string += "\(iInd)\(ind)return string.\(name.lowerFirstLetter)\n"
        string += "\(iInd)}\n"
        return string
    }
    
    fileprivate func returnIntArrayStatement(_ name: String, iInd: String) -> String {
        
        // get indent
        let ind = HGIndent.indent
        
        // return string
        var string = ""
        string += "\(iInd)if let int = self as? Int {\n"
        string += "\(iInd)\(ind)return int.\(name.lowerFirstLetter)\n"
        string += "\(iInd)}\n"
        return string
    }
    
    /// creates return statements that attempt to unwrap and return the object if it exists
    fileprivate func returnStatement(_ name: String, iInd: String) -> String {
        
        // get indent
        let ind = HGIndent.indent
        
        // default return
        var string = ""
        string += "\(iInd)if let \(name.lowerFirstLetter) = self as? \(name) {\n"
        string += "\(iInd)\(ind)return \(name.lowerFirstLetter)\n"
        string += "\(iInd)}\n"
        
        return string
    }
    
    /// creates optional definitions for standard Swift types
    fileprivate func primitiveDefinitions() -> String {
        
        // get indent
        let ind = HGIndent.indent
        let ind2 = HGIndent.indent(2)
        
        // begin primitive optional extension
        var string = "// MARK: Standard Swift Types\n"
        string += "extension Optional {\n\n"
        
        // define primitives
        let primitives = Primitive.array
        
        var index = 0
        for prim in primitives {
            
            // string representation of primitive
            let type = prim.name
            let varRep = prim.name.varRepresentable
            
            // string representation of primitive's default value
            let pDefault = prim.defaultRep
            
            // create var that expects an unwrapped existing object or logs an Error and returns a system default
            string += "\(ind)/// returns \(type) if optional unwraps.  Logs error and returns \(pDefault) if object is nil or can not unwrap.\n"
            string += "\(ind)var \(varRep): \(type) {\n"
            string += returnStatement(type, iInd: ind2)
            string += prim.optionalReturnStatement(withInitialIndent: ind2)
            string += errorReturnStatement(type, stringValue: pDefault, iInd: ind2)
            string += "\(ind)}\n\n"
            
            // create var that expects an unwrapped existing object or logs an Error and returns a system default
            string += "\(ind)/// returns \(type) if optional unwraps.  Logs error and returns nil if object can not unwrap.  Returns nil (without Error) on nil objects.\n"
            string += "\(ind)var \(varRep)Nillable: \(type)? {\n"
            string += returnOptionalIfNil(withInitialIndent: ind2)
            string += returnStatement(type, iInd: ind2)
            string += prim.optionalReturnStatement(withInitialIndent: ind2)
            string += errorReturnStatement(type, stringValue: "nil", iInd: ind2)
            string += "\(ind)}\n\n"
            
            // create var that expects an unwrapped existing array or logs an Error and returns a system default
            string += "\(ind)/// returns [\(type)] if optional unwraps.  Logs error and returns [] if object is nil or can not unwrap.\n"
            string += "\(ind)var \(varRep): [\(type)] {\n"
            string += returnArrayStatement(type, iInd: ind2)
            string += prim.optionalArrayReturnStatement(withInitialIndent: ind2)
            string += errorReturnArrayStatement(type, iInd: ind2)
            string += "\(ind)}\n\n"
            
            // create function allows optional to always return a default value define by user.  User can also define if error is reported when object is nil
            string += "\(ind)/// returns \(type) if optional unwraps.  Logs error and returns default if object is nil (and logErrorForNil) or can not unwrap.\n"
            string += "\(ind)func \(varRep)(withDefault d: \(type), logErrorForNil: Bool) -> \(type) {\n"
            string += returnDefaultIfNilWithOptionalError(type, variable: "d", iInd: ind2)
            string += returnStatement(type, iInd: ind2)
            string += prim.optionalReturnStatement(withInitialIndent: ind2)
            string += errorReturnStatement(type, variable: "d", iInd: ind2)
            string += "\(ind)}\n\n"
            
            index += 1
        }
        
        // end primitive optional extension
        string += "}\n"
        
        return string
    }
    
    /// creates optional definitions for the Entity in string format
    fileprivate func entityDefinitions() -> String {
        
        // get indent
        let ind = HGIndent.indent
        let ind2 = HGIndent.indent(2)
        
        // begin entity optional extension
        var string = "// MARK: Entities\n"
        string += "extension Optional {\n\n"
        
        for name in entities {
            
            // get default value for current entity
            let defaultValue = "\(name).new"
            
            // create var that expects an unwrapped existing object or logs an Error and returns a system default
            string += "\(ind)/// returns \(name) if optional unwraps.  Logs error and returns \(defaultValue) if object is nil or can not unwrap.\n"
            string += "\(ind)var \(name.lowerFirstLetter): \(name) {\n"
            string += returnStatement(name, iInd: ind2)
            string += returnHGDICTStatement(name, iInd: ind2)
            string += errorReturnStatement(name, stringValue: defaultValue, iInd: ind2)
            string += "\(ind)}\n\n"
            
            // create var that expects an unwrapped existing object or logs an Error and returns a system default
            string += "\(ind)/// returns \(name) if optional unwraps.  Logs error and returns nil if object can not unwrap.  Returns nil (without Error) on nil objects.\n"
            string += "\(ind)var \(name.lowerFirstLetter)Nillable: \(name)? {\n"
            string += returnOptionalIfNil(withInitialIndent: ind2)
            string += returnStatement(name, iInd: ind2)
            string += returnHGDICTStatement(name, iInd: ind2)
            string += errorReturnStatement(name, stringValue: "nil", iInd: ind2)
            string += "\(ind)}\n\n"
            
            // create var that expects an unwrapped existing object or logs an Error and returns a system default
            string += "\(ind)/// returns [\(name)] if optional unwraps.  Logs error and returns [] if object is nil or can not unwrap.\n"
            string += "\(ind)var \(name.lowerFirstLetter): [\(name)] {\n"
            string += returnArrayStatement(name, iInd: ind2)
            string += returnHGARRAYStatement(name, iInd: ind2)
            string += errorReturnArrayStatement(name, iInd: ind2)
            string += "\(ind)}\n\n"
            
        }
        
        // end entity optional extension
        string += "}\n"
    
        return string
    }
    
    /// creates optional definitions for the Enum in string format
    fileprivate func enumDefinitions() -> String {
        
        // get indent
        let ind = HGIndent.indent
        let ind2 = HGIndent.indent(2)
        
        // begin entity optional extension
        var string = "// MARK: Enums\n"
        string += "extension Optional {\n\n"
        
        for name in enums {
            
            // get default value for current entity
            let defaultValue = "\(name).new"
            
            // create var that expects an unwrapped existing object or logs an Error and returns a system default
            string += "\(ind)/// returns \(name) if optional unwraps.  Logs error and returns \(defaultValue) if object is nil or can not unwrap.\n"
            string += "\(ind)var \(name.lowerFirstLetter): \(name) {\n"
            string += returnStatement(name, iInd: ind2)
            string += returnIntStatement(name, iInd: ind2)
            string += returnStringStatement(name, iInd: ind2)
            string += errorReturnStatement(name, stringValue: defaultValue, iInd: ind2)
            string += "\(ind)}\n\n"
            
            // create var that expects an unwrapped existing object or logs an Error and returns a system default
            string += "\(ind)/// returns \(name) if optional unwraps.  Logs error and returns nil if object can not unwrap.  Returns nil (without Error) on nil objects.\n"
            string += "\(ind)var \(name.lowerFirstLetter)Nillable: \(name)? {\n"
            string += returnOptionalIfNil(withInitialIndent: ind2)
            string += returnStatement(name, iInd: ind2)
            string += returnIntStatement(name, iInd: ind2)
            string += returnStringStatement(name, iInd: ind2)
            string += errorReturnStatement(name, stringValue: "nil", iInd: ind2)
            string += "\(ind)}\n\n"
            
        }
        
        // end entity optional extension
        string += "}\n"
        
        return string
    }
}

