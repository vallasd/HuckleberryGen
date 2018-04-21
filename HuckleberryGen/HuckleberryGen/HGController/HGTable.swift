//
//  HGTable.swift
//  HuckleberryGen
//
//  Created by David Vallas on 9/1/15.
//  Copyright © 2015 Phoenix Labs.
//
//  All Rights Reserved.

import Cocoa
import Foundation

/// protocol that allows user to track when selected locations change.  This is designed to be used by a secondary delegate to track changes made to the table.
protocol HGTableSelectionTrackable: AnyObject {
    func hgtableSelectedLocationsChanged(_ table: HGTable)
}

/// protocol that allows HGTable to display data in rows.
protocol HGTableDisplayable: AnyObject {
    func numberOfRows(fortable table: HGTable) -> Int
    /// Pass the height of a specific row in the HGTableView.
    func hgtable(_ table: HGTable, heightForRow row: Int) -> CGFloat
    /// Pass the CellType for a specific row in the HGTable
    func hgtable(_ table: HGTable, cellForRow row: Int) -> CellType
    /// Pass the HGCellData for a specific row in the HGTable.  The data will be used to populate the cell appropriately.
    func hgtable(_ table: HGTable, dataForRow row: Int) -> HGCellData
}

/// protocol that allows HGTable to observe notification and reload Table when a notification is sent.
protocol HGTableObservable: HGTableDisplayable {
    /// Pass the notification name that the HGTable should observe, table will reload data when the notification is observed.
    func observeNotifications(fortable table: HGTable) -> [String]
}

/// protocol that allows user to select and highlight individual rows on HGTable.
protocol HGTableRowSelectable: HGTableDisplayable {
    // Pass Boolean value to inform HGTable whether row should be selectable
    func hgtable(_ table: HGTable, shouldSelectRow row: Int) -> Bool
}

/// protocol that allows user to select and highlight individual rows on HGTable.
protocol HGTableRowTouchable: HGTableDisplayable {
    // Pass Boolean value to inform HGTable whether row should be selectable
    func hgtable(_ table: HGTable, shouldSelectRow row: Int) -> Bool
}

/// protocol that allows HGTable to post a notification every time a new object is selected, will pass the selected row as an Int in the notification's object or notSelected if row was deselected
protocol HGTablePostable: HGTableRowSelectable {
    /// Pass the notification name that the HGTable should POST when a new row is selected.
    func selectNotification(fortable table: HGTable) -> String
}

/// protocol that allows user to select types of the HGCell in an HGTable
protocol HGTableItemSelectable: HGTableDisplayable {
    func hgtable(_ table: HGTable, shouldSelect row: Int, tag: Int, type: CellItemType) -> Bool
    func hgtable(_ table: HGTable, didSelectRow row: Int, tag: Int, type: CellItemType)
}

/// protocol that allows user to edit fields of the HGCell in an HGTable
protocol HGTableFieldEditable: HGTableDisplayable {
    func hgtable(_ table: HGTable, shouldEditRow row: Int, field: Int) -> Bool
    func hgtable(_ table: HGTable, didEditRow row: Int, field: Int, withString string: String)
}

/// allows user to add and delete rows in HGTable.  Handles the table updates within HGTable, as long as Delegate updates the Datasource.
protocol HGTableRowAppendable: HGTableDisplayable {
    func hgtable(shouldAddRowToTable table: HGTable) -> Bool
    func hgtable(willAddRowToTable table: HGTable)
    func hgtable(_ table: HGTable, shouldDeleteRows rows: [Int]) -> Option
    func hgtable(_ table: HGTable, willDeleteRows rows: [Int])
}

/// HGTable is a custom class that is the NSTableViewDataSource and NSTableViewDelegate delegate for an NSTableView.  This class works with HGCell to provide generic cell templates to NSTableView . This class provides a custom interface for NSTableView so that: HGCell fields can be edited, User warnings / feedback Pop-ups display, Option Selection Pop-ups display, KeyBoard commands accepted.  The user can fine tune the HGTable by determining which of the many protocols in the class that they choose to implement.  To Properly use this class, set the delegates then the HGTableView
class HGTable: NSObject {
    
   
    /// initialize with a NSTableView
    init(tableview: NSTableView, delegate: HGTableDisplayable) {
        super.init()
        updateSubDelegates(withSuperDelegate: delegate)
        updateTableView(withTableView: tableview)
        addProjectChangedObserver()
    }
    
    /// initialize with a NSTableView
    init(tableview: NSTableView, delegate: HGTableDisplayable, selectionDelegate: HGTableSelectionTrackable) {
        super.init()
        updateSubDelegates(withSuperDelegate: delegate)
        updateTableView(withTableView: tableview)
        self.selectionDelegate = selectionDelegate
        addProjectChangedObserver()
    }
    
    func updateSubDelegates(withSuperDelegate delegate: HGTableDisplayable) {
        displayDelegate = delegate
        if let d = delegate as? HGTableObservable { observeDelegate = d }
        if let d = delegate as? HGTablePostable { selectDelegate = d }
        if let d = delegate as? HGTableRowSelectable { rowSelectDelegate = d }
        if let d = delegate as? HGTableItemSelectable { itemSelectDelegate = d }
        if let d = delegate as? HGTableFieldEditable { fieldEditDelegate = d }
        if let d = delegate as? HGTableRowAppendable { rowAppenedDelegate = d }
    }
    
    func updateTableView(withTableView tv: NSTableView) {
        tableview = tv
        tableview.identifier = NSUserInterfaceItemIdentifier(rawValue: String.random(7))
        tableview.delegate = self
        tableview.dataSource = self
        
        // we check if the tableview is an HGTableView and if so, we assign the delegate
        if let hgtv = tableview as? HGTableView {
            hgtv.extendedDelegate = self
        }
    }
    
    fileprivate(set) var parentRow: Int = notSelected
    
    // MARK: HGTable Delegates
    
    /// Delegate for AnyObject which conforms to protocol HGTableTrackable
    fileprivate weak var selectionDelegate: HGTableSelectionTrackable?
    
    /// weak reference to the NSTableView
    fileprivate weak var tableview: NSTableView!
    
    /// Delegate for AnyObject which conforms to protocol HGTableObservable
    fileprivate weak var observeDelegate: HGTableObservable? {
        willSet {
            HGNotif.removeObserver(self)
        }
        didSet {
            addProjectChangedObserver()
            let names = observeDelegate!.observeNotifications(fortable: self)
            addObservers(withNotifNames: names)
        }
    }
    
    /// Delegate for AnyObject which conforms to protocol HGTablePostable
    fileprivate weak var selectDelegate: HGTablePostable? {
        didSet {
            selectNotification = selectDelegate?.selectNotification(fortable: self) ?? nil
        }
    }
    
    /// Delegate for AnyObject which conforms to protocol HGTableDisplayable
    fileprivate weak var displayDelegate: HGTableDisplayable?
    /// Delegate for AnyObject which conforms to protocol HGTableRowSelectable
    fileprivate weak var rowSelectDelegate: HGTableRowSelectable?
    /// Delegate for AnyObject which conforms to protocol HGTableItemEditable
    fileprivate weak var itemSelectDelegate: HGTableItemSelectable?
    /// Delegate for AnyObject which conforms to protocol HGTableItemEditable
    fileprivate weak var fieldEditDelegate: HGTableFieldEditable?
    /// Delegate for AnyObject which conforms to protocol HGTableRowAppendable
    fileprivate weak var rowAppenedDelegate: HGTableRowAppendable?
    
    // MARK: Private Properties
    
    fileprivate var tableCellIdentifiers: [TableCellIdentifier] = []
    fileprivate var selectNotification: String?
    
    fileprivate(set) weak var lastSelectedCellWithTag: HGCell?
    
    /// set of locations that are currently selected on the Table (can be rows or items)
    fileprivate(set) var selectedLocations: [HGCellLocation] = [] { didSet { selectionDelegate?.hgtableSelectedLocationsChanged(self) } }
    
    // MARK: Public Methods
    
    /// reloads tableView
    func update() {
        tableview.reloadData()
    }
    
    /// reloads specific row Of tableView
    fileprivate func update(row: Int) {

        // TODO: Implement - Need to get cell and then call delegate to get HGCellData then update cell with data
    }

    // MARK: Cell Nib Loading
    
    /// Registers HGCell's Nib with TableView one time
    fileprivate func register(_ cellType: CellType, forTableView tableView: NSTableView) {
        let tci = TableCellIdentifier(tableId: tableView.identifier.map { $0.rawValue }, cellId: cellType.identifier)
        if tableCellIdentifiers.contains(tci) { return }
        let nib = NSNib(nibNamed: NSNib.Name(rawValue: cellType.identifier), bundle: nil)
        tableView.register(nib, forIdentifier: NSUserInterfaceItemIdentifier(rawValue: cellType.identifier))
        tableCellIdentifiers.append(tci)
    }
    
    // MARK: Observers
    fileprivate func addObservers(withNotifNames names: [String]) {
        
        for name in names {
            HGNotif.addObserverForName(name, usingBlock: { [weak self] (notif) -> Void in
                if let row = notif.object as? Int {
                    self?.parentRow = row
                }
                self?.update()
                })
        }
    }
    
    fileprivate func addProjectChangedObserver() {
        
        let uniqueID = appDelegate.store.uniqIdentifier
        let notifType = HGNotifType.projectChanged
        let notifName = notifType.uniqString(forUniqId: uniqueID)
        
        HGNotif.addObserverForName(notifName, usingBlock: { [weak self] (notif) -> Void in
            self?.parentRow = notSelected
            self?.update()
            })
    }
    
    // MARK: Deinit
    deinit {
        HGNotif.removeObserver(self)
    }
}

// MARK: NSTableViewDataSource
extension HGTable: NSTableViewDataSource {
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        let rows = displayDelegate?.numberOfRows(fortable: self) ?? 0
        return rows
    }
    
}

// MARK: NSTableViewDelegate
extension HGTable: NSTableViewDelegate {
    
    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return displayDelegate?.hgtable(self, heightForRow: row) ?? 50.0
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let cellType = displayDelegate?.hgtable(self, cellForRow: row) ?? .defaultCell
        register(cellType, forTableView: tableView)
        let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: cellType.identifier), owner: self) as! HGCell
        if cell.delegate == nil { cell.delegate = self }
        let data = displayDelegate?.hgtable(self, dataForRow: row) ?? HGCellData.empty
        cell.update(withRow: row, cellData: data)
        return cell
    }
}

// MARK: HGTableViewDelegate
extension HGTable: HGTableViewDelegate {
    
    func hgtableview(_ hgtableview: HGTableView, shouldSelectRow row: Int) -> Bool {
        return rowSelectDelegate?.hgtable(self, shouldSelectRow: row) ?? false
    }
    
    func hgtableview(shouldAddRowToTable hgtableview: HGTableView) -> Bool {
        return rowAppenedDelegate?.hgtable(shouldAddRowToTable: self) ?? false
    }
    
    func hgtableviewShouldDeleteSelectedRows(_ hgtableview: HGTableView) -> Bool {
        
        let rows = hgtableview.selectedRows
        let answer = rowAppenedDelegate?.hgtable(self, shouldDeleteRows: rows) ?? .no
        
        // if we are asking user, produce a Decision Board for Delete Rows
        if answer == .askUser {
            let context = DBD_DeleteRows(tableview: hgtableview, rowsToDelete: rows)
            let boardData = DecisionBoard.boardData(withContext: context)
            appDelegate.mainWindowController.boardHandler.start(withBoardData: boardData)
            return false
        }
        
        return answer == .no ? false : true
    }
    
    func hgtableview(_ hgtableview: HGTableView, didSelectRow row: Int) {
        selectedLocations = HGCellLocation.locations(fromRows: hgtableview.selectedRows)
        if let sn = selectNotification { HGNotif.postNotification(sn, withObject: row as AnyObject) }
    }
    
    func hgtableview(willAddRowToTable hgtableview: HGTableView) {
        rowAppenedDelegate?.hgtable(willAddRowToTable: self)
    }
    
    func hgtableview(_ hgtableview: HGTableView, willDeleteRows rows: [Int]) {
        rowAppenedDelegate?.hgtable(self, willDeleteRows: rows)
    }
    
    func hgtableview(_ hgtableview: HGTableView, didDeleteRows rows: [Int]) {
        let row = notSelected
        if let sn = selectNotification { HGNotif.postNotification(sn, withObject: row as AnyObject) }
    }
    
}

// MARK: HGCellDelegate
extension HGTable: HGCellDelegate {
    
    func hgcell(_ cell: HGCell, shouldSelectTag tag: Int, type: CellItemType) -> Bool {
        return itemSelectDelegate?.hgtable(self, shouldSelect: cell.row, tag: tag, type: type) ?? false
    }
    
    func hgcell(_ cell: HGCell, didSelectTag tag: Int, type: CellItemType) {
        
        let identifier = HGCellItemIdentifier(tag: tag, type: type)
        let newLocation = HGCellLocation(row: cell.row, identifier: identifier)
        var unselected = false
        
        if type == .image {
            
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
        
        itemSelectDelegate?.hgtable(self, didSelectRow: cell.row, tag: tag, type: type)
    }
    
    func hgcell(_ cell: HGCell, shouldEditField field: Int) -> Bool {
        return fieldEditDelegate?.hgtable(self, shouldEditRow: cell.row, field: field) ?? false
    }
    
    func hgcell(_ cell: HGCell, didEditField field: Int, withString string: String) {
        fieldEditDelegate?.hgtable(self, didEditRow: cell.row, field: field, withString: string)
    }
    
}
