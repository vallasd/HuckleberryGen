//
//  TableSelectionBoard.swift
//  HuckleberryGen
//
//  Created by David Vallas on 9/3/15.
//  Copyright © 2015 Phoenix Labs. All rights reserved.
//

import Cocoa

/// types of datasource that the Selection Board can handle
enum SelectionBoardType {
    case Row
    case Image
}

/// Selection Board Protocol that
protocol SelectionBoardDelegate: AnyObject {
    func hgcellType(forSelectionBoard sb: SelectionBoard) -> HGCellType
    func selectionboard(sb: SelectionBoard, didChoose items: [Int])
    func numberOfItems(forSelectionBoard sb: SelectionBoard) -> Int
}

/// Use this protocol for the datasource if you plan to treat each Row as an Option
protocol SelectionBoardRowSource: SelectionBoardDelegate {
    func selectionboard(sb: SelectionBoard, dataForRow row: Int) -> HGCellData
}

/// Use this protocol for the datasource if you plan to treat each Image on the Row as an Option
protocol SelectionBoardImageSource: SelectionBoardDelegate {
    func selectionboard(sb: SelectionBoard, imageDataForIndex index: Int) -> HGImageData
}

class SelectionBoard: NSViewController, NavControllerReferrable {
    
    @IBOutlet weak var boardtitle: NSTextField!
    @IBOutlet weak var tableview: HGTableView!
    
    /// NavControllerReferrable
    var nav: NavController?
    
    /// type of datasource that the Selection Board is.  Set when user assigns the delegate.
    private(set) var boardtype: SelectionBoardType = .Row
    
    private(set) var parentTable: HGTable?
    
    /// delegate which conforms to SelectionBoardDelegate protocol.  Also use SelectionBoardDataSource or SelectionBoardImageSource in conjunction with this protocol in order to supply data for the cells
    weak var boardDelegate: SelectionBoardDelegate? {
        didSet {
            hgcellType = boardDelegate?.hgcellType(forSelectionBoard: self) ?? HGCellType.DefaultCell
        }
    }
    
    /// delegate which conforms to SelectionBoardDataSource protocol.  Allows user to choose the entire row as an item.
    weak var rowSource: SelectionBoardRowSource? {
        didSet {
            boardtype = .Row
            hgtable.update()
        }
    }
    
    /// delegate which conforms to SelectionBoardImageSource protocol.  Allows user to choose individual images on row  as an item.
    weak var imageSource: SelectionBoardImageSource? {
        didSet {
            boardtype = .Image
            hgtable.update()
        }
    }
    
    private let hgtable: HGTable = HGTable()
    private(set) var hgcellType: HGCellType!
    private(set) var numberOfItems: Int = 0
    
    // MARK: Public Methods
    
    /// Refreshes the data in the table
    func update() {
        hgtable.update()
    }
    
    /// Instantiates and presents the Selection Board to screen from another table
    static func present(withParentTable table: HGTable?) -> SelectionBoard {
        if let handler = table?.boardHandler {
            handler.startBoard(BoardType.Selection)
            let selectionBoard = handler.nav!.currentVC as! SelectionBoard
            //selectionBoard.parentTable = table
            return selectionBoard
        }
        
        HGReportHandler.report("SelectionBoard unable to find boardHandler in HGTable's window", response: .Error)
        return BoardType.Selection.create() as! SelectionBoard // returns a blank selection board
    }
    
    /// Instantiates and presents the Selection Board to screen from another table
    static func present(onViewController viewcontroller: NSViewController) -> SelectionBoard {
        
        let selectionBoard = BoardType.Selection.create() as! SelectionBoard
        viewcontroller.view.addSubview(selectionBoard.view)
        return selectionBoard
    }
    
    // MARK: View LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hgtable.delegate = self
        nav?.disableProgression()
    }
    
    /// Returns the selected choice (if any) to the SelectionBoardDelegate
    override func viewWillDisappear() {
        super.viewWillDisappear()
        
        // exit rest of function if last button pressed in nav was back or cancel
        let lbt = nav?.lastButtonPressed
        if lbt == .Cancel || lbt == .Back { return }
        
        // send did choose option to delegate
        let indexes = hgcellType.selectedIndexes(forlocations: hgtable.selectedLocations)
        boardDelegate?.selectionboard(self, didChoose: indexes)
        parentTable?.update()
    }
    
    private func updateProgression() {
        if hgtable.selectedLocations.count > 0 { nav?.enableProgression() }
        else { nav?.disableProgression() }
    }
    
}

extension SelectionBoard: NavControllerPushable {
    
    var nextBoard: BoardType? { return nil }
    
}

// MARK: HGTableDisplayable
extension SelectionBoard: HGTableDisplayable {
    
    func tableview(fortable table: HGTable) -> HGTableView! {
        return tableview
    }
    
    func numberOfRows(fortable table: HGTable) -> Int {
        numberOfItems = boardDelegate?.numberOfItems(forSelectionBoard: self) ?? 0
        if boardtype == .Image {
            let rows = hgcellType.imageSourceNumberOfRows(forImageItems: numberOfItems)
            return rows
        }
        return numberOfItems
    }
    
    func hgtable(table: HGTable, heightForRow row: Int) -> CGFloat {
        return hgcellType.rowHeightForTable(tableview)
    }
    
    func hgtable(table: HGTable, cellForRow row: Int) -> HGCellType {
        return hgcellType
    }
    
    func hgtable(table: HGTable, dataForRow row: Int) -> HGCellData {
        if boardtype == .Image {
            return hgcellType.imageSourceCellData(sb: self, row: row)
        }
        return rowSource?.selectionboard(self, dataForRow: row) ?? HGCellData.empty
    }
}

extension SelectionBoard: HGTableTrackable {
    
    func hgtableSelectedLocationsChanged(table: HGTable) {
        updateProgression()
    }
}


// MARK: HGTableRowSelectable
extension SelectionBoard: HGTableRowSelectable {

    func hgtable(table: HGTable, shouldSelectRow row: Int) -> Bool {
        if boardtype == .Image {
            return false
        }
        return true
    }
    
}

// MARK: HGTableItemEditable
extension SelectionBoard: HGTableItemEditable {
    
    func hgtable(table: HGTable, shouldEditRow row: Int, tag: Int, type: HGCellItemType) -> HGOption {
        if boardtype == .Image {
            return .Yes
        }
        return .No
    }
    
    func hgtable(table: HGTable, didEditRow row: Int, tag: Int, withData data: HGCellItemData) {
        // DO NOTHING
    }
}

