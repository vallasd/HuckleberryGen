//
//  HGCell.swift
//  HuckleberryGen
//
//  Created by David Vallas on 9/3/15.
//  Copyright © 2015 Phoenix Labs. All rights reserved.
//

import Cocoa

enum HGOption {
    case Yes
    case No
    case AskUser // Will Display a Prompt
}

enum HGCellItemType: Int16 {
    case Field
    case Image
    case Check
}

/// Defines HGCell locations, row determines which HGCell was selected in the table.  HGCellIdentifier determines the actual item in the cell that was selected.  If this is nil, the entire row was selected.
struct HGCellLocation: Hashable {
    let row: Int
    let identifier: HGCellItemIdentifier?
    
    var hashValue: Int {
        let idhash = identifier == nil ? 0 : identifier!.hashValue
        return row.hashValue + idhash
    }
    
    static func locations(fromIndexSet set: NSIndexSet) -> [HGCellLocation] {
        var locations: [HGCellLocation] = []
        for index in set {
            locations.append(HGCellLocation(row: index, identifier: nil) )
        }
        return locations
    }
}

extension HGCellLocation: Equatable {}
func ==(lhs: HGCellLocation, rhs: HGCellLocation) -> Bool {
    return lhs.row == rhs.row && lhs.identifier == rhs.identifier
}

/// Defines Item in HGCell, tag = 0, type = Field, would define IBOutlet weak var field0: NSTextField? in HGCell
struct HGCellItemIdentifier: Hashable {
    let tag: Int
    let type: HGCellItemType
    
    var hashValue: Int {
        return tag.hashValue + type.hashValue
    }
}

extension HGCellItemIdentifier: Equatable {}
func ==(lhs: HGCellItemIdentifier, rhs: HGCellItemIdentifier) -> Bool {
    return lhs.tag == rhs.tag && lhs.type == rhs.type
}

struct HGImageCellItemIdentifier {
    weak var cell: HGCell?
    var tag: Int
}

extension HGImageCellItemIdentifier: Equatable {}
func ==(lhs: HGImageCellItemIdentifier, rhs: HGImageCellItemIdentifier) -> Bool {
    return lhs.tag == rhs.tag && lhs.cell == rhs.cell
}

protocol HGCellDelegate: AnyObject {
    func hgcell(cell: HGCell, shouldSelectTag tag: Int, type: HGCellItemType) -> Bool
    func hgcell(cell: HGCell, didSelectTag tag: Int, type: HGCellItemType)
    func hgcell(cell: HGCell, shouldEditTag tag: Int, type: HGCellItemType) -> Bool
    func hgcell(cell: HGCell, didEditTag tag: Int, withData data: HGCellItemData)
}

class HGCell: NSTableCellView, NSTextFieldDelegate {
    
    @IBOutlet weak var field0: NSTextField? { didSet { set(field: field0, withTag: 0) } }
    @IBOutlet weak var field1: NSTextField? { didSet { set(field: field1, withTag: 1) } }
    @IBOutlet weak var field2: NSTextField? { didSet { set(field: field2, withTag: 2) } }
    @IBOutlet weak var field3: NSTextField? { didSet { set(field: field3, withTag: 3) } }
    @IBOutlet weak var field4: NSTextField? { didSet { set(field: field4, withTag: 4) } }
    @IBOutlet weak var field5: NSTextField? { didSet { set(field: field5, withTag: 5) } }
    @IBOutlet weak var field6: NSTextField? { didSet { set(field: field6, withTag: 6) } }
    @IBOutlet weak var field7: NSTextField? { didSet { set(field: field7, withTag: 7) } }
    
    @IBOutlet weak var image0: NSButton? { didSet { set(imagebutton: image0, withTag: 0) } }
    @IBOutlet weak var image1: NSButton? { didSet { set(imagebutton: image1, withTag: 1) } }
    @IBOutlet weak var image2: NSButton? { didSet { set(imagebutton: image2, withTag: 2) } }
    @IBOutlet weak var image3: NSButton? { didSet { set(imagebutton: image3, withTag: 3) } }
    @IBOutlet weak var image4: NSButton? { didSet { set(imagebutton: image4, withTag: 4) } }
    @IBOutlet weak var image5: NSButton? { didSet { set(imagebutton: image5, withTag: 5) } }
    @IBOutlet weak var image6: NSButton? { didSet { set(imagebutton: image6, withTag: 6) } }
    @IBOutlet weak var image7: NSButton? { didSet { set(imagebutton: image7, withTag: 7) } }
    
    @IBOutlet weak var check0: NSButton? { didSet { set(checkutton: check0, withTag: 0) } }
    @IBOutlet weak var check1: NSButton? { didSet { set(checkutton: check1, withTag: 1) } }
    @IBOutlet weak var check2: NSButton? { didSet { set(checkutton: check2, withTag: 2) } }
    @IBOutlet weak var check3: NSButton? { didSet { set(checkutton: check3, withTag: 3) } }
    
    weak var delegate: HGCellDelegate?
    
    private(set) var row: Int = 0
    private(set) var selectedImages: [Int] = []
    
    lazy var images: [NSButton?] = {
        return [self.image0, self.image1, self.image2, self.image3, self.image4, self.image5, self.image6, self.image7]
    }()
    
    
    // MARK: Initialization
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    /// HGCell will update all items in the cell based off of HGCellData's values
    func update(withRow r: Int, cellData: HGCellData) {
        row = r
        
        update(field: field0, withData: cellData.field0); update(field: field1, withData: cellData.field1);
        update(field: field2, withData: cellData.field2); update(field: field3, withData: cellData.field3);
        update(field: field4, withData: cellData.field4); update(field: field5, withData: cellData.field5);
        update(field: field6, withData: cellData.field6); update(field: field7, withData: cellData.field7);
        
        update(image: image0, withData: cellData.image0); update(image: image1, withData: cellData.image1);
        update(image: image2, withData: cellData.image2); update(image: image3, withData: cellData.image3);
        update(image: image4, withData: cellData.image4); update(image: image5, withData: cellData.image5);
        update(image: image6, withData: cellData.image6); update(image: image7, withData: cellData.image7);
        
        update(check: check0, withData: cellData.check0); update(check: check1, withData: cellData.check1);
        update(check: check2, withData: cellData.check2); update(check: check3, withData: cellData.check3);
    }
    
    // MARK: Button and Field Target Actions
    
    func didSelectImage(sender: NSButton!) {
        // We can not select an image in HGCell
        let shouldSelect = delegate?.hgcell(self, shouldSelectTag: sender.tag, type: .Image) ?? false
        if shouldSelect == true {
            delegate?.hgcell(self, didSelectTag: sender.tag, type: .Image)
        }
    }
    
    func didSelectField(sender: NSTextField!) {
        delegate?.hgcell(self, didSelectTag: sender.tag, type: .Field)
    }
    
    /// Will unhighlight any Cell Image that is highlighted
    func unselectImages() {
        
        for index in 0...7 {
            if let image = images[index] {
                image.backgroundColor(HGColor.Clear)
            }
        }
        
        selectedImages = []
    }
    
    func unselect(imagetag tag: Int) {
        
        if let image = images[tag] {
            image.backgroundColor(HGColor.Clear)
        }
        
        selectedImages = selectedImages.filter() { $0 != tag }
    }
    
    /// Will Unhighlight
    func select(imagetag tag: Int) {
        
        if selectedImages.contains(tag) { return }
        
        switch tag {
        case 0: image0?.backgroundColor(HGColor.Blue)
        case 1: image1?.backgroundColor(HGColor.Blue)
        case 2: image2?.backgroundColor(HGColor.Blue)
        case 3: image3?.backgroundColor(HGColor.Blue)
        case 4: image4?.backgroundColor(HGColor.Blue)
        case 5: image5?.backgroundColor(HGColor.Blue)
        case 6: image6?.backgroundColor(HGColor.Blue)
        case 7: image7?.backgroundColor(HGColor.Blue)
        default: break;
        }
        
        selectedImages.append(0)
    }
    
    // MARK: Set Fields and Buttons
    
    private func set(field field: NSTextField?, withTag tag: Int) {
        guard let field = field else { return }
        field.delegate = self
        field.tag = tag
    }
    
    private func set(imagebutton button: NSButton?, withTag tag: Int) {
        guard let button = button else { return }
        button.image = nil
        button.target = self
        button.action = "didSelectImage:"
        button.tag = tag
    }
    
    private func set(checkutton button: NSButton?, withTag tag: Int) {
        guard let button = button else { return }
        button.target = self
        button.tag = tag
    }
    
    // MARK: Update Fields and Buttons
    
    private func update(field field: NSTextField?, withData data: HGFieldData?) {
        
        guard let field = field else { return }
        
        guard let data = data else {
            field.stringValue = ""
            field.enabled = false
            field.hidden = true
            field.editable = false
            removeSelectFieldButton(field: field)
            return
        }
        
        field.stringValue = data.title
        field.enabled = true
        field.hidden = false
        selectionSetup(field: field)
    }
    
    private func update(image image: NSButton?, withData data: HGImageData?) {
        
        guard let image = image else { return }
        
        guard let data = data else {
            image.title = ""
            image.image = nil
            image.enabled = false
            image.hidden = true
            return
        }
        
        image.image = data.image
        image.enabled = true
        image.hidden = false
    }
    
    private func update(check check: NSButton?, withData data: HGCheckData?) {
        
        guard let check = check else { return }
        
        guard let data = data else {
            check.title = ""
            check.state = 0
            check.enabled = false
            check.hidden = true
            return
        }
        
        check.title = data.title
        check.state = data.state == true ? 1 : 0
        check.enabled = true
        check.hidden = false
    }
    
    // MARK: Field Select Button
    
    private func selectionSetup(field field: NSTextField) {
        
        let shouldSelect = delegate?.hgcell(self, shouldSelectTag: field.tag, type: .Field) ?? false
        
        // Not Selectable Field
        if !shouldSelect {
            field.editable = false
            field.textColor = NSColor.blackColor()
            removeSelectFieldButton(field: field)
            return
        }
        
        let shouldEdit = delegate?.hgcell(self, shouldEditTag: field.tag, type: .Field) ?? false
        
        // Selectable Field
        if !shouldEdit {
            field.editable = false
            field.textColor = NSColor.blueColor()
            addSelectFieldButton(field: field)
            return
        }
        
        // Editable Field
        if shouldEdit {
            field.editable = true
            field.textColor = NSColor.blueColor()
            removeSelectFieldButton(field: field)
            return
        }
    }
    
    private func selectFieldButton(field field: NSTextField) -> NSButton? {
        for view in field.subviews {
            if let view = view as? NSButton where view.tag == field.tag { return view }
        }
        return nil
    }
    
    private func addSelectFieldButton(field field: NSTextField) {
        if selectFieldButton(field: field) != nil { return }
        let frame = NSRect(x: 0, y: 0, width: field.frame.width, height: field.frame.height)
        let button = NSButton(frame: frame)
        button.tag = field.tag
        button.title = ""
        button.alphaValue = 0.1 // Hides button but it is still functional
        button.action = "didSelectField:"
        button.target = self
        field.addSubview(button)
    }
    
    private func removeSelectFieldButton(field field: NSTextField) {
        let button = selectFieldButton(field: field)
        button?.removeFromSuperview()
    }
    
    // MARK: NSTextFieldDelegate
    
    func control(control: NSControl, textShouldEndEditing fieldEditor: NSText) -> Bool {
        let string = fieldEditor.string ?? ""
        let data = HGFieldData(title: string)
        delegate?.hgcell(self, didEditTag: control.tag, withData: data)
        return true
    }
    
}










////
////  HGCell.swift
////  HuckleberryGen
////
////  Created by David Vallas on 9/3/15.
////  Copyright © 2015 Phoenix Labs. All rights reserved.
////
//
//import Cocoa
//
//enum HGOption {
//    case Yes
//    case No
//    case AskUser // Will Display a Prompt
//}
//
//enum HGCellItemType: Int16 {
//    case Field
//    case Image
//    case Check
//}
//
///// Defines HGCell locations, row determines which HGCell was selected in the table.  HGCellIdentifier determines the actual item in the cell that was selected.  If this is nil, the entire row was selected.
//struct HGCellLocation: Hashable {
//    let row: Int
//    let identifier: HGCellItemIdentifier?
//
//    var hashValue: Int {
//        let idhash = identifier == nil ? 0 : identifier!.hashValue
//        return row.hashValue + idhash
//    }
//
//    static func locations(fromIndexSet set: NSIndexSet) -> [HGCellLocation] {
//        var locations: [HGCellLocation] = []
//        for index in set {
//            locations.append(HGCellLocation(row: index, identifier: nil) )
//        }
//        return locations
//    }
//}
//
//extension HGCellLocation: Equatable {}
//func ==(lhs: HGCellLocation, rhs: HGCellLocation) -> Bool {
//    return lhs.row == rhs.row && lhs.identifier == rhs.identifier
//}
//
///// Defines Item in HGCell, tag = 0, type = Field, would define IBOutlet weak var field0: NSTextField? in HGCell
//struct HGCellItemIdentifier: Hashable {
//    let tag: Int
//    let type: HGCellItemType
//
//    var hashValue: Int {
//        return tag.hashValue + type.hashValue
//    }
//}
//
//extension HGCellItemIdentifier: Equatable {}
//func ==(lhs: HGCellItemIdentifier, rhs: HGCellItemIdentifier) -> Bool {
//    return lhs.tag == rhs.tag && lhs.type == rhs.type
//}
//
//struct HGImageCellItemIdentifier {
//    weak var cell: HGCell?
//    var tag: Int
//}
//
//extension HGImageCellItemIdentifier: Equatable {}
//func ==(lhs: HGImageCellItemIdentifier, rhs: HGImageCellItemIdentifier) -> Bool {
//    return lhs.tag == rhs.tag && lhs.cell == rhs.cell
//}
//
//protocol HGCellDelegate: AnyObject {
//    func hgcell(cell: HGCell, shouldSelectTag tag: Int, type: HGCellItemType) -> Bool
//    func hgcell(cell: HGCell, didSelectTag tag: Int, type: HGCellItemType)
//    func hgcell(cell: HGCell, shouldEditTag tag: Int, type: HGCellItemType) -> Bool
//    func hgcell(cell: HGCell, didEditTag tag: Int, withData data: HGCellItemData)
//}
//
//class HGCell: NSTableCellView, NSTextFieldDelegate {
//
//    @IBOutlet weak var field0: NSTextField? { didSet { set(field: field0, withTag: 0) } }
//    @IBOutlet weak var field1: NSTextField? { didSet { set(field: field1, withTag: 1) } }
//    @IBOutlet weak var field2: NSTextField? { didSet { set(field: field2, withTag: 2) } }
//    @IBOutlet weak var field3: NSTextField? { didSet { set(field: field3, withTag: 3) } }
//    @IBOutlet weak var field4: NSTextField? { didSet { set(field: field4, withTag: 4) } }
//    @IBOutlet weak var field5: NSTextField? { didSet { set(field: field5, withTag: 5) } }
//    @IBOutlet weak var field6: NSTextField? { didSet { set(field: field6, withTag: 6) } }
//    @IBOutlet weak var field7: NSTextField? { didSet { set(field: field7, withTag: 7) } }
//
//    @IBOutlet weak var image0: NSButton? { didSet { set(imagebutton: image0, withTag: 8) } }
//    @IBOutlet weak var image1: NSButton? { didSet { set(imagebutton: image1, withTag: 9) } }
//    @IBOutlet weak var image2: NSButton? { didSet { set(imagebutton: image2, withTag: 10) } }
//    @IBOutlet weak var image3: NSButton? { didSet { set(imagebutton: image3, withTag: 11) } }
//    @IBOutlet weak var image4: NSButton? { didSet { set(imagebutton: image4, withTag: 12) } }
//    @IBOutlet weak var image5: NSButton? { didSet { set(imagebutton: image5, withTag: 13) } }
//    @IBOutlet weak var image6: NSButton? { didSet { set(imagebutton: image6, withTag: 14) } }
//    @IBOutlet weak var image7: NSButton? { didSet { set(imagebutton: image7, withTag: 15) } }
//
//    @IBOutlet weak var check0: NSButton? { didSet { set(checkutton: check0, withTag: 16) } }
//    @IBOutlet weak var check1: NSButton? { didSet { set(checkutton: check1, withTag: 17) } }
//    @IBOutlet weak var check2: NSButton? { didSet { set(checkutton: check2, withTag: 18) } }
//    @IBOutlet weak var check3: NSButton? { didSet { set(checkutton: check3, withTag: 19) } }
//
//    weak var delegate: HGCellDelegate?
//
//    private(set) var row: Int = 0
//
//    /// List of selected images by index
//    private var selectedImages: [Int] = []
//
//    private var images: [NSButton?] = []
//    private var fields: [NSTextField?] = []
//    private var checks: [NSButton?] = []
//
//    // MARK: Initialization
//
//    required init?(coder: NSCoder) {
//        super.init(coder: coder)
//        images = [image0, image1, image2, image3, image4, image5, image6, image7]
//        fields = [field0, field1, field2, field3, field4, field5, field6, field7]
//        checks = [check0, check1, check2, check3]
//    }
//
//    /// HGCell will update all items in the cell based off of HGCellData's values
//    func update(withRow r: Int, cellData: HGCellData) {
//        row = r
//
//        update(field: field0, withData: cellData.field0); update(field: field1, withData: cellData.field1);
//        update(field: field2, withData: cellData.field2); update(field: field3, withData: cellData.field3);
//        update(field: field4, withData: cellData.field4); update(field: field5, withData: cellData.field5);
//        update(field: field6, withData: cellData.field6); update(field: field7, withData: cellData.field7);
//
//        update(image: image0, withData: cellData.image0); update(image: image1, withData: cellData.image1);
//        update(image: image2, withData: cellData.image2); update(image: image3, withData: cellData.image3);
//        update(image: image4, withData: cellData.image4); update(image: image5, withData: cellData.image5);
//        update(image: image6, withData: cellData.image6); update(image: image7, withData: cellData.image7);
//
//        update(check: check0, withData: cellData.check0); update(check: check1, withData: cellData.check1);
//        update(check: check2, withData: cellData.check2); update(check: check3, withData: cellData.check3);
//    }
//
//    // MARK: Button and Field Target Actions
//
//    func didSelectImage(sender: NSButton!) {
//        // We can not select an image in HGCell
//        let shouldSelect = delegate?.hgcell(self, shouldSelectTag: sender.tag, type: .Image) ?? false
//        if shouldSelect == true {
//            delegate?.hgcell(self, didSelectTag: sender.tag, type: .Image)
//        }
//    }
//
//    func didSelectField(sender: NSTextField!) {
//        delegate?.hgcell(self, didSelectTag: sender.tag, type: .Field)
//    }
//
//    //    // MARK: Highlight
//    //
//    //    private func toggle(button: NSButton!) {
//    //
//    //
//    //        if selectedImages {
//    //            areSelected[button.tag] = false
//    //            button.backgroundColor(HGColor.Clear)
//    //        }
//    //
//    //        else {
//    //            areSelected[button.tag] = true
//    //            button.backgroundColor(HGColor.Blue)
//    //        }
//    //    }
//
//    /// unSelects any Image in Cell that is selected and returns a list of all images that were unselected.
//    func unselectImages() -> [Int] {
//
//        var unSelectedImages: [Int] = []
//
//        for index in 0...8 {
//            if selectedImages.contains(index) {
//                images[index]?.backgroundColor(HGColor.Clear);
//                selectedImages = selectedImages.filter() { $0 != index }
//                unSelectedImages.append(index)
//            }
//        }
//
//        return unSelectedImages
//    }
//
//    /// Selects any Image in Cell that is not currently selected, creates error report if image is already selected or tag is out of bounds.
//    func select(imagetag tag: Int) {
//
//        if selectedImages.contains(tag) || (tag < 8 || tag > 15) {
//            HGReportHandler.report("Invalid Selected Image", response: .Error)
//            return
//        }
//
//        selectedImages.append(tag)
//        images[tag]?.backgroundColor(HGColor.Blue)
//    }
//
//
//    // MARK: Set Fields and Buttons
//
//    private func set(field field: NSTextField?, withTag tag: Int) {
//        guard let field = field else { return }
//        field.delegate = self
//        field.tag = tag
//    }
//
//    private func set(imagebutton button: NSButton?, withTag tag: Int) {
//        guard let button = button else { return }
//        button.image = nil
//        button.target = self
//        button.action = "didSelectImage:"
//        button.tag = tag
//    }
//
//    private func set(checkutton button: NSButton?, withTag tag: Int) {
//        guard let button = button else { return }
//        button.target = self
//        button.tag = tag
//    }
//
//    // MARK: Update Fields and Buttons
//
//    private func update(field field: NSTextField?, withData data: HGFieldData?) {
//
//        guard let field = field else { return }
//
//        guard let data = data else {
//            field.stringValue = ""
//            field.enabled = false
//            field.hidden = true
//            field.editable = false
//            removeSelectFieldButton(field: field)
//            return
//        }
//
//        field.stringValue = data.title
//        field.enabled = true
//        field.hidden = false
//        selectionSetup(field: field)
//    }
//
//    private func update(image image: NSButton?, withData data: HGImageData?) {
//
//        guard let image = image else { return }
//
//        guard let data = data else {
//            image.title = ""
//            image.image = nil
//            image.enabled = false
//            image.hidden = true
//            return
//        }
//
//        image.image = data.image
//        image.enabled = true
//        image.hidden = false
//    }
//
//    private func update(check check: NSButton?, withData data: HGCheckData?) {
//
//        guard let check = check else { return }
//
//        guard let data = data else {
//            check.title = ""
//            check.state = 0
//            check.enabled = false
//            check.hidden = true
//            return
//        }
//
//        check.title = data.title
//        check.state = data.state == true ? 1 : 0
//        check.enabled = true
//        check.hidden = false
//    }
//
//    // MARK: Field Select Button
//
//    private func selectionSetup(field field: NSTextField) {
//
//        let shouldSelect = delegate?.hgcell(self, shouldSelectTag: field.tag, type: .Field) ?? false
//
//        // Not Selectable Field
//        if !shouldSelect {
//            field.editable = false
//            field.textColor = NSColor.blackColor()
//            removeSelectFieldButton(field: field)
//            return
//        }
//
//        let shouldEdit = delegate?.hgcell(self, shouldEditTag: field.tag, type: .Field) ?? false
//
//        // Selectable Field
//        if !shouldEdit {
//            field.editable = false
//            field.textColor = NSColor.blueColor()
//            addSelectFieldButton(field: field)
//            return
//        }
//
//        // Editable Field
//        if shouldEdit {
//            field.editable = true
//            field.textColor = NSColor.blueColor()
//            removeSelectFieldButton(field: field)
//            return
//        }
//    }
//
//    private func selectFieldButton(field field: NSTextField) -> NSButton? {
//        for view in field.subviews {
//            if let view = view as? NSButton where view.tag == field.tag { return view }
//        }
//        return nil
//    }
//
//    private func addSelectFieldButton(field field: NSTextField) {
//        if selectFieldButton(field: field) != nil { return }
//        let frame = NSRect(x: 0, y: 0, width: field.frame.width, height: field.frame.height)
//        let button = NSButton(frame: frame)
//        button.tag = field.tag
//        button.title = ""
//        button.alphaValue = 0.1 // Hides button but it is still functional
//        button.action = "didSelectField:"
//        button.target = self
//        field.addSubview(button)
//    }
//
//    private func removeSelectFieldButton(field field: NSTextField) {
//        let button = selectFieldButton(field: field)
//        button?.removeFromSuperview()
//    }
//
//    // MARK: NSTextFieldDelegate
//
//    func control(control: NSControl, textShouldEndEditing fieldEditor: NSText) -> Bool {
//        let string = fieldEditor.string ?? ""
//        let data = HGFieldData(title: string)
//        delegate?.hgcell(self, didEditTag: control.tag, withData: data)
//        return true
//    }
//
//}