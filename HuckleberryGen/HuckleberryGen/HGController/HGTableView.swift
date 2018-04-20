//
//  HGTableView.swift
//  HuckleberryGen
//
//  Created by David Vallas on 9/28/15.
//  Copyright © 2015 Phoenix Labs.
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

import Cocoa

let notSelected: Int = -99

protocol HGTableViewDelegate: NSTableViewDelegate {
    func hgtableview(_ hgtableview: HGTableView, shouldSelectRow row: Int) -> Bool
    func hgtableview(shouldAddRowToTable hgtableview: HGTableView) -> Bool
    func hgtableviewShouldDeleteSelectedRows(_ hgtableview: HGTableView) -> Bool
    func hgtableview(_ hgtableview: HGTableView, didSelectRow row: Int)
    func hgtableview(willAddRowToTable hgtableview: HGTableView)
    func hgtableview(_ hgtableview: HGTableView, willDeleteRows rows: [Int])
    func hgtableview(_ hgtableview: HGTableView, didDeleteRows rows: [Int])
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
    fileprivate var iSelectedRows: NSMutableIndexSet = NSMutableIndexSet()
    
    /// Extended delegate that conforms to protocol HGTableViewDelegate
    var extendedDelegate: HGTableViewDelegate?
    
    /// Deletes rows supplied without conferring with delegate
    func delete(rows: [Int]) {
        
        // return if no rows to delete
        if rows.count == 0 {
            return
        }
        
        // create indexSet from rows
        let indexSet = NSMutableIndexSet()
        for row in rows { indexSet.add(row) }
        
        // notify delegate about impending deletion
        extendedDelegate?.hgtableview(self, willDeleteRows: rows)
        
        // remove indexes from selected rows
        iSelectedRows.remove(indexSet as IndexSet)
        
        // remove rows from self (Tableview)
        self.removeRows(at: indexSet as IndexSet, withAnimation: NSTableViewAnimationOptions())
        
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
        
        // notify delegate that deletion happened
        extendedDelegate?.hgtableview(self, didDeleteRows: rows)
    }
    
    /// custom HGTableView function that handles mouseDown events
    override func mouseDown(with theEvent: NSEvent) {
        
        let global = theEvent.locationInWindow
        let local = self.convert(global, from: nil)
        let row = self.row(at: local)
        
        if (row != notSelected && row != -1) {
            selectRow(row)
        }
    }
    
    /// custom HGTableView function that handles keyDown events
    override func keyDown(with theEvent: NSEvent) {
        let command = theEvent.command()
        switch command {
        case .addRow: addRow()
        case .deleteRow: deleteSelectedRowsIfDelegateSaysOK()
        case .nextRow: selectNext()
        case .previousRow: selectPrev()
        default: break // Do Nothing
        }
    }
    
    /// custom HGTableView function that handles changed flag events such as command button held down
    override func flagsChanged(with theEvent: NSEvent) {
        let options = theEvent.commandOptions()
        if options.contains(HGCommandOptions.MultiSelectOn) {
            allowsMultipleRowSelection = true
        } else {
            allowsMultipleRowSelection = false
        }
    }
    
    /// selects or unselects (if row is currently selected) a row
    fileprivate func selectRow(_ r: Int) {
        
        var row = r
        
        if row != notSelected {
            
            let isSelectableRow = extendedDelegate?.hgtableview(self, shouldSelectRow: row) ?? false
            let isSelectedRow = iSelectedRows.contains(row)
            
            if isSelectedRow {
                iSelectedRows.remove(row)
                row = notSelected
            }
                
            else if isSelectableRow {
                if allowsMultipleRowSelection {
                    iSelectedRows.add(row)
                } else {
                    iSelectedRows = NSMutableIndexSet(integer: row)
                }
            }
        }
        
        extendedDelegate?.hgtableview(self, didSelectRow: row)
        
        // Selects row and then scrolls to it
        OperationQueue.main.addOperation { [weak self] () -> Void in
            self?.selectRowIndexes(self?.iSelectedRows as IndexSet? ?? IndexSet(), byExtendingSelection: false)
            if row != notSelected {
                self?.scrollRowToVisible(row)
            }
        }
    }
    
    /// If allowsMultipleRowSelection == false, will select previous row, if allowsMultipleRowSelection == true will unselect the highest indexed row
    fileprivate func selectPrev() {
        
        var numSelected = iSelectedRows.count
        
        // If we don't have any rows in Table, we return
        if numberOfRows == 0 {
            return
        }
        
        // If we haven't selected anything yet, just select row 0
        if numSelected == 0 {
            selectRow(0)
            return
        }
        
        // determine the rows
        let sort = selectedRows.sorted()
        var lastRow = sort.last!
        let firstRow = sort.first!
        
        // if we only have one row which is first index, we want to exit immediately so we are not toggling selection of row
        if numSelected == 1 && firstRow == 0 {
            return
        }
        
        // unselect the last selected row if we are allowing multiple row selection
        if allowsMultipleRowSelection == true {
            selectRow(lastRow)
        }
        
        // unselect all if we do not allow multiple row selection
        else {
            lastRow = firstRow // since rows are deleted, we want to go with the first row to determine previous row
            unSelectAll()
            numSelected = 0
        }
        
        // if there are multiple rows still selected, we just will remove lastRow and exit
        if numSelected > 1 {
            return
        }
        
        // determine what previous row will be, this is unwrapped because we already checked iSelectedRows.count above
        let previousRow = lastRow - 1
        
        // returns if previous row is out of bounds
        if previousRow < 0 {
            return
        }
        
        // Selects previous row.
        selectRow(previousRow)
    }
    
    /// If allowsMultipleRowSelection == false, will select next row, if allowsMultipleRowSelection == true will add the next highest row to selection
    fileprivate func selectNext() {
        
        let numSelected = iSelectedRows.count
        
        // if we don't have any rows in Table, we return
        if numberOfRows == 0 {
            return
        }
        
        // if we haven't selected anything yet, just select row 0
        if numSelected == 0 {
            selectRow(0)
            return
        }
        
        // determine what next row will be, this is unwrapped because we already checked iSelectedRows.count above
        let nextRow = selectedRows.sorted().last! + 1
        
        // if we are not able to select next row, return
        if nextRow >= numberOfRows {
            return
        }
        
        // select next row.  This will always either add next row or move to next row depending on allowsMultipleRowSelection variable
        selectRow(nextRow)
    }
    
    /// Unselects all rows
    fileprivate func unSelectAll() {
        deselectAll(self)
        iSelectedRows = NSMutableIndexSet()
    }
    
    /// Asks delegate if hgtableview should add row, then adds row if delegate returns true
    fileprivate func addRow() {
        let shouldAdd = extendedDelegate?.hgtableview(shouldAddRowToTable: self) ?? false
        if shouldAdd == true {
            let index = numberOfRows
            unSelectAll()
            extendedDelegate?.hgtableview(willAddRowToTable: self)
            insertRows(at: IndexSet(integer: index), withAnimation: NSTableViewAnimationOptions())
            selectRow(index)
        }
    }
    
    /// Asks delegate if hgtableview should delete rows, then deletes row if delegate returns true
    fileprivate func deleteSelectedRowsIfDelegateSaysOK() {
        
        let shouldDelete = extendedDelegate?.hgtableviewShouldDeleteSelectedRows(self) ?? false
        
        if shouldDelete == true {
            delete(rows: selectedRows)
        }
        
    }
    
    fileprivate class func isTopView(_ view: NSView, previousView: NSView?) -> Bool {
        
        if let superView = view.superview {
            HGTableView.isTopView(superView, previousView: view)
        }
        
        Swift.print("Top View is \(view), Previous View \(previousView)")
        
        Swift.print("Sub Views are \(view.subviews)")
        
        return false
    }
    
}



//        let parentWindow = self.window
//        if let subviews = parentWindow?.contentViewController?.view.subviews {
//            for subview in subviews {
//
//            }
//        }
