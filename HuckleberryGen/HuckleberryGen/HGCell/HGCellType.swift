//
//  HGCellType.swift
//  HuckleberryGen
//
//  Created by David Vallas on 9/10/15.
//  Copyright © 2015 Phoenix Labs. All rights reserved.
//

import Cocoa

enum HGCellType: Int16 {
    case DefaultCell = 0
    case MixedCell1 = 1
    case Check4Cell = 2
    case Image4Cell = 3
    case Image5Cell = 4
    case Image6Cell = 5
    case FieldCell1 = 6
    case FieldCell2 = 7
    
    var identifier: String {
        switch (self) {
        case DefaultCell: return "DefaultCell"
        case MixedCell1: return "MixedCell1"
        case Check4Cell: return "CheckCell"
        case Image4Cell: return "Image4Cell"
        case Image5Cell: return "Image5Cell"
        case Image6Cell: return "Image6Cell"
        case FieldCell1: return "FieldCell1"
        case FieldCell2: return "FieldCell2"
        }
    }
    
    var imagesPerRow: Int {
        switch (self) {
        case DefaultCell: return 1
        case MixedCell1: return 1
        case Check4Cell: return 1
        case Image4Cell: return 4
        case Image5Cell: return 5
        case Image6Cell: return 6
        case FieldCell1: return 0
        case FieldCell2: return 0
        }
    }
    
    func rowHeightForTable(table: NSTableView?) -> CGFloat {
        guard let table = table else { return 50.0 }
        let height = max(table.frame.size.height - 8.0, 0)
        switch (self) {
        case DefaultCell: return height / 4.0
        case MixedCell1: return height / 4.0
        case Check4Cell: return height / 4.0
        case Image4Cell: return height / 1.0
        case Image5Cell: return height / 2.0
        case Image6Cell: return height / 2.0
        case FieldCell1: return height / 4.0
        case FieldCell2: return height / 4.0
        }
    }
    
    func numberOfRows(forImageItems items: Int) -> Int {
        let ipr = imagesPerRow
        if ipr > 0 { return Int(ceilf(Float(items) / Float(ipr))) }
        return 0
    }
    
    func selectedIndexes(forlocations locations: [HGCellLocation]) -> [Int] {
        var indexes: [Int] = []
        for location in locations {
            indexes.append(self.selectedIndex(forlocation: location))
        }
        return indexes
    }
    
    func selectedIndex(forlocation location: HGCellLocation) -> Int {
        if let identifier = location.identifier {
            return (location.row * imagesPerRow) + identifier.tag
        }
        
        return location.row
    }
    
    func cellData(sb sb: SelectionBoard, row: Int) -> HGCellData {
        
        switch (self) {
        case DefaultCell: return HGCellData.defaultCell(sb: sb, row: row)
        case MixedCell1: return HGCellData.defaultCell(sb: sb, row: row)
        case Check4Cell: return HGCellData.defaultCell(sb: sb, row: row)
        case Image4Cell: return HGCellData.image4Cell(sb: sb, row: row)
        case Image5Cell: return HGCellData.image5Cell(sb: sb, row: row)
        case Image6Cell: return HGCellData.image6Cell(sb: sb, row: row)
        case FieldCell1: return HGCellData.empty
        case FieldCell2: return HGCellData.empty
        }
    }
    
    
}