////
////  AttributeVC.swift
////  HuckleberryGen
////
////  Created by David Vallas on 8/17/15.
////  Copyright © 2015 Phoenix Labs.
//
//  All Rights Reserved.//
//
import Cocoa

class AttributeVC: NSViewController {
    
    @IBOutlet weak var tableview: HGTableView!
    
    let celltype = CellType.defaultCell
    
    var hgtable: HGTable!

    fileprivate var editingLocation: HGTableLocation?
    
    // MARK: View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        hgtable = HGTable(tableview: tableview, delegate: self)
    }
}

// MARK: HGTableDisplayable
extension AttributeVC: HGTableDisplayable {
    
    func numberOfItems(fortable table: HGTable) -> Int {
        return table.parentRow == notSelected ? 0 : appDelegate.store.project.entities[table.parentRow].attributes.count
    }
    
    func cellType(fortable table: HGTable) -> CellType {
        return celltype
    }
    
    func hgtable(_ table: HGTable, dataForIndex index: Int) -> HGCellData {
        
        let attribute = appDelegate.store.project.entities[table.parentRow].attributes[index]
        
        // define images and text going into attribute
        let varRep = attribute.varRep
        let typeRep = attribute.typeRep.lowerFirstLetter
        var image: NSImage
        
        // set appropriate images if they are special types, else get image for type
        if let stype = SpecialAttribute.specialTypeFrom(varRep: varRep) {
            image = stype.image
        } else {
            image = attribute.typeImage
        }
        
        return HGCellData.defaultCell(
            field0: HGFieldData(title: varRep),
            field1: HGFieldData(title: ""),
            image0: HGImageData(title: typeRep, image: image)
        )
    }
}

// MARK: HGTableObservable
extension AttributeVC: HGTableObservable {
    
    func observeNotifications(fortable table: HGTable) -> [String] {
        return appDelegate.store.notificationNames(forNotifTypes: [.entitySelected, .attributeUpdated])
    }
}

// MARK: HGTableRowSelectable
extension AttributeVC: HGTableRowSelectable {
    
    func hgtable(_ table: HGTable, shouldSelectRow row: Int) -> Bool {
        return true
    }
}

// MARK: HGTableRowAppendable
extension AttributeVC: HGTableRowAppendable {
    
    func hgtable(shouldAddRowToTable table: HGTable) -> Bool  {
        return table.parentRow != notSelected
    }
    
    func hgtable(willAddRowToTable table: HGTable) {
        var attribute = Attribute.new
        if let itr = attribute.iteratedVarRep(forArray: appDelegate.store.project.entities[table.parentRow].attributes) { attribute.varRep = itr }
        appDelegate.store.project.entities[table.parentRow].attributes.append(Attribute.new)
    }
    
    func hgtable(_ table: HGTable, shouldDeleteRows rows: [Int]) -> Option {
        return .yes
    }
    
    func hgtable(_ table: HGTable, willDeleteRows rows: [Int]) {
        appDelegate.store.project.entities[table.parentRow].attributes.removeIndexes(rows)
    }
}

extension AttributeVC: HGTableItemSelectable {
    
    func hgtable(_ table: HGTable, shouldSelect row: Int, tag: Int, type: CellItemType) -> Bool {
        if type == .image && tag == 0 {
            // present a selection board to update current Attribute
            let context = SBD_Attributes(entityIndex: table.parentRow, attributeIndex: row)
            let boarddata = SelectionBoard.boardData(withContext: context)
            appDelegate.mainWindowController.boardHandler.start(withBoardData: boarddata)
        }
        return false
    }
    
    func hgtable(_ table: HGTable, didSelectRow row: Int, tag: Int, type: CellItemType) {
        // Do Nothing
    }
}

extension AttributeVC: HGTableFieldEditable {
    
    func hgtable(_ table: HGTable, shouldEditRow row: Int, field: Int) -> Bool {
        if field == 0 { return true }
        return false
    }
    
    func hgtable(_ table: HGTable, didEditRow row: Int, field: Int, withString string: String) {
        
        var attribute = appDelegate.store.project.entities[table.parentRow].attributes[row]
        
        attribute.varRep = string.changeToVarRep ?? string
        
        appDelegate.store.project.entities[table.parentRow].attributes[row] = attribute
        
        table.update()
    }
}
