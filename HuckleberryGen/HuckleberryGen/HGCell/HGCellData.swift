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
    // let imageURL: String?
    
    static func withImage(image: NSImage?) -> HGImageData { return HGImageData(title: "", image: image) }

}

struct HGCheckData: HGCellItemData {
    let title: String
    let state: Bool
}

struct HGCellData {
    let field0: HGFieldData?
    let field1: HGFieldData?
    let field2: HGFieldData?
    let field3: HGFieldData?
    let field4: HGFieldData?
    let field5: HGFieldData?
    let field6: HGFieldData?
    let field7: HGFieldData?
    let image0: HGImageData?
    let image1: HGImageData?
    let image2: HGImageData?
    let image3: HGImageData?
    let image4: HGImageData?
    let image5: HGImageData?
    let image6: HGImageData?
    let image7: HGImageData?
    let check0: HGCheckData?
    let check1: HGCheckData?
    let check2: HGCheckData?
    let check3: HGCheckData?
    
    func images() -> [HGImageData?] {
        return [self.image0, self.image1, self.image2, self.image3, self.image4, self.image5, self.image6, self.image7]
    }
    
    func fields() -> [HGFieldData?] {
        return [self.field0, self.field1, self.field2, self.field3, self.field4, self.field5, self.field6, self.field7]
    }
    
    func checks() -> [HGCheckData?] {
        return [self.check0, self.check1, self.check2, self.check3]
    }
    
    static var empty: HGCellData {
        return HGCellData(
            field0: nil, field1: nil, field2: nil, field3: nil,
            field4: nil, field5: nil, field6: nil, field7: nil,
            image0: nil, image1: nil, image2: nil, image3: nil,
            image4: nil, image5: nil, image6: nil, image7: nil,
            check0: nil, check1: nil, check2: nil, check3: nil
        )
    }
    
    static func fieldCell1(field0 field0: HGFieldData?) -> HGCellData {
        return HGCellData(
            field0: field0,
            field1: nil, field2: nil, field3: nil,
            field4: nil, field5: nil, field6: nil, field7: nil,
            image0: nil, image1: nil, image2: nil, image3: nil,
            image4: nil, image5: nil, image6: nil, image7: nil,
            check0: nil, check1: nil, check2: nil, check3: nil
        )
    }
    
    static func fieldCell2(field0 field0: HGFieldData?, field1: HGFieldData?) -> HGCellData {
        return HGCellData(
            field0: field0, field1: field1,
            field2: nil, field3: nil,
            field4: nil, field5: nil, field6: nil, field7: nil,
            image0: nil, image1: nil, image2: nil, image3: nil,
            image4: nil, image5: nil, image6: nil, image7: nil,
            check0: nil, check1: nil, check2: nil, check3: nil
        )
    }
    
    static func defaultCell(field0 field0: HGFieldData?, field1: HGFieldData?, image0: HGImageData?) -> HGCellData {
        return HGCellData(
            field0: field0, field1: field1,
            field2: nil, field3: nil,
            field4: nil, field5: nil, field6: nil, field7: nil,
            image0: image0,
            image1: nil, image2: nil, image3: nil,
            image4: nil, image5: nil, image6: nil, image7: nil,
            check0: nil, check1: nil, check2: nil, check3: nil
        )
    }
    
    static func mixedCell1(field0 field0: HGFieldData?, field1: HGFieldData?, field2: HGFieldData?, field3: HGFieldData?, field4: HGFieldData?, image0: HGImageData?) -> HGCellData {
        return HGCellData(
            field0: field0, field1: field1, field2: field2, field3: field3, field4: field4,
            field5: nil, field6: nil, field7: nil,
            image0: image0,
            image1: nil, image2: nil, image3: nil,
            image4: nil, image5: nil, image6: nil, image7: nil,
            check0: nil, check1: nil, check2: nil, check3: nil
        )
    }
    
    
    static func check4Cell(field0 field0: HGFieldData?, field1: HGFieldData?, image0: HGImageData?, check0: HGCheckData?, check1: HGCheckData?, check2: HGCheckData?, check3: HGCheckData?) -> HGCellData {
        return HGCellData(
            field0: field0, field1: field1,
            field2: nil, field3: nil,
            field4: nil, field5: nil, field6: nil, field7: nil,
            image0: image0,
            image1: nil, image2: nil, image3: nil,
            image4: nil, image5: nil, image6: nil, image7: nil,
            check0: check0, check1: check1, check2: check2, check3: check3
        )
    }
    
    static func image4Cell(image0 image0: HGImageData?, image1: HGImageData?, image2: HGImageData?, image3: HGImageData?) -> HGCellData {
        return HGCellData(
            field0: nil, field1: nil, field2: nil, field3: nil,
            field4: nil, field5: nil, field6: nil, field7: nil,
            image0: image0, image1: image1, image2: image2, image3: image3,
            image4: nil, image5: nil, image6: nil, image7: nil,
            check0: nil, check1: nil, check2: nil, check3: nil
        )
    }
    
    static func image5Cell(image0 image0: HGImageData?, image1: HGImageData?, image2: HGImageData?, image3: HGImageData?, image4: HGImageData?) -> HGCellData {
        return HGCellData(
            field0: nil, field1: nil, field2: nil, field3: nil,
            field4: nil, field5: nil, field6: nil, field7: nil,
            image0: image0, image1: image1, image2: image2, image3: image3,
            image4: image4,
            image5: nil,image6: nil, image7: nil,
            check0: nil, check1: nil, check2: nil, check3: nil
        )
    }
    
    
    static func image6Cell(image0 image0: HGImageData?, image1: HGImageData?, image2: HGImageData?, image3: HGImageData?, image4: HGImageData?, image5: HGImageData?) -> HGCellData {
        return HGCellData(
            field0: nil, field1: nil, field2: nil, field3: nil,
            field4: nil, field5: nil, field6: nil, field7: nil,
            image0: image0, image1: image1, image2: image2, image3: image3,
            image4: image4, image5: image5,
            image6: nil, image7: nil,
            check0: nil, check1: nil, check2: nil, check3: nil
        )
    }
    
    /// Delivers the correct HGCellData for an defaultCell when receiving an image name array for entire table and a row number
    static func defaultCell(sb sb: SelectionBoard, row: Int) -> HGCellData {
        guard let imagesource = sb.boardImageSource else { return HGCellData.empty }
        let image = imagesource.selectionboard(sb, imageDataForIndex: row)
        let field = HGFieldData(title: image?.title ?? "")
        return HGCellData.defaultCell(field0: field, field1: nil, image0: image)
    }
    
    /// Delivers the correct HGCellData for an Image4Cell when receiving an image name array for entire table and a row number
    static func image4Cell(sb sb: SelectionBoard, row: Int) -> HGCellData {
        guard let imagesource = sb.boardImageSource else { return HGCellData.empty }
        let num0 = row * 4
        let num1 = num0 + 1, num2 = num0 + 2, num3 = num0 + 3
        let max = sb.numberOfItems
        let image0: HGImageData? = num0 < max ? imagesource.selectionboard(sb, imageDataForIndex: num0) : nil
        let image1: HGImageData? = num1 < max ? imagesource.selectionboard(sb, imageDataForIndex: num1) : nil
        let image2: HGImageData? = num2 < max ? imagesource.selectionboard(sb, imageDataForIndex: num2) : nil
        let image3: HGImageData? = num3 < max ? imagesource.selectionboard(sb, imageDataForIndex: num3) : nil
        return HGCellData.image4Cell(image0: image0, image1: image1, image2: image2, image3: image3)
    }
    
    /// Delivers the correct HGCellData for an Image5Cell when receiving an image name array for entire table and a row number
    static func image5Cell(sb sb: SelectionBoard, row: Int) -> HGCellData {
        guard let imagesource = sb.boardImageSource else { return HGCellData.empty }
        let num0 = row * 5
        let num1 = num0 + 1, num2 = num0 + 2, num3 = num0 + 3, num4 = num0 + 4
        let max = sb.numberOfItems
        let image0: HGImageData? = num0 < max ? imagesource.selectionboard(sb, imageDataForIndex: num0) : nil
        let image1: HGImageData? = num1 < max ? imagesource.selectionboard(sb, imageDataForIndex: num1) : nil
        let image2: HGImageData? = num2 < max ? imagesource.selectionboard(sb, imageDataForIndex: num2) : nil
        let image3: HGImageData? = num3 < max ? imagesource.selectionboard(sb, imageDataForIndex: num3) : nil
        let image4: HGImageData? = num4 < max ? imagesource.selectionboard(sb, imageDataForIndex: num4) : nil
        return HGCellData.image5Cell(image0: image0, image1: image1, image2: image2, image3: image3, image4: image4)
    }
    
    /// Delivers the correct HGCellData for an Image6Cell when receiving an image name array for entire table and a row number
    static func image6Cell(sb sb: SelectionBoard, row: Int) -> HGCellData {
        guard let imagesource = sb.boardImageSource else { return HGCellData.empty }
        let num0 = row * 6
        let num1 = num0 + 1, num2 = num0 + 2, num3 = num0 + 3, num4 = num0 + 4, num5 = num0 + 5
        let max = sb.numberOfItems
        let image0: HGImageData? = num0 < max ? imagesource.selectionboard(sb, imageDataForIndex: num0) : nil
        let image1: HGImageData? = num1 < max ? imagesource.selectionboard(sb, imageDataForIndex: num1) : nil
        let image2: HGImageData? = num2 < max ? imagesource.selectionboard(sb, imageDataForIndex: num2) : nil
        let image3: HGImageData? = num3 < max ? imagesource.selectionboard(sb, imageDataForIndex: num3) : nil
        let image4: HGImageData? = num4 < max ? imagesource.selectionboard(sb, imageDataForIndex: num4) : nil
        let image5: HGImageData? = num5 < max ? imagesource.selectionboard(sb, imageDataForIndex: num5) : nil
        return HGCellData.image6Cell(image0: image0, image1: image1, image2: image2, image3: image3, image4: image4, image5: image5)
    }
    
}