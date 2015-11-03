//
//  TableSelectionBoard.swift
//  HuckleberryGen
//
//  Created by David Vallas on 9/3/15.
//  Copyright © 2015 Phoenix Labs. All rights reserved.
//

import Cocoa

/// Selection Board Protocol that
protocol SelectionBoardDelegate: AnyObject {
    func hgcellType(forSelectionBoard sb: SelectionBoard) -> HGCellType
    func selectionboard(sb: SelectionBoard, didChoose items: [Int])
    func numberOfItems(forSelectionBoard sb: SelectionBoard) -> Int
}

/// Use this protocol for the datasource if you plan to treat each Row as an Option
protocol SelectionBoardDataSource: SelectionBoardDelegate {
    func selectionboard(sb: SelectionBoard, dataForRow row: Int) -> HGCellData
}

/// Use this protocol for the datasource if you plan to treat each Image on the Row as an Option
protocol SelectionBoardImageSource: SelectionBoardDelegate {
    func selectionboard(sb: SelectionBoard, imageDataForIndex index: Int) -> HGImageData
}

class SelectionBoard: NSViewController, HGTableDisplayable, HGTableRowSelectable, HGTableItemEditable {
    
    
    @IBOutlet weak var boardtitle: NSTextField!
    @IBOutlet weak var tableview: HGTableView!
    
    /// types of datasource that the Selection Board can handle
    enum DatasourceType {
        case BoardDataSource
        case BoardImageSource
    }
    
    ///
    var datasourceType: DatasourceType = .BoardDataSource
    
    private(set) var parentTable: HGTable?
    
    weak var boardDelegate: SelectionBoardDelegate? {
        didSet {
            hgcellType = boardDelegate?.hgcellType(forSelectionBoard: self) ?? HGCellType.DefaultCell
        }
    }
    
    weak var boardDataSource: SelectionBoardDataSource? {
        didSet {
            datasourceType = .BoardDataSource
            hgtable.update()
        }
    }
    
    weak var boardImageSource: SelectionBoardImageSource? {
        didSet {
            datasourceType = .BoardImageSource
            hgtable.update()
        }
    }
    
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
        if datasourceType == .BoardImageSource {
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
        if datasourceType == .BoardImageSource {
            return hgcellType.cellData(sb: self, row: row)
        }
        return boardDataSource?.selectionboard(self, dataForRow: row) ?? HGCellData.empty
    }
    
    // MARK: HGTableRowSelectable
    
    func hgtable(table: HGTable, shouldSelectRow row: Int) -> Bool {
        if datasourceType == .BoardImageSource {
            return false
        }
        return true
    }
    
    func hgtable(table: HGTable, didSelectRow row: Int) {
        // DO NOTHING
    }
    
    // MARK: HGTableItemEditable
    
    func hgtable(table: HGTable, shouldEditRow row: Int, tag: Int, type: HGCellItemType) -> HGOption {
        if datasourceType == .BoardImageSource {
            return .Yes
        }
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


