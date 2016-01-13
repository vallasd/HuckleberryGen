////
////  AttributeVC.swift
////  HuckleberryGen
////
////  Created by David Vallas on 8/17/15.
////  Copyright © 2015 Phoenix Labs. All rights reserved.
////
//
import Cocoa

class AttributeVC: NSViewController {
    
    @IBOutlet weak var tableview: HGTableView!
    
    let attributeCell: HGCellType = HGCellType.DefaultCell
    let attributeTypeCell: HGCellType = HGCellType.Image6Cell
    let hgtable: HGTable = HGTable()

    private var editingLocation: HGCellLocation?
    
    // MARK: View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        hgtable.delegate = self
    }
}

// MARK: HGTableDisplayable
extension AttributeVC: HGTableDisplayable {
    
    func tableview(fortable table: HGTable) -> HGTableView! {
        return tableview
    }
    
    func numberOfRows(fortable table: HGTable) -> Int {
        return table.parentRow == notSelected ? 0 : appDelegate.store.project.entities[table.parentRow].attributes.count
    }
    
    func hgtable(table: HGTable, heightForRow row: Int) -> CGFloat {
        return 50.0
    }
    
    func hgtable(table: HGTable, cellForRow row: Int) -> HGCellType {
        return attributeCell
    }
    
    func hgtable(table: HGTable, dataForRow row: Int) -> HGCellData {
        
        let attribute = appDelegate.store.project.entities[table.parentRow].attributes[row]
        return HGCellData.defaultCell(
            field0: HGFieldData(title: attribute.name),
            field1: HGFieldData(title: ""),
            image0: HGImageData(title: "", image: attribute.image)
        )
    }
}

// MARK: HGTableObservable
extension AttributeVC: HGTableObservable {
    
    func observeNotification(fortable table: HGTable) -> String {
        return appDelegate.store.notificationName(forNotifType: .EntitySelected)
    }
}

// MARK: HGTableRowSelectable
extension AttributeVC: HGTableRowSelectable {
    
    func hgtable(table: HGTable, shouldSelectRow row: Int) -> Bool {
        return true
    }
}

// MARK: HGTableRowAppendable
extension AttributeVC: HGTableRowAppendable {
    
    func hgtable(shouldAddRowToTable table: HGTable) -> Bool  {
        return table.parentRow != notSelected
    }
    
    func hgtable(willAddRowToTable table: HGTable) {
        appDelegate.store.project.entities[table.parentRow].attributes.append(Attribute.new)
    }
    
    func hgtable(table: HGTable, shouldDeleteRows rows: [Int]) -> HGOption {
        return .Yes
    }
    
    func hgtable(table: HGTable, willDeleteRows rows: [Int]) {
        appDelegate.store.project.entities[table.parentRow].attributes.removeIndexes(rows)
    }
}

// MARK: HGTableItemEditable
extension AttributeVC: HGTableItemEditable {
    
    func hgtable(table: HGTable, shouldEditRow row: Int, tag: Int, type: HGCellItemType) -> HGOption {
        if type == .Field && tag == 0 { return .Yes } // Attribute Name
        if type == .Image && tag == 0 { return .AskUser } // Attribute Type
        return .No
    }
    
    func hgtable(table: HGTable, didEditRow row: Int, tag: Int, withData data: HGCellItemData) {
        if tag == 0 && data is HGFieldData {
            var attribute = appDelegate.store.project.entities[table.parentRow].attributes[row]
            attribute.name = data.title
            appDelegate.store.project.entities[table.parentRow].attributes[row] = attribute
        }
    }
}