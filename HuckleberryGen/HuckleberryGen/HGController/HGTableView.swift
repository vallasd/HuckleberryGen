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
    func hgtableview(hgtableview: HGTableView, shouldDeleteRow row: Int) -> Bool
    func hgtableview(hgtableview: HGTableView, didSelectRow row: Int)
    func hgtableview(willAddRowToTable hgtableview: HGTableView)
    func hgtableview(hgtableview: HGTableView, willDeleteRow row: Int)
}

/// Extended NSTableView that appropriate handles mouse and keyboard clicks
class HGTableView: NSTableView {
    
    /// Determines if user can select / deselect multiple rows.  Functionality currently broken
    var allowsMultipleRowSelection: Bool = false
    
    /// An Array of locations that are currently selected by the table view.
    private(set) var selectedRows: NSMutableIndexSet = NSMutableIndexSet()
    
    var extendedDelegate: HGTableViewDelegate?
    
    override func mouseDown(theEvent: NSEvent) {
        
        let global = theEvent.locationInWindow
        let local = self.convertPoint(global, fromView: nil)
        let row = self.rowAtPoint(local)
        
        super.mouseDown(theEvent)
        
        if (row != notSelected && row != -1) {
            selectRow(row)
        }
    }
    
    override func keyDown(theEvent: NSEvent) {
        let command = theEvent.command()
        switch command {
        case .AddRow: addRow()
        case .DeleteRow: deleteRow()
        case .NextRow: selectNext()
        case .PreviousRow: selectPrev()
        default: break // Do Nothing
        }
    }
    
    override func flagsChanged(theEvent: NSEvent) {
        let options = theEvent.commandOptions()
        if options.contains(HGCommandOptions.MultiSelectOn) {
            allowsMultipleRowSelection = true
        } else {
            allowsMultipleRowSelection = false
        }
    }
    
    private func selectRow(var row: Int) {
        
        if row != notSelected {
            
            let isSelectableRow = extendedDelegate?.hgtableview(self, shouldSelectRow: row) ?? false
            let isSelectedRow = selectedRows.contains(row)
            
            if isSelectedRow {
                selectedRows.removeIndex(row)
                row = notSelected
            }
                
            else if isSelectableRow {
                if allowsMultipleRowSelection {
                    selectedRows.addIndex(row)
                } else {
                    selectedRows = NSMutableIndexSet(index: row)
                }
            }
        }
        
        extendedDelegate?.hgtableview(self, didSelectRow: row)
        
        NSOperationQueue.mainQueue().addOperationWithBlock { [weak self] () -> Void in
            self?.selectRowIndexes(self?.selectedRows ?? NSIndexSet(), byExtendingSelection: false)
            self?.scrollRowToVisible(row)
        }
    }
    
    private func selectPrev() {
        if selectedRows.count <= 1 {
            var selectedRow = selectedRows.count == 0 ? notSelected : selectedRows.lastIndex
            if selectedRow == notSelected || selectedRow == 0 { selectedRow = self.numberOfRows - 1 }
            else { selectedRow-- }
            selectRow(selectedRow)
        }
    }
    
    private func selectNext() {
        if selectedRows.count <= 1 {
            var selectedRow = selectedRows.count == 0 ? notSelected : selectedRows.lastIndex
            let totalRows = self.numberOfRows
            if selectedRow == notSelected || selectedRow == totalRows - 1 { selectedRow = 0 }
            else { selectedRow++ }
            selectRow(selectedRow)
        }
    }
    
    private func unSelectAll() {
        deselectAll(self)
        selectedRows = NSMutableIndexSet()
    }
    
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
    
    private func deleteRow() {
        
        var lastDeletedRow = notSelected
        let selectedRowArray = Array(selectedRows)
        
        for row in selectedRowArray {
            let shouldDelete = extendedDelegate?.hgtableview(self, shouldDeleteRow: row) ?? false
            if shouldDelete == true {
                selectedRows.removeIndex(row)
                extendedDelegate?.hgtableview(self, willDeleteRow: row)
                self.removeRowsAtIndexes(NSIndexSet(index: row), withAnimation: [.EffectNone])
                lastDeletedRow = row
            }
        }
        
        // We are checking if no rows left or nothing was deleted and selecting row appropriately
        var nr = min(numberOfRows - 1, lastDeletedRow - 1)
        if nr == -1 || nr == -100 { nr = notSelected }
        selectRow(nr)
    }
    
}