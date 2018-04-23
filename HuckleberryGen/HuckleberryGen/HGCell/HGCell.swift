//
//  HGCell.swift
//  HuckleberryGen
//
//  Created by David Vallas on 9/3/15.
//  Copyright © 2015 Phoenix Labs.
//
//  All Rights Reserved.

import Cocoa

enum Option {
    case yes
    case no
    case askUser // Will Display a Prompt
}

enum CellItemType: Int16 {
    case field
    case image
    case check
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
    static func locations(fromIndexSet set: IndexSet) -> [HGCellLocation] {
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
    let type: CellItemType
    
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
    func hgcell(_ cell: HGCell, shouldSelectTag tag: Int, type: CellItemType) -> Bool
    func hgcell(_ cell: HGCell, didSelectTag tag: Int, type: CellItemType)
    func hgcell(_ cell: HGCell, shouldEditField field: Int) -> Bool
    func hgcell(_ cell: HGCell, didEditField field: Int, withString string: String)
}



class HGCell: NSTableCellView, NSTextFieldDelegate {
    
    // MARK: @IBOutlets
    
    @IBOutlet weak var image0: NSButton?
    
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
    
    fileprivate(set) var row: Int = 0
    fileprivate(set) var selectedImages: [Int] = []
    
    /// use to determine number of images in an imageCell
    fileprivate var imageCellCount: Int?
    fileprivate var shouldUpdateConstraintsForImageCells = false
    fileprivate var spacers: [NSView] = []
    
    /// ordered array of images for HGCell
    lazy var images: [NSButton?] = {
        
        self.backgroundColor(HGColor.orange)
        
        let _images = imageCellCount != nil ? createImages() : [image0]
        
        var index = 0
        for image in _images {
            self.set(imagebutton: image, withTag: index)
            index += 1
        }
        
        return _images
    }()
    
    /// ordered array of fields for HGCell
    lazy var fields: [NSTextField?] = {
        let _fields = [field0, field1, field2, field3, field4, field5, field6, field7]
        for index in 0...7 {
            self.set(field: _fields[index], withTag: index)
        }
        return _fields
    }()
    
    /// ordered array of checks for HGCell
    lazy var checks: [NSButton?] = {
        let _checks = [check0, check1, check2, check3]
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
        
        // Update and/or Clear Checks
        update(withData: cellData.checks)
        disable(missingData: cellData.checks)
    }
    
    // MARK: Button and Field Target Actions
    
    /// function called when user selects an image
    @objc func didSelectImage(_ sender: NSButton!) {
        // We can not select an image in HGCell
        let shouldSelect = delegate?.hgcell(self, shouldSelectTag: sender.tag, type: .image) ?? false
        if shouldSelect == true {
            delegate?.hgcell(self, didSelectTag: sender.tag, type: .image)
        }
    }
    
    /// function called when a user selects a field (if field is selectable)
    @objc func didSelectField(_ sender: NSTextField!) {
        delegate?.hgcell(self, didSelectTag: sender.tag, type: .field)
    }
    
    /// unselects and unhighlights all image in HGCell
    func unselectImages() {
        
        for image in images {
            image?.backgroundColor(HGColor.clear)
        }
        selectedImages = []
    }
    
    /// unselects and unhighlights image
    func unselect(imagetag tag: Int) {
        
        if let image = images[tag] {
            image.backgroundColor(HGColor.clear)
            selectedImages = selectedImages.filter() { $0 != tag }
        }
    }
    
    /// selects and highlights image if image is not already selected
    func select(imagetag tag: Int) {
        
        if selectedImages.contains(tag) { return }
        
        if let image = images[tag] {
            image.backgroundColor(HGColor.blueBright)
            selectedImages.append(tag)
        }
    }
    
    // MARK: Set Fields and Buttons
    
    /// sets field with approprate tag and delegate
    fileprivate func set(field: NSTextField?, withTag tag: Int) {
        guard let field = field else { return }
        field.delegate = self
        field.tag = tag
    }
    
    /// sets image with approprate tag and action
    fileprivate func set(imagebutton button: NSButton?, withTag tag: Int) {
        guard let button = button else { return }
        button.image = nil
        button.target = self
        button.action = #selector(HGCell.didSelectImage(_:))
        button.tag = tag
    }
    
    /// set check with appropriate tag and target
    fileprivate func set(checkbutton button: NSButton?, withTag tag: Int) {
        guard let button = button else { return }
        button.target = self
        button.tag = tag
    }
    
    // MARK: Update Cell Data
    
    /// Updates fields with HGFieldData (assumes [HGFieldData] is correctly ordered)
    fileprivate func update(withData data: [HGFieldData]) {
        let maxCount = min(data.count, fields.count)
        for index in 0 ..< maxCount {
            update(field: fields[index], withData: data[index])
        }
    }
    
    /// Updates images with HGImageData (assumes [HGImageData] is correctly ordered)
    fileprivate func update(withData data: [HGImageData]) {
        
        // if we are provide more than one HGImageData, we assume this is an ImageCell
        if data.count > 1 {
            imageCellCount = data.count
        }
        
        for index in 0 ..< data.count {
            update(image: images[index], withData: data[index])
        }
    }
    
    /// Updates checks with HGCheckData (assumes [HGCheckData] is correctly ordered)
    fileprivate func update(withData data: [HGCheckData]) {
        let maxCount = min(data.count, checks.count)
        for index in 0 ..< maxCount {
            update(check: checks[index], withData: data[index])
        }
    }
    
    /// Updates a field with appropriate HGFieldData and makes field ready for custom display
    fileprivate func update(field: NSTextField?, withData data: HGFieldData) {
        
        guard let field = field else { return }
        
        field.stringValue = data.title
        field.isEnabled = true
        field.isHidden = false
        selectionSetup(field: field)
    }
    
    /// Updates an image with appropriate HGImageData and makes image ready for custom display
    fileprivate func update(image: NSButton?, withData data: HGImageData) {
        
        guard let image = image else { return }
        
        /// If image is returned, use that, else, try to use title.
        if let dataImage = data.image {
            image.image = dataImage
        } else {
            image.image = NSImage(named: NSImage.Name(rawValue: data.title))
        }
        
        image.isEnabled = true
        image.isHidden = false
    }
    
    /// Updates an check with appropriate HGCheckData and makes check ready for custom display
    fileprivate func update(check: NSButton?, withData data: HGCheckData) {
        
        guard let check = check else { return }
        
        check.title = data.title
        check.state = NSControl.StateValue(rawValue: data.state == true ? 1 : 0)
        check.isEnabled = true
        check.isHidden = false
    }
    
    // MARK: Disable Cells
    
    /// Disables fields that do not have cooresponding HGFieldData (assumes [HGFieldData] is correctly ordered)
    fileprivate func disable(missingData data: [HGFieldData]) {
        if data.count < fields.count {
            for index in data.count ..< fields.count {
                disable(field: fields[index])
            }
        }
    }
    
    /// Disables images that do not have cooresponding HGImageData (assumes [HGImageData] is correctly ordered)
    fileprivate func disable(missingData data: [HGImageData]) {
        if data.count < images.count {
            for index in data.count ..< images.count {
                disable(image: images[index])
            }
        }
    }
    
    /// Disables checks that do not have cooresponding HGCheckData (assumes [HGCheckData] is correctly ordered)
    fileprivate func disable(missingData data: [HGCheckData]) {
        if data.count < checks.count {
            for index in data.count ..< checks.count {
                disable(check: checks[index])
            }
        }
    }
    
    /// Disables field so that it will not be used by the HGCell
    fileprivate func disable(field: NSTextField?) {
        
        guard let field = field else { return }
        
        field.stringValue = ""
        field.isEnabled = false
        field.isHidden = true
        field.isEditable = false
        removeSelectFieldButton(field: field)
    }
    
    /// Disables image so that it will not be used by the HGCell
    fileprivate func disable(image: NSButton?) {
        
        guard let image = image else { return }
        
        image.title = ""
        image.image = nil
        image.isEnabled = false
        image.isHidden = true
    }
    
    /// Disables check so that it will not be used by the HGCell
    fileprivate func disable(check: NSButton?) {
        
        guard let check = check else { return }
        
        check.title = ""
        check.state = NSControl.StateValue(rawValue: 0)
        check.isEnabled = false
        check.isHidden = true
    }
    
    // MARK: Create image buttons for ImageCell
    
    /// creates image buttons based on imageCount that was set
    fileprivate func createImages() -> [NSButton?] {
        
        // this is may be a recycled cell, just return buttons if so
        let buttons = subviews.filter { $0 is NSButton } as! [NSButton]
        if buttons.count == imageCellCount {
            return buttons
        }
        
        // check errors
        if errorInImageProcessing() {
            return []
        }
        
        // set image and count
        let image = image0!
        let count = imageCellCount!
        
        // remove all subviews, cleaning up cell
        let _ = self.subviews.map { if $0 !== image { $0.removeFromSuperview() } }
        
        // create copies of images from initial image
        var images: [NSButton] = []
        
        var i = 0
        while i < count {
            let copy = image.copy
            images.append(copy)
            self.addSubview(copy)
            i += 1
        }
        
        // create spacers
        spacers = []
        for _ in 0..<images.count - 1 {
            let spacer = NSView.spacer
            self.addSubview(spacer)
            spacers.append(spacer)
        }
        
        // replace image0 with copy
        image0?.removeFromSuperview()
        image0 = images[0]
        shouldUpdateConstraintsForImageCells = true
        
        return images
    }
    
    override func updateConstraints() {

        // we don't need to update any constraints
        if shouldUpdateConstraintsForImageCells == false || self.images.count == 0 {
            super.updateConstraints()
            return
        }
        
        // set check to false since we are updating constraints
        shouldUpdateConstraintsForImageCells = false
        
        // get image buttons
        let images = self.images as! [NSButton]

        // remove existing constraints
        for constraint in self.constraints {
            print("C: \(constraint)")
        }
        
        // set border spacing
        let bp: CGFloat = 4.0
        
        // add top, bottom, aspect ratio to image buttons
        var index = 0
        for image in images {
            self.addConstraints([NSLayoutConstraint.bottom(view: image, superView: self, spacing: bp),
                                 NSLayoutConstraint.top(view: image, superView: self, spacing: bp)
                ])
            image.addConstraint(NSLayoutConstraint.aspectRatio(view: image, ratio: 1.0))
            index += 1
        }
        
        // add leading constraint
        let first = images.first!
        self.addConstraint(NSLayoutConstraint.leading(view: first, superView: self, spacing: bp))
        
        // if we only had one image we are done
        if images.count == 1 {
            super.updateConstraints()
            return
        }
        
        // add trailing constraint
        let last = images.last!
        self.addConstraint(NSLayoutConstraint.trailing(view: last, superView: self, spacing: bp))
        
        // update spacers
        index = 0
        for spacer in spacers {
            let left = images[index]
            let right = images[index + 1]
            self.addConstraints([NSLayoutConstraint.horizontal(left: left, right: spacer, spacing: bp),
                                 NSLayoutConstraint.horizontal(left: spacer, right: right, spacing: bp),
                                 NSLayoutConstraint.bottom(view: spacer, superView: self, spacing: bp),
                                 NSLayoutConstraint.top(view: spacer, superView: self, spacing: bp)
                ])
            
//            if index > 0 {
//                let left = spacers[index - 1]
//                let c = NSLayoutConstraint.width(view1: spacer, toView: left, multipler: 1)
//                c.priority = c.priority + 1
//                self.addConstraint(c)
//            }
            
            index += 1
        }
        
        super.updateConstraints()
    }
    
//    /// adds all constraints for the image buttons and returns the spacers between the image buttons
//    fileprivate func addImageConstraints(images: [NSButton]) {
//
//        //
//
//        // remove existing constraints
//        self.removeAllConstraints()
//
//        // add constraints for left most image
//        let left = images.first!
//        self.addConstraints([NSLayoutConstraint.bottom(view: left, superView: self, spacing: 0),
//                             NSLayoutConstraint.top(view: left, superView: self, spacing: 0),
//                             NSLayoutConstraint.leading(view: left, superView: self, spacing: 0)])
//
//        // if we only had one image we are done
//        if images.count == 1 { return }
//
//        // create spacers
////        var spacers: [NSView] = []
////        for _ in 0..<images.count - 1 {
////            let spacer = NSView(frame: left.frame)
////            spacer.backgroundColor(.cyan)
////            self.addSubview(spacer)
////            spacers.append(spacer)
////        }
//
//        // add constraints for right most image
//        let right = images.last!
//        self.addConstraints([NSLayoutConstraint.bottom(view: right, superView: self, spacing: 0),
//                             NSLayoutConstraint.top(view: right, superView: self, spacing: 0),
//                             NSLayoutConstraint.trailing(view: right, superView: self, spacing: 0)])
//
//
//    }
    
    
    /// checks if there are any errors encountered before creating new image buttons
    fileprivate func errorInImageProcessing() -> Bool {
        
        // is image0 valid
        guard let _ = image0 else {
            let msg = "unable to retrieve |image0| in |HGCell|"
            HGReportHandler.shared.report(msg, type: .error)
            return true
        }
        
        // is imageCellCount set and valid
        guard let imageCount = imageCellCount, imageCount > 0 else {
            let msg = "imageCellCount is |\(String(describing: imageCellCount))| in |HGCell|"
            HGReportHandler.shared.report(msg, type: .error)
            return true
        }
        
        return false
    }
    
    // MARK: Field Select Button
    
    /// Sets up appropriate field selection button, edit ability, and field text color for a field by polling delegate
    fileprivate func selectionSetup(field: NSTextField) {
        
        let shouldSelect = delegate?.hgcell(self, shouldSelectTag: field.tag, type: .field) ?? false
        
        // Selectable Field
        if shouldSelect {
            field.isEditable = false
            field.textColor = NSColor.blue
            addSelectFieldButton(field: field)
            return
        }
        
        let shouldEdit = delegate?.hgcell(self, shouldEditField: field.tag) ?? false
        
        // Editable Field
        if shouldEdit {
            field.isEditable = true
            field.textColor = NSColor.blue
            updateSpecialType(forField: field)
            removeSelectFieldButton(field: field)
            return
        }
        
        // Not Selectable or Editable Field (Just Displayable)
        field.isEditable = false
        field.textColor = NSColor.black
        removeSelectFieldButton(field: field)
    }
    
    /// update specials data for special types
    func updateSpecialType(forField field: NSTextField) {
        guard let stype = SpecialAttribute.specialTypeFrom(varRep: field.stringValue) else { return }
        field.textColor = stype.color
        image0?.image  = stype.image
    }
    
    /// Returns the appropriate field selection button for a field if it exists
    fileprivate func selectFieldButton(field: NSTextField) -> NSButton? {
        for view in field.subviews {
            if let view = view as? NSButton, view.tag == field.tag { return view }
        }
        return nil
    }
    
    /// Adds a field selection button for a field
    fileprivate func addSelectFieldButton(field: NSTextField) {
        if selectFieldButton(field: field) != nil { return }
        let frame = NSRect(x: 0, y: 0, width: field.frame.width, height: field.frame.height)
        let button = NSButton(frame: frame)
        button.tag = field.tag
        button.title = ""
        button.alphaValue = 0.1 // Hides button but it is still functional
        button.action = #selector(HGCell.didSelectField(_:))
        button.target = self
        field.addSubview(button)
    }
    
    /// Removes a field selection button from the field if the button exists
    fileprivate func removeSelectFieldButton(field: NSTextField) {
        let button = selectFieldButton(field: field)
        button?.removeFromSuperview()
    }
    
    // MARK: NSTextFieldDelegate

    /// Returns a call to delegate to let the delegate know that the field was edited once editing is done
    func control(_ control: NSControl, textShouldEndEditing fieldEditor: NSText) -> Bool {
        let string = fieldEditor.string
        
        // update color in a bit
        delay(0.4) {
            guard let field = self.fields[control.tag] else { return }
            self.selectionSetup(field: field)
        }
        
        delegate?.hgcell(self, didEditField: control.tag, withString: string)
        return true
    }
    
}
