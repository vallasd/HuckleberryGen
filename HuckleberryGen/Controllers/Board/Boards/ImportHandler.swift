//
//  ProjectVC.swift
//  HuckleberryGen
//
//  Created by David Vallas on 7/20/15.
//  Copyright © 2015 Phoenix Labs. All rights reserved.
//

import Cocoa

protocol HGHandler {
    var selectionBoard: SelectionBoard? { get }
}

class ImportHandler: NSObject, HGHandler {
    
    // MARK: HGParser
    
    var importFolder: Folder = Folder.new
    var parser: HGImportParser?
    var delegate: HandlerDelegate?
    weak var selectionBoard: SelectionBoard?
    
    init(sb: SelectionBoard) {
        selectionBoard = sb
        super.init()
        createImportFolder()
        selectionBoard?.delegate = self
    }
    
    private func createImportFolder() {
        
        guard let path = HuckleberryGen.store.importFileSearchPath else { return }
        guard let name: String = path.lastPathComponent else { return }
        
        Folder.create(name: name, path: path, completion: { [weak self] (newfolder) -> Void in
            self?.importFolder = newfolder
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self?.setBoardTitle()
                self?.selectionBoard?.update()
            })
        })
    }
}

extension ImportHandler: HGParserDelegate {
    
    // MARK: HGParserDelegate
    
    func parserDidParseImportFile(importFile: ImportFile, success: Bool, model: HGModel) {
        if success {
            HuckleberryGen.store.hgmodel = model
        } else {
            HGReportHandler.report("Import Error: could not parse import file: \(importFile.name)" , response: HGErrorResponse.Alert)
        }
    }
    
    func parse(importFile: ImportFile) {
        if let currentParser = parser { currentParser.resetParse() }
        parser = HGParser.parserForImportFile(importFile)
        parser?.delegate = self
        parser?.parse()
    }
    
}

extension ImportHandler: SelectionBoardDataSource {
    
    
    // MARK: SelectionBoardDelegate
    
    func hgcellType(forSelectionBoard sb: SelectionBoard) -> HGCellType {
        return HGCellType.MixedCell1
    }
    
    func selectionboard(sb: SelectionBoard, didChoose items: [Int]) {
        let item = items[0]
        let selectedFile = importFolder.importFiles[item]
        parse(selectedFile)
        delegate?.handlerFinished(self)
    }
    
    // MARK: SelectionBoardDataSource
    
    func numberOfItems(forSelectionBoard sb: SelectionBoard) -> Int {
        let count = importFolder.importFiles.count
        return count
    }
    
    func selectionboard(sb: SelectionBoard, dataForRow row: Int) -> HGCellData {
        let file = importFolder.importFiles[row]
        return HGCellData.defaultCell(
            field0: HGFieldData(title: file.name),
            field1: HGFieldData(title: file.path),
            image0: nil
        )
    }
    
    private func setBoardTitle() {
        
        guard let selectionBoard = selectionBoard else {
            delegate?.handlerFinished(self)
            return
        }
        
        if importFolder.importFiles.count == 0 {
            selectionBoard.boardtitle.stringValue = "No Import Files Found"
            selectionBoard.boardtitle.textColor = NSColor.redColor()
            return
        }
        
        selectionBoard.boardtitle.stringValue = "Choose Import File"
        selectionBoard.boardtitle.textColor = NSColor.blackColor()
    }
}
