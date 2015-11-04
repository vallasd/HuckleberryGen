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
    case FieldCell3 = 8
    
    /// The nib identifier
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
        case FieldCell3: return "FieldCell3"
        }
    }
    
    /// Number of image buttons per row for given cell type
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
        case FieldCell3: return 0
        }
    }
    
    /// Returns an suggested row height for HGCell given a Table
    func rowHeightForTable(table: NSTableView?) -> CGFloat {
        guard let table = table else { return 50.0 }
        let height = max(table.frame.size.height - 8.0, 50)
        var requiredHeight: CGFloat = 0
        switch (self) {
        case DefaultCell: requiredHeight = 40
        case MixedCell1: requiredHeight = 40
        case Check4Cell: requiredHeight = 40
        case Image4Cell: requiredHeight = (table.frame.size.width - 24) / 4
        case Image5Cell: requiredHeight = (table.frame.size.width - 28) / 5
        case Image6Cell: requiredHeight = (table.frame.size.width - 32) / 6
        case FieldCell1: requiredHeight = 40
        case FieldCell2: requiredHeight = 40
        case FieldCell3: requiredHeight = 55
        }
        
        let numberOfRowsOnScreen: CGFloat = max(floor(height / requiredHeight), 1)
        return height / numberOfRowsOnScreen
    }
    
    /// Returns HGCellData for a HGTable if using the BoardImageSource protocol (Only Images)
    func imageSourceCellData(sb sb: SelectionBoard, row: Int) -> HGCellData {
        switch (self) {
        case DefaultCell: return HGCellData.defaultCell(sb: sb, row: row)
        case MixedCell1: return HGCellData.defaultCell(sb: sb, row: row)
        case Check4Cell: return HGCellData.defaultCell(sb: sb, row: row)
        case Image4Cell: return HGCellData.imageAnyCell(sb: sb, row: row, numberOfImagesPerRow: 4)
        case Image5Cell: return HGCellData.imageAnyCell(sb: sb, row: row, numberOfImagesPerRow: 5)
        case Image6Cell: return HGCellData.imageAnyCell(sb: sb, row: row, numberOfImagesPerRow: 6)
        case FieldCell1: return HGCellData.empty
        case FieldCell2: return HGCellData.empty
        case FieldCell3: return HGCellData.empty
        }
    }
    
    /// Returns number of rows for HGTable if using BoardImageSource protocol (Only Images)
    func imageSourceNumberOfRows(forImageItems items: Int) -> Int {
        let ipr = imagesPerRow
        if ipr > 0 { return Int(ceilf(Float(items) / Float(ipr))) }
        return 0
    }
    
    /// Returns the selected indexes of HGCellLocation.  (If HGCellLocation has an identifier that is image, will return the image index, else returns the row)
    func selectedIndexes(forlocations locations: [HGCellLocation]) -> [Int] {
        var indexes: [Int] = []
        for location in locations {
            indexes.append(self.selectedIndex(forlocation: location))
        }
        return indexes
    }
    
    private func selectedIndex(forlocation location: HGCellLocation) -> Int {
        if let identifier = location.identifier {
            if identifier.type == .Image {
                return (location.row * imagesPerRow) + identifier.tag
            }
        }
        
        return location.row
    }
}