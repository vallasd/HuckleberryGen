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
    
    var hgtable: HGTable!

    fileprivate var editingLocation: HGTableLocation?
    
    // MARK: View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        hgtable = HGTable(tableview: tableview, delegate: self)
    }
}

extension AttributeVC: HGTableDisplayable {
    
    func numberOfItems(fortable table: HGTable) -> Int {
        return table.parentRow == notSelected ? 0 : appDelegate.store.project.entities[table.parentRow].attributes.count
    }
    
    func cellType(fortable table: HGTable) -> CellType {
        return CellType.defaultCell
    }
    
    func hgtable(_ table: HGTable, dataForIndex index: Int) -> HGCellData {
        
        let attribute = appDelegate.store.project.entities[table.parentRow].attributes[index]
        
        // define images and text going into attribute
        let image = attribute.type.image
        
        return HGCellData.defaultCell(
            field0: HGFieldData(title: name),
            field1: HGFieldData(title: ""),
            image0: HGImageData(image: image)
        )
    }
}

extension AttributeVC: HGTableObservable {
    
    func observeNotifications(fortable table: HGTable) -> [String] {
        return appDelegate.store.notificationNames(forNotifTypes: [.entitySelected, .attributeUpdated])
    }
}

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

extension AttributeVC: HGTableLocationSelectable {
    
    func hgtable(_ table: HGTable, shouldSelectLocation loc: HGTableLocation) -> Bool {
        
        if loc.type == .row {
            return true
        }
        
        // present a selection board to update current Attribute
        if loc.type == .image && loc.typeIndex == 0 {
            let context = SBD_Attributes(entityIndex: table.parentRow, attributeIndex: loc.index)
            let boarddata = SelectionBoard.boardData(withContext: context)
            appDelegate.mainWindowController.boardHandler.start(withBoardData: boarddata)
        }
        return false
    }
    
    func hgtable(_ table: HGTable, didSelectLocation loc: HGTableLocation) {
        // do nothing
    }
}

extension AttributeVC: HGTableFieldEditable {
    
    func hgtable(_ table: HGTable, shouldEditRow row: Int, field: Int) -> Bool {
        if field == 0 { return true }
        return false
    }
    
    func hgtable(_ table: HGTable, didEditRow row: Int, field: Int, withString string: String) {
        
        var attribute = appDelegate.store.project.entities[table.parentRow].attributes[row]
        
        attribute.name = string.changeToVarRep ?? string
        
        appDelegate.store.project.entities[table.parentRow].attributes[row] = attribute
        
        table.update()
    }
}
