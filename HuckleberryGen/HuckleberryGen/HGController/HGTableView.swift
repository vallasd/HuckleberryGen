//
//  HGTableView.swift
//  HuckleberryGen
//
//  Created by David Vallas on 9/28/15.
//  Copyright © 2015 Phoenix Labs. All rights reserved.
//

import Cocoa

let notSelected: Int = -99

protocol HGTableViewDelegate: NSTableViewDelegate {
    func hgtableview(hgtableview: HGTableView, shouldSelectRow row: Int) -> Bool
    func hgtableview(shouldAddRowToTable hgtableview: HGTableView) -> Bool
    func hgtableviewShouldDeleteSelectedRows(hgtableview: HGTableView) -> Bool
    func hgtableview(hgtableview: HGTableView, didSelectRow row: Int)
    func hgtableview(willAddRowToTable hgtableview: HGTableView)
    func hgtableview(hgtableview: HGTableView, willDeleteRows rows: [Int])
}

/// Extended NSTableView that appropriate handles mouse and keyboard clicks for Huckleberry Gen
class HGTableView: NSTableView {
    
    /// Determines if user can select / deselect multiple rows.  Functionality currently broken
    var allowsMultipleRowSelection: Bool = false
    
    /// Returns array of selected rows.  Do not use inside HGTableView (use iSelectedRows)
    var selectedRows: [Int] {
        get {
            return Array(iSelectedRows)
        }
    }
    
    /// A set of selected rows.  Internal Variable.
    private var iSelectedRows: NSMutableIndexSet = NSMutableIndexSet()
    
    /// Extended delegate that conforms to protocol HGTableViewDelegate
    var extendedDelegate: HGTableViewDelegate?
    
    /// Deletes rows supplied without conferring with delegate
    func delete(rows rows: [Int]) {
        
        // return if no rows to delete
        if rows.count == 0 {
            return
        }
        
        // create indexSet from rows
        let indexSet = NSMutableIndexSet()
        for row in rows { indexSet.addIndex(row) }
        
        // notify delegate about impending deletion
        extendedDelegate?.hgtableview(self, willDeleteRows: rows)
        
        // remove indexes from selected rows
        iSelectedRows.removeIndexes(indexSet)
        
        // remove rows from self (Tableview)
        self.removeRowsAtIndexes(indexSet, withAnimation: [.EffectNone])
        
        // If we were trying to remove only one row at a time, we will auto-highlight the row above so the user can easily delete out multiple rows with a command
        if rows.count == 1 {
            let row = rows[0]
            let numRows = self.numberOfRows
            if row < numRows {
                selectRow(row)
            } else if numRows > 0 {
                selectRow(numRows - 1)
            }
        }
    }
    
    /// custom HGTableView function that handles mouseDown events
    override func mouseDown(theEvent: NSEvent) {
        
        let global = theEvent.locationInWindow
        let local = self.convertPoint(global, fromView: nil)
        let row = self.rowAtPoint(local)
        
        // super.mouseDown(theEvent) // We removed this because mouseDown was auto selecting rows
        
        if (row != notSelected && row != -1) {
            selectRow(row)
        }
    }
    
    /// custom HGTableView function that handles keyDown events
    override func keyDown(theEvent: NSEvent) {
        let command = theEvent.command()
        switch command {
        case .AddRow: addRow()
        case .DeleteRow: deleteSelectedRowsIfDelegateSaysOK()
        case .NextRow: selectNext()
        case .PreviousRow: selectPrev()
        default: break // Do Nothing
        }
    }
    
    /// custom HGTableView function that handles changed flag events such as command button held down
    override func flagsChanged(theEvent: NSEvent) {
        let options = theEvent.commandOptions()
        if options.contains(HGCommandOptions.MultiSelectOn) {
            allowsMultipleRowSelection = true
        } else {
            allowsMultipleRowSelection = false
        }
    }
    
    /// Selects or unselects (if row is currently selected) a row
    private func selectRow(var row: Int) {
        
        if row != notSelected {
            
            let isSelectableRow = extendedDelegate?.hgtableview(self, shouldSelectRow: row) ?? false
            let isSelectedRow = iSelectedRows.contains(row)
            
            if isSelectedRow {
                iSelectedRows.removeIndex(row)
                row = notSelected
            }
                
            else if isSelectableRow {
                if allowsMultipleRowSelection {
                    iSelectedRows.addIndex(row)
                } else {
                    iSelectedRows = NSMutableIndexSet(index: row)
                }
            }
        }
        
        extendedDelegate?.hgtableview(self, didSelectRow: row)
        
        // Selects row and then scrolls to it
        NSOperationQueue.mainQueue().addOperationWithBlock { [weak self] () -> Void in
            self?.selectRowIndexes(self?.iSelectedRows ?? NSIndexSet(), byExtendingSelection: false)
            self?.scrollRowToVisible(row)
        }
    }
    
    /// Selects previous row, loops to end of hgtableview index if current index is 0
    private func selectPrev() {
        if iSelectedRows.count <= 1 {
            var selectedRow = iSelectedRows.count == 0 ? notSelected : iSelectedRows.lastIndex
            if selectedRow == notSelected || selectedRow == 0 { selectedRow = self.numberOfRows - 1 }
            else { selectedRow-- }
            selectRow(selectedRow)
        }
    }
    
    /// Selects next row, loops to beginning of hgtableview index if current index is lastrow
    private func selectNext() {
        if iSelectedRows.count <= 1 {
            var selectedRow = iSelectedRows.count == 0 ? notSelected : iSelectedRows.lastIndex
            let totalRows = self.numberOfRows
            if selectedRow == notSelected || selectedRow == totalRows - 1 { selectedRow = 0 }
            else { selectedRow++ }
            selectRow(selectedRow)
        }
    }
    
    /// Unselects all rows
    private func unSelectAll() {
        deselectAll(self)
        iSelectedRows = NSMutableIndexSet()
    }
    
    /// Asks delegate if hgtableview should add row, then adds row if delegate returns true
    private func addRow() {
        let shouldAdd = extendedDelegate?.hgtableview(shouldAddRowToTable: self) ?? false
        if shouldAdd == true {
            let index = numberOfRows
            unSelectAll()
            extendedDelegate?.hgtableview(willAddRowToTable: self)
            insertRowsAtIndexes(NSIndexSet(index: index), withAnimation: [.EffectNone])
            selectRow(index)
        }
    }
    
    /// Asks delegate if hgtableview should delete rows, then deletes row if delegate returns true
    private func deleteSelectedRowsIfDelegateSaysOK() {
        
        let shouldDelete = extendedDelegate?.hgtableviewShouldDeleteSelectedRows(self) ?? false
        
        if shouldDelete == true {
            delete(rows: selectedRows)
        }
        
    }
    
}