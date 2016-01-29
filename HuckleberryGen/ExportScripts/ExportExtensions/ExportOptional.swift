//
//  ExportOptional.swift
//  HuckleberryGen
//
//  Created by David Vallas on 1/22/16.
//  Copyright © 2016 Phoenix Labs. All rights reserved.
//

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
        try file.writeToFile(filePath, atomically: true, encoding: NSUTF8StringEncoding)
        } catch {
        return false
        }
        
        return true
    }
    
    private func returnOptionalIfNil(withInitialIndent iInd: String) -> String {
        
        // get indent
        let ind = HGIndent.indent
        
        // return string
        var string = ""
        string += "\(iInd)if self == nil {\n"
        string += "\(iInd)\(ind)return nil\n"
        string += "\(iInd)}\n"
        return string
    }
    
    private func returnDefaultIfNilWithOptionalError(name: String, variable: String, iInd: String) -> String {
        
        // get indent
        let ind = HGIndent.indent
        
        // return string
        var string = ""
        string += "\(iInd)if self == nil {\n"
        string += "\(iInd)\(ind)if logErrorForNil {\n"
        string += "\(iInd)\(ind)\(ind)appDelegate.error.report(\"optional: \(name) returned nil value, using \\(\(variable))\", type: .Error)\n"
        string += "\(iInd)\(ind)}\n"
        string += "\(iInd)\(ind)return \(variable)\n"
        string += "\(iInd)}\n"
        return string
    }
    
    // creates an error return statement for a variable value.
    private func errorReturnStatement(name: String, variable: String, iInd: String) -> String  {
        
        // return string
        var string = ""
        string += "\(iInd)appDelegate.error.report(\"optional: |\\(self)| is not \(name) mapable, using \\(\(variable))\", type: .Error)\n"
        string += "\(iInd)return \(variable)\n"
        return string
    }
    
    // creates an error return statement for a string value.
    private func errorReturnStatement(name: String, stringValue: String, iInd: String) -> String  {
        
        // return string
        let literalString = stringValue.removeQuotes
        var string = ""
        string += "\(iInd)appDelegate.error.report(\"optional: |\\(self)| is not \(name) mapable, using \(literalString)\", type: .Error)\n"
        string += "\(iInd)return \(stringValue)\n"
        return string
    }
    
    // creates an error return statement for an array.
    private func errorReturnArrayStatement(name: String, iInd: String) -> String  {
        
        // return string
        var string = ""
        string += "\(iInd)appDelegate.error.report(\"optional is not [\(name)] mapable, using [] - optional: |\\(self)|\", type: .Error)\n"
        string += "\(iInd)return []\n"
        return string
    }
    
    private func returnArrayStatement(name: String, iInd: String) -> String {
        
        // get indent
        let ind = HGIndent.indent
        
        // return string
        var string = ""
        string += "\(iInd)if let \(name.lowerCaseFirstLetterAndArray) = self as? [\(name)] {\n"
        string += "\(iInd)\(ind)return \(name.lowerCaseFirstLetterAndArray)\n"
        string += "\(iInd)}\n"
        return string
    }
    
    private func returnHGDICTStatement(entityName: String, iInd: String) -> String {
        
        // get indent
        let ind = HGIndent.indent
        
        // return string
        var string = ""
        string += "\(iInd)if let dict = self as? HGDICT {\n"
        string += "\(iInd)\(ind)return \(entityName).decode(object: dict)\n"
        string += "\(iInd)}\n"
        return string
    }
    
    private func returnHGARRAYStatement(entityName: String, iInd: String) -> String {
        
        // get indent
        let ind = HGIndent.indent
        
        // return string
        var string = ""
        string += "\(iInd)if let array = self as? HGARRAY {\n"
        string += "\(iInd)\(ind)return \(entityName).decodeArray(objects: array)\n"
        string += "\(iInd)}\n"
        return string
    }
    
    private func returnIntStatement(name: String, iInd: String) -> String {
        
        // get indent
        let ind = HGIndent.indent
        
        // return string
        var string = ""
        string += "\(iInd)if let int = self as? Int {\n"
        string += "\(iInd)\(ind)return int.\(name.lowerCaseFirstLetter)\n"
        string += "\(iInd)}\n"
        return string
    }
    
    private func returnStringStatement(name: String, iInd: String) -> String {
        
        // get indent
        let ind = HGIndent.indent
        
        // return string
        var string = ""
        string += "\(iInd)if let string = self as? String {\n"
        string += "\(iInd)\(ind)return string.\(name.lowerCaseFirstLetter)\n"
        string += "\(iInd)}\n"
        return string
    }
    
    private func returnIntArrayStatement(name: String, iInd: String) -> String {
        
        // get indent
        let ind = HGIndent.indent
        
        // return string
        var string = ""
        string += "\(iInd)if let int = self as? Int {\n"
        string += "\(iInd)\(ind)return int.\(name.lowerCaseFirstLetter)\n"
        string += "\(iInd)}\n"
        return string
    }
    
    /// creates return statements that attempt to unwrap and return the object if it exists
    private func returnStatement(name: String, iInd: String) -> String {
        
        // get indent
        let ind = HGIndent.indent
        
        // default return
        var string = ""
        string += "\(iInd)if let \(name.lowerCaseFirstLetter) = self as? \(name) {\n"
        string += "\(iInd)\(ind)return \(name.lowerCaseFirstLetter)\n"
        string += "\(iInd)}\n"
        
        return string
    }
    
    /// creates optional definitions for standard Swift types
    private func primitiveDefinitions() -> String {
        
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
            let pName = prim.string
            
            // string representation of primitive's default value
            let pDefault = prim.defaultValue
            
            // create var that expects an unwrapped existing object or logs an Error and returns a system default
            string += "\(ind)/// returns \(pName) if optional unwraps.  Logs error and returns \(pDefault) if object is nil or can not unwrap.\n"
            string += "\(ind)var \(pName.lowerCaseFirstLetter): \(pName) {\n"
            string += returnStatement(pName, iInd: ind2)
            string += prim.optionalReturnStatement(withInitialIndent: ind2)
            string += errorReturnStatement(pName, stringValue: pDefault, iInd: ind2)
            string += "\(ind)}\n\n"
            
            // create var that expects an unwrapped existing object or logs an Error and returns a system default
            string += "\(ind)/// returns \(pName) if optional unwraps.  Logs error and returns nil if object can not unwrap.  Returns nil (without Error) on nil objects.\n"
            string += "\(ind)var \(pName.lowerCaseFirstLetter)Nillable: \(pName)? {\n"
            string += returnOptionalIfNil(withInitialIndent: ind2)
            string += returnStatement(pName, iInd: ind2)
            string += prim.optionalReturnStatement(withInitialIndent: ind2)
            string += errorReturnStatement(pName, stringValue: "nil", iInd: ind2)
            string += "\(ind)}\n\n"
            
            // create var that expects an unwrapped existing array or logs an Error and returns a system default
            string += "\(ind)/// returns [\(pName)] if optional unwraps.  Logs error and returns [] if object is nil or can not unwrap.\n"
            string += "\(ind)var \(pName.lowerCaseFirstLetterAndArray): [\(pName)] {\n"
            string += returnArrayStatement(pName, iInd: ind2)
            string += prim.optionalArrayReturnStatement(withInitialIndent: ind2)
            string += errorReturnArrayStatement(pName, iInd: ind2)
            string += "\(ind)}\n\n"
            
            // create function allows optional to always return a default value define by user.  User can also define if error is reported when object is nil
            string += "\(ind)/// returns \(pName) if optional unwraps.  Logs error and returns default if object is nil (and logErrorForNil) or can not unwrap.\n"
            string += "\(ind)func \(pName.lowerCaseFirstLetter)(withDefault d: \(pName), logErrorForNil: Bool) -> \(pName) {\n"
            string += returnDefaultIfNilWithOptionalError(pName, variable: "d", iInd: ind2)
            string += returnStatement(pName, iInd: ind2)
            string += prim.optionalReturnStatement(withInitialIndent: ind2)
            string += errorReturnStatement(pName, variable: "d", iInd: ind2)
            string += "\(ind)}\n\n"
            
            index++
        }
        
        // end primitive optional extension
        string += "}\n"
        
        return string
    }
    
    /// creates optional definitions for the Entity in string format
    private func entityDefinitions() -> String {
        
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
            string += "\(ind)var \(name.lowerCaseFirstLetter): \(name) {\n"
            string += returnStatement(name, iInd: ind2)
            string += returnHGDICTStatement(name, iInd: ind2)
            string += errorReturnStatement(name, stringValue: defaultValue, iInd: ind2)
            string += "\(ind)}\n\n"
            
            // create var that expects an unwrapped existing object or logs an Error and returns a system default
            string += "\(ind)/// returns \(name) if optional unwraps.  Logs error and returns nil if object can not unwrap.  Returns nil (without Error) on nil objects.\n"
            string += "\(ind)var \(name.lowerCaseFirstLetter)Nillable: \(name)? {\n"
            string += returnOptionalIfNil(withInitialIndent: ind2)
            string += returnStatement(name, iInd: ind2)
            string += returnHGDICTStatement(name, iInd: ind2)
            string += errorReturnStatement(name, stringValue: "nil", iInd: ind2)
            string += "\(ind)}\n\n"
            
            // create var that expects an unwrapped existing object or logs an Error and returns a system default
            string += "\(ind)/// returns [\(name)] if optional unwraps.  Logs error and returns [] if object is nil or can not unwrap.\n"
            string += "\(ind)var \(name.lowerCaseFirstLetterAndArray): [\(name)] {\n"
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
    private func enumDefinitions() -> String {
        
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
            string += "\(ind)var \(name.lowerCaseFirstLetter): \(name) {\n"
            string += returnStatement(name, iInd: ind2)
            string += returnIntStatement(name, iInd: ind2)
            string += returnStringStatement(name, iInd: ind2)
            string += errorReturnStatement(name, stringValue: defaultValue, iInd: ind2)
            string += "\(ind)}\n\n"
            
            // create var that expects an unwrapped existing object or logs an Error and returns a system default
            string += "\(ind)/// returns \(name) if optional unwraps.  Logs error and returns nil if object can not unwrap.  Returns nil (without Error) on nil objects.\n"
            string += "\(ind)var \(name.lowerCaseFirstLetter)Nillable: \(name)? {\n"
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

