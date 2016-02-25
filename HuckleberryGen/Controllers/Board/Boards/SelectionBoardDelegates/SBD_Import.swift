//
//  SBD_Import.swift
//  HuckleberryGen
//
//  Created by David Vallas on 1/10/16.
//  Copyright © 2016 Phoenix Labs.
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

class SBD_Import: SelectionBoardDelegate {
    
    /// intialization method
    init() {
        createImportFolder()
    }
    
    /// weak reference to the selection board
    weak var selectionBoard: SelectionBoard?
    
    /// reference to cellType
    var celltype = CellType.FieldCell3
    
    /// holds reference to parser while the parser is parsing the current importFile
    var parser: HGImportParser?
    
    /// a folder of import files
    var importFolder: Folder!
    
    /// creates a folder (of importfiles) from searchPath
    private func createImportFolder() {
        
        let path = appDelegate.store.importPath
        let name: String = path.lastPathComponent
        
        // Create a folder from path and name
        Folder.create(name: name, path: path, completion: { [weak self] (newfolder) -> Void in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self?.importFolder = newfolder
                self?.selectionBoard?.update()
            })
            })
    }
    
    /// parses the selected Import File (delegate will handle the project when it is returned)
    func parse(importFile: ImportFile) {
        
        // reset, create, and execute parser
        parser?.resetParse()
        parser = HGParse.importParser(forImportFile: importFile)
        parser?.delegate = self
        parser?.parse()
        
        // report error if parser was not successfully created
        if parser == nil {
            HGReportHandler.shared.report("Project Importer was unable to create parser from importFile \(importFile)", type: .Error)
        }
    }
    
    /// SelectionBoardDelegate function
    func selectionboard(sb: SelectionBoard, didChooseLocations locations: [HGCellLocation]) {
        let index = celltype.index(forlocation: locations[0])
        let importFile = importFolder.importFiles[index]
        parse(importFile)
        selectionBoard?.update()
    }
    
}

// MARK: HGImportParserDelegate
extension SBD_Import: HGImportParserDelegate {
    
    func parserDidParse(importFile: ImportFile, success: Bool, project: Project) {
        if success {
            appDelegate.store.project = project
        } else {
            HGReportHandler.shared.report("Import Error: could not parse import file: \(importFile.name)" , type: .Error)
        }
    }
}

// MARK: HGTableDisplayable
extension SBD_Import: HGTableDisplayable {
    
    func numberOfRows(fortable table: HGTable) -> Int {
        let num = importFolder != nil ? importFolder.importFiles.count : 0
        return num
    }
    
    func hgtable(table: HGTable, heightForRow row: Int) -> CGFloat {
        return celltype.rowHeightForTable(selectionBoard?.tableview)
    }
    
    func hgtable(table: HGTable, cellForRow row: Int) -> CellType {
        return celltype
    }
    
    func hgtable(table: HGTable, dataForRow row: Int) -> HGCellData {
        let file = importFolder!.importFiles[row]
        return HGCellData.fieldCell3(
            field0: HGFieldData(title: file.name),
            field1: HGFieldData(title: "Path:"),
            field2: HGFieldData(title: file.path),
            field3: HGFieldData(title: "Last Modified:"),
            field4: HGFieldData(title: file.modificationDate.mmddyy))
    }
}

// MARK: HGTableRowSelectable
extension SBD_Import: HGTableRowSelectable {

    func hgtable(table: HGTable, shouldSelectRow row: Int) -> Bool {
        return true
    }
}