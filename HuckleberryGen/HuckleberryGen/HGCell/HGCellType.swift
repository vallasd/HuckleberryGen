//
//  CellType.swift
//  HuckleberryGen
//
//  Created by David Vallas on 9/10/15.
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

enum CellType {
    
    case defaultCell
    case mixedCell1
    case check4Cell
    case image3Cell
    case image4Cell
    case image5Cell
    case image6Cell
    case fieldCell1
    case fieldCell2
    case fieldCell3
    
    /// The nib identifier
    var identifier: String {
        switch (self) {
        case .defaultCell: return "DefaultCell"
        case .mixedCell1: return "MixedCell1"
        case .check4Cell: return "CheckCell"
        case .image3Cell: return "Image3Cell"
        case .image4Cell: return "Image4Cell"
        case .image5Cell: return "Image5Cell"
        case .image6Cell: return "Image6Cell"
        case .fieldCell1: return "FieldCell1"
        case .fieldCell2: return "FieldCell2"
        case .fieldCell3: return "FieldCell3"
        }
    }
    
    /// Number of image buttons per row for given cell type
    var imagesPerRow: Int {
        switch (self) {
        case .defaultCell: return 1
        case .mixedCell1: return 1
        case .check4Cell: return 1
        case .image3Cell: return 4
        case .image4Cell: return 4
        case .image5Cell: return 5
        case .image6Cell: return 6
        case .fieldCell1: return 0
        case .fieldCell2: return 0
        case .fieldCell3: return 0
        }
    }
    
    /// Returns an suggested row height for HGCell given a Table
    func rowHeightForTable(_ table: NSTableView?) -> CGFloat {
        guard let table = table else { return 50.0 }
        let height = max(table.frame.size.height - 8.0, 50)
        var requiredHeight: CGFloat = 0
        switch (self) {
        case .defaultCell: requiredHeight = 40
        case .mixedCell1: requiredHeight = 40
        case .check4Cell: requiredHeight = 40
        case .image3Cell: requiredHeight = (table.frame.size.width - 20) / 3
        case .image4Cell: requiredHeight = (table.frame.size.width - 24) / 4
        case .image5Cell: requiredHeight = (table.frame.size.width - 28) / 5
        case .image6Cell: requiredHeight = (table.frame.size.width - 32) / 6
        case .fieldCell1: requiredHeight = 40
        case .fieldCell2: requiredHeight = 40
        case .fieldCell3: requiredHeight = 55
        }
        
        let numberOfRowsOnScreen: CGFloat = max(floor(height / requiredHeight), 1)
        return height / numberOfRowsOnScreen
    }
    
    /// Returns number of rows for HGTable if using BoardImageSource protocol (Only Images)
    func imageSourceNumberOfRows(forImageItems items: Int) -> Int {
        let ipr = imagesPerRow
        if ipr > 0 { return Int(ceilf(Float(items) / Float(ipr))) }
        return 0
    }
    
    /// returns number of rows required for a specific cell type assuming that this cell type would be used for every row, that an image would be used on each available image button in cell, and imageCount is total images required.
    func rows(forImagesWithCount imageCount: Int) -> Int {
        let ipr = self.imagesPerRow
        if ipr == 0 { return 0 }
        if imageCount == 0 { return 0 }
        return (imageCount / ipr) + 1
    }
    
    /// returns the image indexes required for a row.
    func imageIndexes(forRow row: Int, imageCount: Int) -> [Int] {
        let ipr = self.imagesPerRow
        let firstIndex = row * ipr
        var indexes: [Int] = []
        for count in 0...ipr-1 {
            let nextIndex = firstIndex + count
            if nextIndex >= imageCount { break }
            indexes.append(nextIndex)
        }
        return indexes
    }
    
    /// returns the cooresponding indexes of HGCellLocation.
    func indexes(forlocations locations: [HGCellLocation]) -> [Int] {
        var indexes: [Int] = []
        for location in locations {
            indexes.append(self.index(forlocation: location))
        }
        return indexes
    }
    
    
    /// returns the cooresponding index, if HGCellLocation is for an image, assumes the index is for an array of images
    func index(forlocation location: HGCellLocation) -> Int {
        
        if let identifier = location.identifier {
            if identifier.type == .image {
                return (location.row * imagesPerRow) + identifier.tag
            }
        }
        
        return location.row
    }
}
