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
    
    /// creates an array of HGCellLocations from an NSIndexSet of rows
    static func locations(fromIndexSet set: NSIndexSet) -> [HGCellLocation] {
        var locations: [HGCellLocation] = []
        for index in set {
            locations.append(HGCellLocation(row: index, identifier: nil) )
        }
        return locations
    }
    
    /// creates an array of HGCellLocations from an array of rows represented as [Int]
    static func locations(fromRows rows: [Int]) -> [HGCellLocation] {
        var locations: [HGCellLocation] = []
        for row in rows {
            locations.append(HGCellLocation(row: row, identifier: nil) )
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
    
    // MARK: @IBOutlets
    
    @IBOutlet weak var image0: NSButton?
    @IBOutlet weak var image1: NSButton?
    @IBOutlet weak var image2: NSButton?
    @IBOutlet weak var image3: NSButton?
    @IBOutlet weak var image4: NSButton?
    @IBOutlet weak var image5: NSButton?
    @IBOutlet weak var image6: NSButton?
    @IBOutlet weak var image7: NSButton?
    
    @IBOutlet weak var field0: NSTextField?
    @IBOutlet weak var field1: NSTextField?
    @IBOutlet weak var field2: NSTextField?
    @IBOutlet weak var field3: NSTextField?
    @IBOutlet weak var field4: NSTextField?
    @IBOutlet weak var field5: NSTextField?
    @IBOutlet weak var field6: NSTextField?
    @IBOutlet weak var field7: NSTextField?
    
    @IBOutlet weak var check0: NSButton?
    @IBOutlet weak var check1: NSButton?
    @IBOutlet weak var check2: NSButton?
    @IBOutlet weak var check3: NSButton?
    
    weak var delegate: HGCellDelegate?
    
    private(set) var row: Int = 0
    private(set) var selectedImages: [Int] = []
    
    /// ordered array of images for HGCell
    lazy var images: [NSButton?] = {
        let _images = [self.image0, self.image1, self.image2, self.image3, self.image4, self.image5, self.image6, self.image7]
        for index in 0...7 {
            self.set(imagebutton: _images[index], withTag: index)
        }
        return _images
    }()
    
    /// ordered array of fields for HGCell
    lazy var fields: [NSTextField?] = {
        let _fields = [self.field0, self.field1, self.field2, self.field3, self.field4, self.field5, self.field6, self.field7]
        for index in 0...7 {
            self.set(field: _fields[index], withTag: index)
        }
        return _fields
    }()
    
    /// ordered array of checks for HGCell
    lazy var checks: [NSButton?] = {
        let _checks = [self.check0, self.check1, self.check2, self.check3]
        for index in 0...3 {
            self.set(checkbutton: _checks[index], withTag: index)
        }
        return _checks
    }()
    
    // MARK: Initialization
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    /// updates images, fields, and checks of HGCell with HGCellData
    func update(withRow row: Int, cellData: HGCellData) {
        
        // update row tag
        self.row = row
        
        // Update and/or Clear Fields
        update(withData: cellData.fields)
        disable(missingData: cellData.fields)
        
        // Update and/or Clear Images
        update(withData: cellData.images)
        disable(missingData: cellData.images)
        
        // Update and/or Clear Fields
        update(withData: cellData.checks)
        disable(missingData: cellData.checks)
    }
    
    // MARK: Button and Field Target Actions
    
    /// function called when user selects an image
    func didSelectImage(sender: NSButton!) {
        // We can not select an image in HGCell
        let shouldSelect = delegate?.hgcell(self, shouldSelectTag: sender.tag, type: .Image) ?? false
        if shouldSelect == true {
            delegate?.hgcell(self, didSelectTag: sender.tag, type: .Image)
        }
    }
    
    /// function called when a user selects a field (if field is selectable)
    func didSelectField(sender: NSTextField!) {
        delegate?.hgcell(self, didSelectTag: sender.tag, type: .Field)
    }
    
    /// unselects and unhighlights all image in HGCell
    func unselectImages() {
        
        for index in 0...7 {
            if let image = images[index] {
                image.backgroundColor(HGColor.Clear)
            }
        }
        
        selectedImages = []
    }
    
    /// unselects and unhighlights image
    func unselect(imagetag tag: Int) {
        
        if let image = images[tag] {
            image.backgroundColor(HGColor.Clear)
            selectedImages = selectedImages.filter() { $0 != tag }
        }
    }
    
    /// selects and highlights image if image is not already selected
    func select(imagetag tag: Int) {
        
        if selectedImages.contains(tag) { return }
        
        if let image = images[tag] {
            image.backgroundColor(HGColor.Blue)
            selectedImages.append(tag)
        }
    }
    
    // MARK: Set Fields and Buttons
    
    /// sets field with approprate tag and delegate
    private func set(field field: NSTextField?, withTag tag: Int) {
        guard let field = field else { return }
        field.delegate = self
        field.tag = tag
    }
    
    /// sets image with approprate tag and action
    private func set(imagebutton button: NSButton?, withTag tag: Int) {
        guard let button = button else { return }
        button.image = nil
        button.target = self
        button.action = "didSelectImage:"
        button.tag = tag
    }
    
    /// set check with appropriate tag and target
    private func set(checkbutton button: NSButton?, withTag tag: Int) {
        guard let button = button else { return }
        button.target = self
        button.tag = tag
    }
    
    // MARK: Update Cell Data
    
    /// Updates fields with HGFieldData (assumes [HGFieldData] is correctly ordered)
    private func update(withData data: [HGFieldData]) {
        let maxCount = min(data.count, fields.count)
        for var index = 0; index < maxCount; index++ {
            update(field: fields[index], withData: data[index])
        }
    }
    
    /// Updates images with HGImageData (assumes [HGImageData] is correctly ordered)
    private func update(withData data: [HGImageData]) {
        let maxCount = min(data.count, images.count)
        for var index = 0; index < maxCount; index++ {
            update(image: images[index], withData: data[index])
        }
    }
    
    /// Updates checks with HGCheckData (assumes [HGCheckData] is correctly ordered)
    private func update(withData data: [HGCheckData]) {
        let maxCount = min(data.count, checks.count)
        for var index = 0; index < maxCount; index++ {
            update(check: checks[index], withData: data[index])
        }
    }
    
    /// Updates a field with appropriate HGFieldData and makes field ready for custom display
    private func update(field field: NSTextField?, withData data: HGFieldData) {
        
        guard let field = field else { return }
        
        field.stringValue = data.title
        field.enabled = true
        field.hidden = false
        selectionSetup(field: field)
    }
    
    /// Updates an image with appropriate HGImageData and makes image ready for custom display
    private func update(image image: NSButton?, withData data: HGImageData) {
        
        guard let image = image else { return }
        
        /// If image is returned, use that, else, try to use title.
        if let dataImage = data.image {
            image.image = dataImage
        } else {
            image.image = NSImage(named: data.title)
        }
        
        image.enabled = true
        image.hidden = false
    }
    
    /// Updates an check with appropriate HGCheckData and makes check ready for custom display
    private func update(check check: NSButton?, withData data: HGCheckData) {
        
        guard let check = check else { return }
        
        check.title = data.title
        check.state = data.state == true ? 1 : 0
        check.enabled = true
        check.hidden = false
    }
    
    // MARK: Disable Cells
    
    /// Disables fields that do not have cooresponding HGFieldData (assumes [HGFieldData] is correctly ordered)
    private func disable(missingData data: [HGFieldData]) {
        if data.count < fields.count {
            for var index = data.count; index < fields.count; index++ {
                disable(field: fields[index])
            }
        }
    }
    
    /// Disables images that do not have cooresponding HGImageData (assumes [HGImageData] is correctly ordered)
    private func disable(missingData data: [HGImageData]) {
        if data.count < images.count {
            for var index = data.count; index < images.count; index++ {
                disable(image: images[index])
            }
        }
    }
    
    /// Disables checks that do not have cooresponding HGCheckData (assumes [HGCheckData] is correctly ordered)
    private func disable(missingData data: [HGCheckData]) {
        if data.count < checks.count {
            for var index = data.count; index < checks.count; index++ {
                disable(check: checks[index])
            }
        }
    }
    
    /// Disables field so that it will not be used by the HGCell
    private func disable(field field: NSTextField?) {
        
        guard let field = field else { return }
        
        field.stringValue = ""
        field.enabled = false
        field.hidden = true
        field.editable = false
        removeSelectFieldButton(field: field)
    }
    
    /// Disables image so that it will not be used by the HGCell
    private func disable(image image: NSButton?) {
        
        guard let image = image else { return }
        
        image.title = ""
        image.image = nil
        image.enabled = false
        image.hidden = true
    }
    
    /// Disables check so that it will not be used by the HGCell
    private func disable(check check: NSButton?) {
        
        guard let check = check else { return }
        
        check.title = ""
        check.state = 0
        check.enabled = false
        check.hidden = true
    }
    
    // MARK: Errors Reporting
    
    /// Reports an error if there is more data than cell objects available
    private func reportExtraDataErrorIfApplicable(cellCount cellCount: Int, dataCount: Int, typeOfObject: String) {
        //
    }
    
    // MARK: Field Select Button
    
    /// Sets up appropriate field selection button, edit ability, and field text color for a field by polling delegate
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
    
    /// Returns the appropriate field selection button for a field if it exists
    private func selectFieldButton(field field: NSTextField) -> NSButton? {
        for view in field.subviews {
            if let view = view as? NSButton where view.tag == field.tag { return view }
        }
        return nil
    }
    
    /// Adds a field selection button for a field
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
    
    /// Removes a field selection button from the field if the button exists
    private func removeSelectFieldButton(field field: NSTextField) {
        let button = selectFieldButton(field: field)
        button?.removeFromSuperview()
    }
    
    // MARK: NSTextFieldDelegate

    /// Returns a call to delegate to let the delegate know that the field was edited once editing is done
    func control(control: NSControl, textShouldEndEditing fieldEditor: NSText) -> Bool {
        let string = fieldEditor.string ?? ""
        let data = HGFieldData(title: string)
        delegate?.hgcell(self, didEditTag: control.tag, withData: data)
        return true
    }
}