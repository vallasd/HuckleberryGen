//
//  TableSelectionBoard.swift
//  HuckleberryGen
//
//  Created by David Vallas on 9/3/15.
//  Copyright © 2015 Phoenix Labs. All rights reserved.
//

import Cocoa

/// Protocol that lets user know when
protocol SelectionBoardDelegate: AnyObject {
    func hgcellType(forSelectionBoard sb: SelectionBoard) -> HGCellType
    func selectionboard(sb: SelectionBoard, didChoose items: [Int])
    func numberOfItems(forSelectionBoard sb: SelectionBoard) -> Int
}

/// Use this protocol for the datasource if you plan to treat each Row as an Option
protocol SelectionBoardDataSource: SelectionBoardDelegate {
    func selectionboard(sb: SelectionBoard, dataForRow row: Int) -> HGCellData
}

/// Use this protocol for the datasource if you plan to treat each Image as an Option, this will override SelectionBoardDataSource if the delegate returns an Array (not nil) to SelectionBoard.  Designed to be used with Cells such as HGCell Image4Cell.
protocol SelectionBoardImageSource: SelectionBoardDelegate {
    func selectionboard(sb: SelectionBoard, imageDataForIndex index: Int) -> HGImageData?
}

class SelectionBoard: NSViewController, HGTableDisplayable, HGTableRowSelectable, HGTableItemEditable {
    
    
    @IBOutlet weak var boardtitle: NSTextField!
    @IBOutlet weak var tableview: HGTableView!
    
    private(set) var parentTable: HGTable?
    
    weak var delegate: SelectionBoardDelegate? {
        didSet {
            boardDelegate = delegate
            if let d = delegate as? SelectionBoardDataSource { boardDataSource = d }
            if let d = delegate as? SelectionBoardImageSource { boardImageSource = d }
         }
    }
    
    weak var boardDelegate: SelectionBoardDelegate? = nil {
        didSet {
            hgcellType = boardDelegate?.hgcellType(forSelectionBoard: self) ?? HGCellType.DefaultCell
        }
    }
    
    weak var boardDataSource: SelectionBoardDataSource? = nil {
        didSet {
            hgtable.update()
        }
    }
    
    weak var boardImageSource: SelectionBoardImageSource? = nil {
        didSet {
            isImageSource = true
            hgtable.update()
        }
    }
    
    private var isImageSource = false
    private let hgtable: HGTable = HGTable()
    private(set) var hgcellType: HGCellType!
    private(set) var numberOfItems: Int = 0
    
    // MARK: Public Methods
    
    func update() {
        hgtable.update()
    }
    
    static func present(withParentTable table: HGTable?) -> SelectionBoard {
        BoardHandler.startBoard(BoardType.Selection, blur: true)
        let selectionBoard = BoardHandler.currentVC as! SelectionBoard
        selectionBoard.parentTable = table
        return selectionBoard
    }
    
    // MARK: HGTableDisplayable
    
    func tableview(fortable table: HGTable) -> HGTableView! {
        return tableview
    }
    
    func numberOfRows(fortable table: HGTable) -> Int {
        numberOfItems = boardDelegate?.numberOfItems(forSelectionBoard: self) ?? 0
        if isImageSource {
            let rows = hgcellType.numberOfRows(forImageItems: numberOfItems)
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
        if isImageSource { return hgcellType.cellData(sb: self, row: row) }
        return boardDataSource?.selectionboard(self, dataForRow: row) ?? HGCellData.empty
    }
    
    // MARK: HGTableRowSelectable
    
    func hgtable(table: HGTable, shouldSelectRow row: Int) -> Bool {
        if isImageSource { return false }
        return true
    }
    
    func hgtable(table: HGTable, didSelectRow row: Int) {
        // DO NOTHING
    }
    
    // MARK: HGTableItemEditable
    
    func hgtable(table: HGTable, shouldEditRow row: Int, tag: Int, type: HGCellItemType) -> HGOption {
        if isImageSource { return .Yes }
        return .No
    }
    
    func hgtable(table: HGTable, didEditRow row: Int, tag: Int, withData data: HGCellItemData) {
        // DO NOTHING
    }
    
    // MARK: View LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hgtable.delegate = self
    }
    
    override func viewWillDisappear() {
        super.viewWillDisappear()
        if hgtable.selectedLocations.count > 0 {
            let indexes = hgcellType.selectedIndexes(forlocations: hgtable.selectedLocations)
            boardDelegate?.selectionboard(self, didChoose: indexes)
            parentTable?.update()
        }
    }
    
}


