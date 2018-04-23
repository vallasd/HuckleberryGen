//
//  CellType.swift
//  HuckleberryGen
//
//  Created by David Vallas on 9/10/15.
//  Copyright © 2015 Phoenix Labs.
//
//  All Rights Reserved.

import Cocoa

enum CellType {

    case defaultCell
    case mixedCell1
    case check4Cell
    case imageCell
    case fieldCell1
    case fieldCell2
    case fieldCell3
    
    
    /// The nib identifier
    var identifier: String {
        switch (self) {
        case .defaultCell: return "DefaultCell"
        case .mixedCell1: return "MixedCell1"
        case .check4Cell: return "CheckCell"
        case .imageCell: return "ImageCell"
        case .fieldCell1: return "FieldCell1"
        case .fieldCell2: return "FieldCell2"
        case .fieldCell3: return "FieldCell3"
        }
    }
    
    /// Number of image buttons per row for given cell type
    func imagesPerRow(table: HGTable) -> Int {
        switch self {
        case .defaultCell: return 1
        case .mixedCell1: return 1
        case .check4Cell: return 1
        case .imageCell:
            let rowWidth = table.rowWidth
            let imageWidth = rowHeight - HGCellImageBorder
            let numImages = Int(rowWidth / imageWidth)
            let sidePadding = 2 * HGCellImageBorder
            let totalSpaceNeeded = (CGFloat(numImages) * imageWidth) + sidePadding
            let images = totalSpaceNeeded <= rowWidth ? numImages : numImages - 1
            print("images per row: \(images)")
            return 3
        case .fieldCell1: return 0
        case .fieldCell2: return 0
        case .fieldCell3: return 0
        }
    }
    
    /// Returns an suggested row height for HGCell given a Table
    var rowHeight: CGFloat {
        switch (self) {
        case .defaultCell: return 40
        case .mixedCell1: return 40
        case .check4Cell: return 40
        case .imageCell: return 55
        case .fieldCell1: return 40
        case .fieldCell2: return 40
        case .fieldCell3: return 55
        }
    }
    
    /// returns number of rows required for a specific cell type assuming that this cell type would be used for every row, that an image would be used on each available image button in cell, and imageCount is total images required.
    func numRows(numImages: Int, inTable table: HGTable) -> Int {
        let ipr = imagesPerRow(table: table)
        if ipr == 0 { return 0 }
        if numImages == 0 { return 0 }
        return (numImages / ipr) + 1
    }
    
    /// returns the image indexes required for a row.
    func imageIndexes(forRow row: Int, maxCount: Int, inTable table: HGTable) -> [Int] {
        let ipr = imagesPerRow(table: table)
        let firstIndex = row * ipr
        var indexes: [Int] = []
        for count in 0...ipr - 1 {
            let nextIndex = firstIndex + count
            if nextIndex == maxCount { break }
            indexes.append(nextIndex)
        }
        return indexes
    }
    
    /// returns the cooresponding indexes of HGCellLocation.
    func indexes(forlocations locations: [HGCellLocation], inTable table: HGTable) -> [Int] {
        var indexes: [Int] = []
        for location in locations {
            let _index = index(forlocation: location, inTable: table)
            indexes.append(_index)
        }
        return indexes
    }
    
    
    /// returns the cooresponding index, if HGCellLocation is for an image, assumes the index is for an array of images
    func index(forlocation location: HGCellLocation, inTable table: HGTable) -> Int {
        
        if let identifier = location.identifier {
            if identifier.type == .image {
                let ipr = imagesPerRow(table: table)
                return location.row * ipr + identifier.tag
            }
        }
        
        return location.row
    }
}
