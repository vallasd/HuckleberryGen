//
//  SBD_Import.swift
//  HuckleberryGen
//
//  Created by David Vallas on 1/10/16.
//  Copyright © 2016 Phoenix Labs.
//
//  All Rights Reserved.

import Foundation

class SBD_Import: SelectionBoardDelegate {
    
    /// intialization method
    init() {
        createImportFolder()
    }
    
    /// weak reference to the selection board
    weak var selectionBoard: SelectionBoard?
    
    /// holds reference to parser while the parser is parsing the current importFile
    var parser: HGImportParser?
    
    /// a folder of import files
    var importFolder: Folder!
    
    /// creates a folder (of importfiles) from searchPath
    fileprivate func createImportFolder() {
        
        let path = appDelegate.store.importPath
        let name: String = path.lastPathComponent
        
        // Create a folder from path and name
        Folder.create(name: name, path: path, completion: { [weak self] (newfolder) -> Void in
            DispatchQueue.main.async(execute: { () -> Void in
                self?.importFolder = newfolder
                self?.selectionBoard?.update()
            })
        })
    }
    
    /// parses the selected Import File (delegate will handle the project when it is returned)
    func parse(_ importFile: ImportFile) {
        // reset, create, and execute parser
        parser?.resetParse()
        parser = HGParse.importParser(forImportFile: importFile)
        parser?.delegate = self
        parser?.parse()
        
        // report error if parser was not successfully created
        if parser == nil {
            HGReport.shared.report("Project Importer was unable to create parser from importFile \(importFile)", type: .error)
        }
    }
    
    /// SelectionBoardDelegate function
    func selectionboard(_ sb: SelectionBoard, didChooseLocation loc: HGTableLocation) {
        let importFile = importFolder.importFiles[loc.index]
        parse(importFile)
        selectionBoard?.update()
    }
    
}

// MARK: HGImportParserDelegate
extension SBD_Import: HGImportParserDelegate {
    
    func parserDidParse(_ importFile: ImportFile, success: Bool, project: Project) {
        if success {
            appDelegate.store.project = project
        } else {
            HGReport.shared.report("Import Error: could not parse import file: \(importFile.name)" , type: .error)
        }
    }
}

// MARK: HGTableDisplayable
extension SBD_Import: HGTableDisplayable {
    
    func numberOfItems(fortable table: HGTable) -> Int {
        return importFolder != nil ? importFolder.importFiles.count : 0
    }
    
    func cellType(fortable table: HGTable) -> CellType {
        return CellType.fieldCell3
    }
    
    func hgtable(_ table: HGTable, dataForIndex index: Int) -> HGCellData {
        let file = importFolder!.importFiles[index]
        return HGCellData.fieldCell3(
            field0: HGFieldData(title: file.name),
            field1: HGFieldData(title: "Path:"),
            field2: HGFieldData(title: file.path),
            field3: HGFieldData(title: "Last Modified:"),
            field4: HGFieldData(title: file.modificationDate.mmddyy))
    }
}

// MARK: HGTableRowSelectable
extension SBD_Import: HGTableLocationSelectable {

    func hgtable(_ table: HGTable, shouldSelectLocation loc: HGTableLocation) -> Bool {
        return true
    }
    
    func hgtable(_ table: HGTable, didSelectLocation loc: HGTableLocation) {
        // do nothing
    }
    
}
