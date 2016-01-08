//
//  HGTable.swift
//  HuckleberryGen
//
//  Created by David Vallas on 9/1/15.
//  Copyright © 2015 Phoenix Labs. All rights reserved.
//

import Cocoa
import Foundation

/// Protocol that allows HGTable to display data in rows.
protocol HGTableDisplayable: AnyObject {
    /// Pass the tableview you wish to format with HGTable.  HGTable holds a weak reference to an HGTableView in order to handle NSTableView datasource and delegate methods internally.
    func tableview(fortable table: HGTable) -> HGTableView!
    /// Pass the number of records managed for HGTable by the data source object.
    func numberOfRows(fortable table: HGTable) -> Int
    /// Pass the height of a specific row in the HGTableView.
    func hgtable(table: HGTable, heightForRow row: Int) -> CGFloat
    /// Pass the HGCellType for a specific row in the HGTable
    func hgtable(table: HGTable, cellForRow row: Int) -> HGCellType
    /// Pass the HGCellData for a specific row in the HGTable.  The data will be used to populate the cell appropriately.
    func hgtable(table: HGTable, dataForRow row: Int) -> HGCellData
}

/// Protocol that allows HGTable to observe notification and reload Table when a notification is sent.
protocol HGTableObservable: HGTableDisplayable {
    /// Pass the notification name that the HGTable should observe, table will reload data when the notification is observed.
    func observeNotification(fortable table: HGTable) -> String
}

/// Protocol that allows user to select and highlight individual rows on HGTable.
protocol HGTableRowSelectable: HGTableDisplayable {
    // Pass Boolean value to inform HGTable whether row should be selectable
    func hgtable(table: HGTable, shouldSelectRow row: Int) -> Bool
}

/// Protocol that allows user to track when selected locations change
protocol HGTableTrackable: HGTableDisplayable {
    // called everytime
    func hgtableSelectedLocationsChanged(table: HGTable)
}

/// Protocol that allows user to select and highlight individual rows on HGTable.
protocol HGTableRowTouchable: HGTableDisplayable {
    // Pass Boolean value to inform HGTable whether row should be selectable
    func hgtable(table: HGTable, shouldSelectRow row: Int) -> Bool
}

/// Protocol that allows HGTable to post a notification every time a new object is selected, will pass the selected row as an Int in the notification's object or notSelected if row was deselected
protocol HGTablePostable: HGTableRowSelectable {
    /// Pass the notification name that the HGTable should POST when a new row is selected.
    func selectNotification(fortable table: HGTable) -> String
}

/// Protocol that allows user to edit fields of the HGCell in an HGTable
protocol HGTableItemEditable: HGTableDisplayable {
    /// If HGOption is .No, will not attempt to edit HGCellItemType. If HGOption is .Yes, will allow user to Edit Item or Highlight an Image.  If HGOption is .AskUser, will delegate didSelectRowForOption if class conforms to HGTableItemOptionEditable protocol.
    func hgtable(table: HGTable, shouldEditRow row: Int, tag: Int, type: HGCellItemType) -> HGOption
    func hgtable(table: HGTable, didEditRow row: Int, tag: Int, withData data: HGCellItemData)
}

/// allows user to edit items in the HGCell of HGTable by calling another HGTable that will give selection choices for user, overrides HGTableEditable protocol when necessary
protocol HGTableItemOptionable: HGTableItemEditable {
    func hgtable(table: HGTable, didSelectRowForOption row: Int, tag: Int, type: HGCellItemType)
}

/// allows user to add and delete rows in HGTable
protocol HGTableRowAppendable: HGTableDisplayable {
    func hgtable(shouldAddRowToTable table: HGTable) -> Bool
    func hgtable(willAddRowToTable table: HGTable)
    func hgtable(table: HGTable, shouldDeleteRows rows: [Int]) -> HGOption
    func hgtable(table: HGTable, willDeleteRows rows: [Int])
}

/// HGTable is a custom class that is the NSTableViewDataSource and NSTableViewDelegate delegate for an NSTableView.  This class works with HGCell to provide generic cell templates to NSTableView . This class provides a custom interface for NSTableView so that: HGCell fields can be edited, User warnings / feedback Pop-ups display, Option Selection Pop-ups display, KeyBoard commands accepted.  The user can fine tune the HGTable by determining which of the many protocols in the class that they choose to implement.  
class HGTable: NSObject {
    
    
    private(set) var parentRow: Int = notSelected
    
    // MARK: HGTable Delegates
    
    /// Meta delegate for HGTable.  If the delegate conforms to any of the protocols used by HGTable, HGTable will call the functions in that delegate. Current protocols used by HGTable are:  HGTableDisplayable, HGTableObservable, HGTablePostable, HGTableRowSelectable, HGTableItemEditable, HGTableItemOptionable, HGTableRowAppendable
    weak var delegate: HGTableDisplayable? {
        didSet {
            displayDelegate = delegate
            if let d = delegate as? HGTableObservable { observeDelegate = d }
            if let d = delegate as? HGTablePostable { selectDelegate = d }
            if let d = delegate as? HGTableRowSelectable { rowSelectDelegate = d }
            if let d = delegate as? HGTableItemEditable { itemEditDelegate = d }
            if let d = delegate as? HGTableItemOptionable { itemOptionDelegate = d }
            if let d = delegate as? HGTableRowAppendable { rowAppenedDelegate = d }
            if let d = delegate as? HGTableTrackable { locationChangedDelegate = d }
        }
    }
    
    /// Delegate for AnyObject which conforms to protocol HGTableDisplayable
    private weak var displayDelegate: HGTableDisplayable? {
        didSet {
            tableview = displayDelegate?.tableview(fortable: self)
        }
    }
    
    /// Delegate for AnyObject which conforms to protocol HGTableObservable
    private weak var observeDelegate: HGTableObservable? {
        willSet {
            HGNotif.removeObserver(self)
        }
        didSet {
            addObserver(observeDelegate?.observeNotification(fortable: self))
        }
    }
    
    /// Delegate for AnyObject which conforms to protocol HGTablePostable
    private weak var selectDelegate: HGTablePostable? {
        didSet {
            selectNotification = selectDelegate?.selectNotification(fortable: self) ?? nil
        }
    }
    
    /// Delegate for AnyObject which conforms to protocol HGTableRowSelectable
    private weak var rowSelectDelegate: HGTableRowSelectable?
    /// Delegate for AnyObject which conforms to protocol HGTableItemEditable
    private weak var itemEditDelegate: HGTableItemEditable?
    /// Delegate for AnyObject which conforms to protocol HGTableItemOptionable
    private weak var itemOptionDelegate: HGTableItemOptionable?
    /// Delegate for AnyObject which conforms to protocol HGTableRowAppendable
    private weak var rowAppenedDelegate: HGTableRowAppendable?
    /// Delegate for AnyObject which conforms to protocol HGTableTrackable
    private weak var locationChangedDelegate: HGTableTrackable?
    
    // MARK: Private Properties
    
    private var tableCellIdentifiers: [TableCellIdentifier] = []
    private var selectNotification: String?
    
    private(set) weak var lastSelectedCellWithTag: HGCell?
    
    /// set of locations that are currently selected on the Table (can be rows or items)
    private(set) var selectedLocations: [HGCellLocation] = [] { didSet { locationChangedDelegate?.hgtableSelectedLocationsChanged(self) } }
    
    
    /// Weak reference to NSTableView.  Holds this reference so it can delegate re
    private weak var tableview: HGTableView! {
        didSet {
            tableview.identifier = "MainTableView"
            tableview.setDelegate(self)
            tableview.setDataSource(self)
            tableview.extendedDelegate = self
        }
    }
    
    /// a reference to the BoardHandler if the window owning the HGTable conforms to the protocol BoardHandlerHolder.  If this exists, we are able to pop-up questions to the user.
    weak var boardHandler: BoardHandler? {
        if let boardHandlerHolder = tableview.window?.windowController as? BoardHandlerHolder {
            return boardHandlerHolder.boardHandler
        }
        return nil
    }
    
    
    // MARK: Public Methods
    
    /// reloads tableView
    func update() {
        // Public Functions will check if tableview is set in case user calls one before setting the delegate
        if (tableview == nil) { return }
        tableview.reloadData()
    }
    
    /// reloads specific row Of tableView
    private func update(row row: Int) {
        if tableview == nil { return }
        tableview.reloadDataForRowIndexes(NSIndexSet(index: row), columnIndexes: NSIndexSet(index: 0))
    }

    // MARK: Cell Nib Loading
    
    /// Registers HGCell's Nib with TableView one time
    private func register(cellType: HGCellType, forTableView tableView: NSTableView) {
        let tci = TableCellIdentifier(tableId: tableView.identifier, cellId: cellType.identifier)
        if tableCellIdentifiers.contains(tci) { return }
        let nib = NSNib(nibNamed: cellType.identifier, bundle: nil)
        tableView.registerNib(nib, forIdentifier: cellType.identifier)
        tableCellIdentifiers.append(tci)
    }
    
    // MARK: Observers
    private func addObserver(name: String?) {
        if let name = name {
            HGNotif.addObserverForName(name, usingBlock: { [weak self] (notif) -> Void in
                if let row = notif.object as? Int {
                    self?.parentRow = row
                }
                self?.update()
            })
        }
    }
    
    /// displays a decisionBoard if window is a 
    
    // MARK: Deinit
    deinit {
        HGNotif.removeObserver(self)
    }
}

// MARK: NSTableViewDataSource
extension HGTable: NSTableViewDataSource {
    
    func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        let rows = displayDelegate?.numberOfRows(fortable: self) ?? 0
        return rows
    }
    
}

// MARK: NSTableViewDelegate
extension HGTable: NSTableViewDelegate {
    
    func tableView(tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return displayDelegate?.hgtable(self, heightForRow: row) ?? 50.0
    }
    
    func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let cellType = displayDelegate?.hgtable(self, cellForRow: row) ?? .DefaultCell
        register(cellType, forTableView: tableView)
        let cell = tableView.makeViewWithIdentifier(cellType.identifier, owner: self) as! HGCell
        if cell.delegate == nil { cell.delegate = self }
        let data = displayDelegate?.hgtable(self, dataForRow: row) ?? HGCellData.empty
        cell.update(withRow: row, cellData: data)
        return cell
    }
}

// MARK: HGTableViewDelegate
extension HGTable: HGTableViewDelegate {
    
    func hgtableview(hgtableview: HGTableView, shouldSelectRow row: Int) -> Bool {
        return rowSelectDelegate?.hgtable(self, shouldSelectRow: row) ?? false
    }
    
    func hgtableview(shouldAddRowToTable hgtableview: HGTableView) -> Bool {
        return rowAppenedDelegate?.hgtable(shouldAddRowToTable: self) ?? false
    }
    
    func hgtableviewShouldDeleteSelectedRows(hgtableview: HGTableView) -> Bool {
        
        let rows = hgtableview.selectedRows
        let answer = rowAppenedDelegate?.hgtable(self, shouldDeleteRows: rows)
        
        if answer == .AskUser {
            if let boardhandler = boardHandler {
                boardhandler.startBoard(BoardType.Decision)
                let decisionBoard = boardhandler.nav!.currentVC as! DecisionBoard
                if rows.count > 1 {
                    decisionBoard.question.stringValue = "Do you really want to delete \(rows.count) rows?"
                } else {
                    decisionBoard.question.stringValue = "Do you really want to delete the row?"
                }
                
                decisionBoard.delegate = self
                return false
            }
            HGReportHandler.report("HGTable \(self) unable to present Decision board because unable to determine boardHandler from window", response: .Error)
        }
        
        return answer == .No ? false : true
    }
    
    func hgtableview(hgtableview: HGTableView, didSelectRow row: Int) {
        selectedLocations = HGCellLocation.locations(fromRows: hgtableview.selectedRows)
        if let sn = selectNotification { HGNotif.postNotification(sn, withObject: row) }
    }
    
    func hgtableview(willAddRowToTable hgtableview: HGTableView) {
        rowAppenedDelegate?.hgtable(willAddRowToTable: self)
    }
    
    func hgtableview(hgtableview: HGTableView, willDeleteRows rows: [Int]) {
        rowAppenedDelegate?.hgtable(self, willDeleteRows: rows)
    }
    
}

// MARK: HGCellDelegate
extension HGTable: HGCellDelegate {
    
    func hgcell(cell: HGCell, shouldSelectTag tag: Int, type: HGCellItemType) -> Bool {
        let shouldEdit = itemEditDelegate?.hgtable(self, shouldEditRow: cell.row, tag: tag, type: type) ?? .No
        return shouldEdit == .No ? false : true
    }
    
    func hgcell(cell: HGCell, shouldEditTag tag: Int, type: HGCellItemType) -> Bool {
        let shouldEdit = itemEditDelegate?.hgtable(self, shouldEditRow: cell.row, tag: tag, type: type) ?? .No
        return shouldEdit == .Yes ? true : false
    }
    
    func hgcell(cell: HGCell, didSelectTag tag: Int, type: HGCellItemType) {
        
        let shouldEdit = itemEditDelegate?.hgtable(self, shouldEditRow: cell.row, tag: tag, type: type) ?? .No
        
        if shouldEdit == .Yes {
            let identifier = HGCellItemIdentifier(tag: tag, type: type)
            let newLocation = HGCellLocation(row: cell.row, identifier: identifier)
            var unselected = false
            
            if type == .Image {
                
                let locationAlreadySelected = selectedLocations.contains(newLocation) ? true : false
                
                // We already have selected the location before.  Need to unselect.
                if locationAlreadySelected == true {
                    cell.unselect(imagetag: tag)
                    unselected = true
                }
                
                // Another image was selected.  We need to unselect the last cell's images and select the new field.
                else  {
                    lastSelectedCellWithTag?.unselectImages()
                    cell.select(imagetag: tag)
                }
            }
            
            // Either remove lastSelectedCell and selectedLocations if unselected, else add the new locations
            if unselected {
                lastSelectedCellWithTag = nil
                selectedLocations = []
            } else {
                lastSelectedCellWithTag = cell
                selectedLocations = [newLocation]
            }
        }
        
        if shouldEdit == .AskUser {
            itemOptionDelegate?.hgtable(self, didSelectRowForOption: cell.row, tag: tag, type: type)
        }
    }
    
    func hgcell(cell: HGCell, didEditTag tag: Int, withData data: HGCellItemData) {
        itemEditDelegate?.hgtable(self, didEditRow: cell.row, tag: tag, withData: data)
    }
    
}

extension HGTable: DecisionBoardDelegate {
    
    func decisionBoard(db db: DecisionBoard, selected: Bool) {
        
        if selected == true {
            tableview.delete(rows: tableview.selectedRows)
        }
    }
    
}

