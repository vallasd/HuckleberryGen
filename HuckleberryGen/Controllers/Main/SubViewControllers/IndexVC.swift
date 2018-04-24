//
//  IndexVC.swift
//  HuckleberryGen
//
//  Created by David Vallas on 1/31/16.
//  Copyright © 2016 Phoenix Labs.
//
//  All Rights Reserved.

import Cocoa

/// NSViewController that displays a table of Indexes
class IndexVC: NSViewController {
    
    // MARK: Public Variables
    
    @IBOutlet weak var tableview: HGTableView! { didSet { hgtable = HGTable(tableview: tableview, delegate: self) } }
    
    var hgtable: HGTable!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension IndexVC: HGTableDisplayable {
    
    func numberOfItems(fortable table: HGTable) -> Int {
        return appDelegate.store.project.indexes.count
    }
    
    func cellType(fortable table: HGTable) -> CellType {
        return CellType.defaultCell
    }
    
    func hgtable(_ table: HGTable, dataForIndex index: Int) -> HGCellData {
        let index = appDelegate.store.getIndex(index: index)
        return HGCellData.defaultCell(
            field0: HGFieldData(title: index.varRep),
            field1: HGFieldData(title: ""),
            image0: HGImageData(title: "", image: index.entityImage)
        )
    }
}

// MARK: HGTableObservable
extension IndexVC: HGTableObservable {
    
    func observeNotifications(fortable table: HGTable) -> [String] {
        return appDelegate.store.notificationNames(forNotifTypes: [.indexUpdated])
    }
}

extension IndexVC: HGTableLocationSelectable {
    
    func hgtable(_ table: HGTable, shouldSelectLocation loc: HGTableLocation) -> Bool {
        
        if loc.type == .row {
            return true
        }
        
        // present a selection board to update current Attribute
        if loc.type == .image && loc.tag == 0 {
            let context = SBD_Entities(indexIndex: loc.index)
            let boarddata = SelectionBoard.boardData(withContext: context)
            appDelegate.mainWindowController.boardHandler.start(withBoardData: boarddata)
        }
        
        return false
    }
    
    func hgtable(_ table: HGTable, didSelectLocation loc: HGTableLocation) {
        // do nothing
    }
}

extension IndexVC: HGTableFieldEditable {
    
    func hgtable(_ table: HGTable, shouldEditRow row: Int, field: Int) -> Bool {
        return field == 0 ? true : false
    }
    
    func hgtable(_ table: HGTable, didEditRow row: Int, field: Int, withString string: String) {
        var index = appDelegate.store.getIndex(index: row)
        index.varRep = string
        appDelegate.store.replaceIndex(atIndex: row, withIndex: index)
    }
}

// MARK: HGTableRowAppendable
extension IndexVC: HGTableRowAppendable {
    
    func hgtable(shouldAddRowToTable table: HGTable) -> Bool  {
        return true
    }
    
    func hgtable(willAddRowToTable table: HGTable) {
        let _ = appDelegate.store.createIndex()
    }
    
    func hgtable(_ table: HGTable, shouldDeleteRows rows: [Int]) -> Option {
        return .yes
    }
    
    func hgtable(_ table: HGTable, willDeleteRows rows: [Int]) {
        let _ = appDelegate.store.deleteIndexes(atIndexes: rows)
    }
}
