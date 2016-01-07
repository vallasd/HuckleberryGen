//
//  ImportBoard.swift
//  HuckleberryGen
//
//  Created by David Vallas on 11/19/15.
//  Copyright © 2015 Phoenix Labs. All rights reserved.
//

import Cocoa


// TODO: ImportBoard calls a parse command that is run asynchronously and is dependent on the ImportBoard's reference to HGImportParser to finish.  It is called when ImportBoard is unloading.  This may cause a problem when parsing large files.  (ImportBoard is released before parse is finished).  We may want to create a strong reference to import board until the parse is completed.
/// A board that imports projects into Huckleberry Gen for additional creation.
class ImportBoard: NSViewController, NavControllerReferrable {
    
    /// reference to the nav controller
    var nav: NavController?
    
    /// search path ImportBoard uses to create Folder (default searchpath is defined in the store)
    var searchPath: String? = appDelegate.store.importFileSearchPath
    
    /// reference to the selection board
    private var selectionboard: SelectionBoard!
    
    /// folder the contains all the possible import files
    private var importFolder: Folder?
    
    // holds reference to parser while the parser is parsing the current importFile
    var parser: HGImportParser?
    
    /// project stored when user selects a column
    private var project: Project?
    
    // MARK: View Lifecycle
    override func viewDidLoad() {
        
        // displays the selection board on top of this view and sets self as delegate
        selectionboard = SelectionBoard.present(onViewController: self)
        selectionboard.boardDelegate = self
        selectionboard.boardDataSource = self
        
        // selection board title is blanks until we get callback from folder creation
        selectionboard.boardtitle.stringValue = ""
        
        nav?.disableProgression()
        
        createFolder()
    }
    
    /// creates a folder (of importfiles) from searchPath
    private func createFolder() {
        
        let path = searchPath
        let name: String = searchPath?.lastPathComponent ?? ""
        
        if path == nil || name == "" {
            HGReportHandler.report("Import Board was unable to create folder from path \(path), name \(name)", response: .Error)
        }
        
        // Create a folder from path and name
        Folder.create(name: name, path: path!, completion: { [weak self] (newfolder) -> Void in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self?.importFolder = newfolder
                self?.updateSelectionBoardTitle()
                self?.selectionboard.update()
            })
        })
    }
    
    /// updates board title depending on folder information
    private func updateSelectionBoardTitle() {
        
        if importFolder == nil || importFolder?.importFiles.count == 0 {
            selectionboard?.boardtitle.stringValue = "No Import Files Found"
            selectionboard?.boardtitle.textColor = NSColor.redColor()
            return
        }
        
        selectionboard?.boardtitle.stringValue = "Choose Import File"
        selectionboard?.boardtitle.textColor = NSColor.blackColor()
        
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
            HGReportHandler.report("Project Importer was unable to create parser from importFile \(importFile)", response: .Error)
        }
    }
}

extension ImportBoard: NavControllerPushable {
    var nextBoard: BoardType? { return nil }
}

// MARK: HGImportParserDelegate
extension ImportBoard: HGImportParserDelegate {
    
    func parserDidParse(importFile: ImportFile, success: Bool, project: Project) {
        if success {
            appDelegate.store.project = project
        } else {
            HGReportHandler.report("Import Error: could not parse import file: \(importFile.name)" , response: .Error)
        }
    }
}

// MARK: SelectionBoardDelegate
extension ImportBoard: SelectionBoardDelegate {
    
    func hgcellType(forSelectionBoard sb: SelectionBoard) -> HGCellType {
        return HGCellType.FieldCell3
    }
    
    func selectionboard(sb: SelectionBoard, didChoose items: [Int]) {
        let item = items[0] // we should only be selecting one item at a time
        let selectedFile = importFolder!.importFiles[item]
        parse(selectedFile)
    }
}

// MARK: SelectionBoardDataSource
extension ImportBoard: SelectionBoardDataSource {
    
    func numberOfItems(forSelectionBoard sb: SelectionBoard) -> Int {
        let count = importFolder?.importFiles.count ?? 0
        return count
    }
    
    func selectionboard(sb: SelectionBoard, dataForRow row: Int) -> HGCellData {
        let file = importFolder!.importFiles[row]
        return HGCellData.fieldCell3(
            field0: HGFieldData(title: file.name),
            field1: HGFieldData(title: "Path:"),
            field2: HGFieldData(title: file.path),
            field3: HGFieldData(title: "Last Modified:"),
            field4: HGFieldData(title: file.modificationDate.mmddyy))
    }
}
