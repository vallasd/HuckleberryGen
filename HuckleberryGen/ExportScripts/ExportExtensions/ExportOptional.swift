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
        let name = "HGOptional"
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
    
    private func returnOptionalIfNil() -> String {
        var string = ""
        string += "\tif self == nil {\n"
        string += "\t\treturn nil\n"
        string += "\t}\n"
        return string
    }
    
    private func returnDefaultIfNilWithOptionalError(name: String, variable: String) -> String {
        var string = ""
        string += "\tif self == nil {\n"
        string += "\t\tif logErrorForNil {\n"
        string += "\t\t\tappDelegate.error.report(\"optional: \(name) returned nil value, using \\(\(variable))\", type: .Error)\n"
        string += "\t\t}\n"
        string += "\t\treturn \(variable)\n"
        string += "\t}\n"
        return string
    }
    
    // creates an error return statement for a variable value.
    private func errorReturnStatement(name: String, variable: String) -> String  {
        var string = ""
        string += "\tappDelegate.error.report(\"optional: |\\(self)| is not \(name) mapable, using \\(\(variable))\", type: .Error)\n"
        string += "\treturn \(variable)\n"
        return string
    }
    
    // creates an error return statement for a string value.
    private func errorReturnStatement(name: String, stringValue: String) -> String  {
        var string = ""
        string += "\tappDelegate.error.report(\"optional: |\\(self)| is not \(name) mapable, using \(stringValue)\", type: .Error)\n"
        string += "\treturn \(stringValue)\n"
        return string
    }
    
    // creates an error return statement for an array.
    private func errorReturnArrayStatement(name: String) -> String  {
        var string = ""
        string += "\tappDelegate.error.report(\"optional is not [\(name)] mapable, using [] - optional: |\\(self)|\", type: .Error)\n"
        string += "\treturn []\n"
        return string
    }
    
    private func returnArrayStatement(name: String) -> String {
        var string = ""
        string += "\tif let \(name.lowerCaseFirstLetterAndArray) = self as? [\(name)] {\n"
        string += "\t\treturn \(name.lowerCaseFirstLetterAndArray)\n"
        string += "\t}\n"
        return string
    }
    
    private func returnHGDICTStatement(entityName: String) -> String {
        var string = ""
        string += "\tif let dict = self as? HGDICT {\n"
        string += "\t\treturn \(entityName).decode(object: dict)\n"
        string += "\t}\n"
        return string
    }
    
    private func returnHGARRAYStatement(entityName: String) -> String {
        var string = ""
        string += "\tif let array = self as? HGARRAY {\n"
        string += "\t\treturn \(entityName).decodeArray(objects: array)\n"
        string += "\t\t}\n"
        return string
    }
    
    private func returnIntStatement(entityName: String) -> String {
        var string = ""
        string += "\tif let int = self as? Int {\n"
        string += "\t\treturn int.\(entityName)\n"
        string += "\t}\n"
        return string
    }
    
    private func returnStringStatement(entityName: String) -> String {
        var string = ""
        string += "\tif let string = self as? String {\n"
        string += "\t\treturn string.\(entityName)\n"
        string += "\t}\n"
        return string
    }
    
    private func returnIntArrayStatement(entityName: String) -> String {
        var string = ""
        string += "\tif let int = self as? Int {\n"
        string += "\t\treturn int.\(entityName)\n"
        string += "\t}\n"
        return string
    }
    
    /// creates return statements that attempt to unwrap and return the object if it exists
    private func returnStatement(name: String) -> String {
        
        // default return
        var string = ""
        string += "\tif let \(name.lowerCaseFirstLetter) = self as? \(name) {\n"
        string += "\t\treturn \(name.lowerCaseFirstLetter)\n"
        string += "\t}\n"
        
        return string
    }
    
    /// creates optional definitions for standard Swift types
    private func primitiveDefinitions() -> String {
        
        // begin primitive optional extension
        var string = "// MARK: Standard Swift Types\n"
        string += "extension Optional {\n\n"
        
        
        // define primitives
        let primitives = Primitive.array
        
        var index = 0
        for prim in primitives {
            
            // string representation of primitive
            let primitive = prim.string
            
            // string representation of primitive's default value
            let primitiveDefault = prim.defaultValue
            
            // create var that expects an unwrapped existing object or logs an Error and returns a system default
            string += "\t/// returns \(primitive) if optional unwraps.  Logs error and returns \(primitiveDefault) if object is nil or can not unwrap.\n"
            string += "\tvar \(primitive.lowerCaseFirstLetter): \(primitive) {\n"
            string += returnStatement(primitive)
            string += errorReturnStatement(primitive, stringValue: primitiveDefault)
            string += "\t}\n\n"
            
            // create var that expects an unwrapped existing object or logs an Error and returns a system default
            string += "\t/// returns \(primitive) if optional unwraps.  Logs error and returns nil if object can not unwrap.  Returns nil (without Error) on nil objects.\n"
            string += "\tvar \(primitive.lowerCaseFirstLetter)Nillable: \(primitive)? {\n"
            string += returnOptionalIfNil()
            string += returnStatement(primitive)
            string += errorReturnStatement(primitive, stringValue: "nil")
            string += "\t}\n\n"
            
            // create var that expects an unwrapped existing object or logs an Error and returns a system default
            string += "\t/// returns [\(primitive)] if optional unwraps.  Logs error and returns [] if object is nil or can not unwrap.\n"
            string += "\tvar \(primitive.lowerCaseFirstLetterAndArray): [\(primitive)] {\n"
            string += returnArrayStatement(primitive)
            string += errorReturnArrayStatement(primitive)
            string += "\t}\n\n"
            
            // create function allows optional to always return a default value define by user.  User can also define if error is reported when object is nil
            string += "\t/// returns \(primitive) if optional unwraps.  Logs error and returns default if object is nil (and logErrorForNil) or can not unwrap.\n"
            string += "\tfunc \(primitive.lowerCaseFirstLetter)(withDefault d: \(primitive), logErrorForNil: Bool) -> \(primitive) {\n"
            string += returnDefaultIfNilWithOptionalError(primitive, variable: "d")
            string += returnStatement(primitive)
            string += errorReturnStatement(primitive, variable: "d")
            string += "\t}\n\n"
            
            index++
        }
        
        // end primitive optional extension
        string += "}\n"
        
        return string
    }
    
    /// creates optional definitions for the Entity in string format
    private func entityDefinitions() -> String {
    
        // begin entity optional extension
        var string = "// MARK: Entities\n"
        string += "extension Optional {\n\n"
        
        for name in entities {
            
            // get default value for current entity
            let defaultValue = "\(name).new"
            
            // create var that expects an unwrapped existing object or logs an Error and returns a system default
            string += "\t/// returns \(name) if optional unwraps.  Logs error and returns \(defaultValue) if object is nil or can not unwrap.\n"
            string += "\tvar \(name.lowerCaseFirstLetter): \(name) {\n"
            string += returnStatement(name)
            string += returnHGDICTStatement(name)
            string += errorReturnStatement(name, stringValue: defaultValue)
            string += "\t}\n\n"
            
            // create var that expects an unwrapped existing object or logs an Error and returns a system default
            string += "\t/// returns \(name) if optional unwraps.  Logs error and returns nil if object can not unwrap.  Returns nil (without Error) on nil objects.\n"
            string += "\tvar \(name.lowerCaseFirstLetter)Nillable: \(name)? {\n"
            string += returnOptionalIfNil()
            string += returnStatement(name)
            string += returnHGDICTStatement(name)
            string += errorReturnStatement(name, stringValue: "nil")
            string += "\t}\n\n"
            
            // create var that expects an unwrapped existing object or logs an Error and returns a system default
            string += "\t/// returns [\(name)] if optional unwraps.  Logs error and returns [] if object is nil or can not unwrap.\n"
            string += "\tvar \(name.lowerCaseFirstLetterAndArray): [\(name)] {\n"
            string += returnArrayStatement(name)
            string += returnHGARRAYStatement(name)
            string += errorReturnArrayStatement(name)
            string += "\t}\n\n"
            
        }
        
        // end entity optional extension
        string += "}\n"
    
        return string
    }
    
    /// creates optional definitions for the Enum in string format
    private func enumDefinitions() -> String {
        
        // begin entity optional extension
        var string = "// MARK: Enums\n"
        string += "extension Optional {\n\n"
        
        for name in enums {
            
            // get default value for current entity
            let defaultValue = "\(name).new"
            
            // create var that expects an unwrapped existing object or logs an Error and returns a system default
            string += "\t/// returns \(name) if optional unwraps.  Logs error and returns \(defaultValue) if object is nil or can not unwrap.\n"
            string += "\tvar \(name.lowerCaseFirstLetter): \(name) {\n"
            string += returnStatement(name)
            string += returnIntStatement(name)
            string += returnStringStatement(name)
            string += errorReturnStatement(name, stringValue: defaultValue)
            string += "\t}\n\n"
            
            // create var that expects an unwrapped existing object or logs an Error and returns a system default
            string += "\t/// returns \(name) if optional unwraps.  Logs error and returns nil if object can not unwrap.  Returns nil (without Error) on nil objects.\n"
            string += "\tvar \(name.lowerCaseFirstLetter)Nillable: \(name)? {\n"
            string += returnOptionalIfNil()
            string += returnStatement(name)
            string += returnIntStatement(name)
            string += returnStringStatement(name)
            string += errorReturnStatement(name, stringValue: "nil")
            string += "\t}\n\n"
            
        }
        
        // end entity optional extension
        string += "}\n"
        
        return string
    }
    
}

