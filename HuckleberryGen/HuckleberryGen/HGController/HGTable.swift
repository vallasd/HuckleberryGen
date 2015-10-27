//
//  HGTable.swift
//  HuckleberryGen
//
//  Created by David Vallas on 9/1/15.
//  Copyright © 2015 Phoenix Labs. All rights reserved.
//

import Cocoa
import Foundation

/// allows HGTable to display TableView data
protocol HGTableDisplayable: AnyObject {
    /// HGTable holds a weak reference to an NSTableView in order to handle NSTableView datasource and delegate methods internally, pass the tableview you wish to format with HGTable
    func tableview(fortable table: HGTable) -> HGTableView!
    func numberOfRows(fortable table: HGTable) -> Int
    func hgtable(table: HGTable, heightForRow row: Int) -> CGFloat
    func hgtable(table: HGTable, cellForRow row: Int) -> HGCellType
    func hgtable(table: HGTable, dataForRow row: Int) -> HGCellData
}

/// allows HGTable to observe notification and update Table every time notification is sent, if notification passes an Int, will update parentRow to the Int (also passes notSelected, when row was deselected
protocol HGTableObservable: HGTableDisplayable {
    func observeNotification(fortable table: HGTable) -> String
}

/// will post notification every time a new object is selected, will pass the selected row as an Int in the notification's object or notSelected if row was deselected
protocol HGTablePostable: HGTableDisplayable {
    func selectNotification(fortable table: HGTable) -> String
}

/// allows user to select and highlight individual rows on HGTable
protocol HGTableRowSelectable: HGTableDisplayable {
    func hgtable(table: HGTable, shouldSelectRow row: Int) -> Bool
//    func hgtable(table: HGTable, didSelectRow row: Int)
}

/// allows user to edit fields in the HGCell of HGTable
protocol HGTableItemEditable: HGTableDisplayable {
    /// If HGOption is .No, will not attempt to edit HGCellItemType. If HGOption is .Yes, will allow user to Edit Item or Highlight an Image.  If HGOption is .AskUser, will delegate didSelectRowForOption if class conforms to HGTableItemOptionEditable protocol.
    func hgtable(table: HGTable, shouldEditRow row: Int, tag: Int, type: HGCellItemType) -> HGOption
    func hgtable(table: HGTable, didEditRow row: Int, tag: Int, withData data: HGCellItemData)
}

/////// allows user to edit items in the HGCell of HGTable by calling another HGTable that will give selection choices for user, overrides HGTableEditable protocol when necessary
protocol HGTableItemOptionable: HGTableItemEditable {
    func hgtable(table: HGTable, didSelectRowForOption row: Int, tag: Int, type: HGCellItemType)
}

/// allows user to add and delete rows in HGTable
protocol HGTableRowAppendable: HGTableDisplayable {
    func hgtable(shouldAddRowToTable table: HGTable) -> Bool
    func hgtable(willAddRowToTable table: HGTable)
    func hgtable(table: HGTable, shouldDeleteRow row: Int) -> HGOption
    func hgtable(table: HGTable, willDeleteRow row: Int)
}

/// HGTable is a custom class that is the NSTableViewDataSource and NSTableViewDelegate delegate for an NSTableView.  This class works with HGCell to provide generic cell templates to NSTableView. This class provides a custom interface for NSTableView so that: HGCell fields can be edited, User warnings / feedback Pop-ups display, Option Selection Pop-ups display, KeyBoard commands will work.  The user can fine tune the HGTable by determining which of the many protocols in the class that they choose to implement.

class HGTable: NSObject, NSTableViewDataSource, NSTableViewDelegate, HGCellDelegate, HGTableViewDelegate {
    
    // MARK: Public Delegates
    
    private(set) var selectedLocations: [HGCellLocation] = []
    private(set) var parentRow: Int = notSelected
    
    /// metadelegate will set all other delegates for HGTable if the delegate class conforms to the specific protocol, if you have multiple HGTables in your class, you may also individually assign delegates as needed
    weak var delegate: HGTableDisplayable? {
        didSet {
            displayDelegate = delegate
            if let d = delegate as? HGTableObservable { observeDelegate = d }
            if let d = delegate as? HGTablePostable { selectDelegate = d }
            if let d = delegate as? HGTableRowSelectable { rowSelectDelegate = d }
            if let d = delegate as? HGTableItemEditable { itemEditDelegate = d }
            if let d = delegate as? HGTableItemOptionable { itemOptionDelegate = d }
            if let d = delegate as? HGTableRowAppendable { rowAppenedDelegate = d }
        }
    }
    
    private weak var displayDelegate: HGTableDisplayable? {
        didSet {
            tableview = displayDelegate?.tableview(fortable: self)
        }
    }
    
    private weak var observeDelegate: HGTableObservable? {
        willSet {
            HGNotif.shared.removeObserver(self)
        }
        didSet {
            addObserver(observeDelegate?.observeNotification(fortable: self))
        }
    }
    
    private weak var selectDelegate: HGTablePostable? {
        didSet {
            selectNotification = selectDelegate?.selectNotification(fortable: self) ?? nil
        }
    }
    
    private weak var rowSelectDelegate: HGTableRowSelectable?
    private weak var itemEditDelegate: HGTableItemEditable?
    private weak var itemOptionDelegate: HGTableItemOptionable?
    private weak var rowAppenedDelegate: HGTableRowAppendable?
    
    private var tableCellIdentifiers: [TableCellIdentifier] = []
    
    private weak var lastImageCell: HGCell?
    private var selectNotification: String?
    
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

    // MARK: TableViews
    
    /// NSTableView used for and given by displayDelegate
    private weak var tableview: NSTableView! {
        didSet {
            tableview.identifier = "MainTableView"
            tableview.setDelegate(self)
            tableview.setDataSource(self)
            if let tableview = tableview as? HGTableView {
                tableview.extendedDelegate = self
            }
        }
    }

    // MARK: NSTableViewDataSource
    
    func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        let rows = displayDelegate?.numberOfRows(fortable: self) ?? 0
        return rows
    }
    
    // MARK: NSTableViewDelegate
    
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
    
    // MARK: HGTableViewDelegate
    
    func hgtableview(hgtableview: HGTableView, shouldSelectRow row: Int) -> Bool {
        return rowSelectDelegate?.hgtable(self, shouldSelectRow: row) ?? false
    }
    
    func hgtableview(shouldAddRowToTable hgtableview: HGTableView) -> Bool {
        return rowAppenedDelegate?.hgtable(shouldAddRowToTable: self) ?? false
    }
    
    func hgtableview(hgtableview: HGTableView, shouldDeleteRow row: Int) -> Bool {
        let answer = rowAppenedDelegate?.hgtable(self, shouldDeleteRow: row)
    
        return answer == .No ? false : true
    }
    
    func hgtableview(hgtableview: HGTableView, didSelectRow row: Int) {
        selectedLocations = HGCellLocation.locations(fromIndexSet: hgtableview.selectedRows)
//        rowSelectDelegate?.hgtable(self, didSelectRow: row)
        if let sn = selectNotification { HGNotif.shared.postNotification(sn, withObject: row) }
    }
    
    func hgtableview(willAddRowToTable hgtableview: HGTableView) {
        rowAppenedDelegate?.hgtable(willAddRowToTable: self)
    }
    
    func hgtableview(hgtableview: HGTableView, willDeleteRow row: Int) {
        rowAppenedDelegate?.hgtable(self, willDeleteRow: row)
    }
    
    // MARK: HGCellDelegate
    
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
            let location = HGCellLocation(row: cell.row, identifier: identifier)
            
            if type == .Image {
                // highlight / unhighlight images
                lastImageCell?.unselectImages()
                lastImageCell = cell
                let locationChanged = selectedLocations.contains(location) ? false : true
                if locationChanged { cell.select(imagetag: tag) }
            }
            
            selectedLocations = [location]
        }
        
        if shouldEdit == .AskUser {
            itemOptionDelegate?.hgtable(self, didSelectRowForOption: cell.row, tag: tag, type: type)
        }
    }
    
    func hgcell(cell: HGCell, didEditTag tag: Int, withData data: HGCellItemData) {
        itemEditDelegate?.hgtable(self, didEditRow: cell.row, tag: tag, withData: data)
    }
    
    // MARK: Nib Loading Controls
    
    /// Registers HGCell's Nib with TableView and Stores a
    private func register(cellType: HGCellType, forTableView tableView: NSTableView) {
        let tci = TableCellIdentifier(tableId: tableView.identifier, cellId: cellType.identifier)
        if tableCellIdentifiers.contains(tci) { return }
        let nib = NSNib(nibNamed: cellType.identifier, bundle: nil)
        tableView.registerNib(nib, forIdentifier: cellType.identifier)
        tableCellIdentifiers.append(tci)
    }
    
    // MARK: Observations of Notifications

    private func addObserver(name: String?) {
        if let name = name {
            HGNotif.shared.addObserverForName(name, usingBlock: { [weak self] (notif) -> Void in
                if let row = notif.object as? Int { self?.parentRow = row }
                self?.update()
            })
        }
    }
    
    deinit {
        HGNotif.shared.removeObserver(self)
    }
    
}
