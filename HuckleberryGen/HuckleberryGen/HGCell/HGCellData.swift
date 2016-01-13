//
//  HGCellData.swift
//  HuckleberryGen
//
//  Created by David Vallas on 9/10/15.
//  Copyright © 2015 Phoenix Labs. All rights reserved.
//

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
    
    static func withImage(image: NSImage?) -> HGImageData { return HGImageData(title: "", image: image) }

}

struct HGCheckData: HGCellItemData {
    let title: String
    let state: Bool
}

/// Structure used to populate HGCell nib files with the appropriate data.
struct HGCellData {

    var fields: [HGFieldData]
    var images: [HGImageData]
    var checks: [HGCheckData]
    
    /// returns an empty HGCellData object
    static var empty: HGCellData {
        return HGCellData(fields: [], images: [], checks: [])
    }
    
    /// returns a HGCellData object that can populate a fieldCell1 nib
    static func fieldCell1(field0 field0: HGFieldData) -> HGCellData {
        return HGCellData(fields: [field0], images: [],  checks: [])
    }
    
    /// returns a HGCellData object that can populate a fieldCell2 nib
    static func fieldCell2(field0 field0: HGFieldData, field1: HGFieldData) -> HGCellData {
        return HGCellData(fields: [field0, field1], images: [], checks: [])
    }
    
    /// returns a HGCellData object that can populate a fieldCell3 nib
    static func fieldCell3(field0 field0: HGFieldData, field1: HGFieldData, field2: HGFieldData, field3: HGFieldData, field4: HGFieldData) -> HGCellData {
        return HGCellData(fields: [field0, field1, field2, field3, field4], images: [], checks: [])
    }
    
    /// returns a HGCellData object that can populate a defaultCell nib
    static func defaultCell(field0 field0: HGFieldData, field1: HGFieldData, image0: HGImageData) -> HGCellData {
        return HGCellData(fields: [field0, field1], images: [image0], checks: [])
    }
    
    /// returns a HGCellData object that can populate a mixedCell1 nib
    static func mixedCell1(field0 field0: HGFieldData, field1: HGFieldData, field2: HGFieldData, field3: HGFieldData, field4: HGFieldData, image0: HGImageData) -> HGCellData {
        return HGCellData(fields: [field0, field1, field2, field3, field4], images: [image0], checks: [])
    }
    
    /// returns a HGCellData object that can populate a check4Cell nib
    static func check4Cell(field0 field0: HGFieldData, field1: HGFieldData, image0: HGImageData, check0: HGCheckData, check1: HGCheckData, check2: HGCheckData, check3: HGCheckData) -> HGCellData {
        return HGCellData(fields: [field0, field1], images: [image0], checks: [check0, check1, check2, check3])
    }
    
    /// returns a HGCellData object that can populate a image4Cell nib
    static func image4Cell(image0 image0: HGImageData, image1: HGImageData, image2: HGImageData, image3: HGImageData) -> HGCellData {
        return HGCellData(fields: [], images: [image0, image1, image2, image3], checks: [])
    }
    
    /// returns a HGCellData object that can populate a image5Cell nib
    static func image5Cell(image0 image0: HGImageData, image1: HGImageData, image2: HGImageData, image3: HGImageData, image4: HGImageData) -> HGCellData {
        return HGCellData(fields: [], images: [image0, image1, image2, image3, image4], checks: [])
    }
    
    /// returns a HGCellData object that can populate a image6Cell nib
    static func image6Cell(image0 image0: HGImageData, image1: HGImageData, image2: HGImageData, image3: HGImageData, image4: HGImageData, image5: HGImageData) -> HGCellData {
        return HGCellData(fields: [], images: [image0, image1, image2, image3, image4, image5], checks: [])
    }
    
    /// returns a HGCellData object that only contains HGImageData
    static func onlyImages(images: [HGImageData]) -> HGCellData { return HGCellData(fields: [], images: images, checks: []) }
    
}