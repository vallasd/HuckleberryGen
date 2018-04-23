//
//  HGCellData.swift
//  HuckleberryGen
//
//  Created by David Vallas on 9/10/15.
//  Copyright © 2015 Phoenix Labs.
//
//  All Rights Reserved.

import Cocoa

protocol HGCellItemData {
    var title: String { get }
}

struct HGFieldData: HGCellItemData {
    let title: String
}

/// Data needed load an Image.  If imageURL is set, the Cell will load image until imageURL can be asynchronously loaded and set.  ***Currently, imageURL is not implemented.
struct HGImageData: HGCellItemData {
    let title: String
    let image: NSImage?
    
    static func withImage(_ image: NSImage?) -> HGImageData {
        return HGImageData(title: "", image: image)
    }
}

struct HGCheckData: HGCellItemData {
    let title: String
    let state: Bool
}

/// Structure used to populate HGCell nib files with the appropriate data.
struct HGCellData {

    let fields: [HGFieldData]
    let images: [HGImageData]
    let checks: [HGCheckData]
    let imagesOnly: Bool
    let dummyImages: Int
    
    /// returns an empty HGCellData object
    static var empty: HGCellData {
        return HGCellData(fields: [], images: [], checks: [], imagesOnly: false, dummyImages: 0)
    }
    
    /// returns a HGCellData object that can populate a fieldCell1 nib
    static func fieldCell1(field0: HGFieldData) -> HGCellData {
        return HGCellData(fields: [field0], images: [],  checks: [], imagesOnly: false, dummyImages: 0)
    }
    
    /// returns a HGCellData object that can populate a fieldCell2 nib
    static func fieldCell2(field0: HGFieldData, field1: HGFieldData) -> HGCellData {
        return HGCellData(fields: [field0, field1], images: [], checks: [], imagesOnly: false, dummyImages: 0)
    }
    
    /// returns a HGCellData object that can populate a fieldCell3 nib
    static func fieldCell3(field0: HGFieldData, field1: HGFieldData, field2: HGFieldData, field3: HGFieldData, field4: HGFieldData) -> HGCellData {
        return HGCellData(fields: [field0, field1, field2, field3, field4],
                          images: [],
                          checks: [],
                          imagesOnly: false,
                          dummyImages: 0)
    }
    
    /// returns a HGCellData object that can populate a defaultCell nib
    static func defaultCell(field0: HGFieldData, field1: HGFieldData, image0: HGImageData) -> HGCellData {
        return HGCellData(fields: [field0, field1],
                          images: [image0],
                          checks: [],
                          imagesOnly: false,
                          dummyImages: 0)
    }
    
    /// returns a HGCellData object that can populate a mixedCell1 nib
    static func mixedCell1(field0: HGFieldData, field1: HGFieldData, field2: HGFieldData, field3: HGFieldData, field4: HGFieldData, image0: HGImageData) -> HGCellData {
        return HGCellData(fields: [field0, field1, field2, field3, field4],
                          images: [image0],
                          checks: [],
                          imagesOnly: false,
                          dummyImages: 0)
    }
    
    /// returns a HGCellData object that can populate a check4Cell nib
    static func check4Cell(field0: HGFieldData, field1: HGFieldData, image0: HGImageData, check0: HGCheckData, check1: HGCheckData, check2: HGCheckData, check3: HGCheckData) -> HGCellData {
        return HGCellData(fields: [field0, field1],
                          images: [image0],
                          checks: [check0, check1, check2, check3],
                          imagesOnly: false,
                          dummyImages: 0)
    }
    
    /// returns a HGCellData object that only contains HGImageData
    static func onlyImages(_ images: [HGImageData], rowCount: Int) -> HGCellData {
        return HGCellData(fields: [],
                          images: images,
                          checks: [],
                          imagesOnly: false,
                          dummyImages: max(0,rowCount-images.count))
    }
}
