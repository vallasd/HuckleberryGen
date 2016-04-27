////
////  AttributeVC.swift
////  HuckleberryGen
////
////  Created by David Vallas on 8/17/15.
////  Copyright © 2015 Phoenix Labs.
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
//  along with HuckleberryGen.  If not, see <http://www.gnu.org/licenses/>.//
//
import Cocoa

class AttributeVC: NSViewController {
    
    @IBOutlet weak var tableview: HGTableView!
    
    let celltype = CellType.DefaultCell
    
    var hgtable: HGTable!

    private var editingLocation: HGCellLocation?
    
    // MARK: View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        hgtable = HGTable(tableview: tableview, delegate: self)
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
    
    func hgtable(table: HGTable, cellForRow row: Int) -> CellType {
        return celltype
    }
    
    func hgtable(table: HGTable, dataForRow row: Int) -> HGCellData {
        
        let attribute = appDelegate.store.project.entities[table.parentRow].attributes[row]
        
        // define images and text going into attribute
        let varRep = attribute.varRep
        let typeRep = attribute.typeRep.lowerCaseFirstLetter
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
        return appDelegate.store.notificationNames(forNotifTypes: [.EntitySelected, .AttributeUpdated])
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
        var attribute = Attribute.new
        if let itr = attribute.iteratedVarRep(forArray: appDelegate.store.project.entities[table.parentRow].attributes) { attribute.varRep = itr }
        appDelegate.store.project.entities[table.parentRow].attributes.append(Attribute.new)
    }
    
    func hgtable(table: HGTable, shouldDeleteRows rows: [Int]) -> Option {
        return .Yes
    }
    
    func hgtable(table: HGTable, willDeleteRows rows: [Int]) {
        appDelegate.store.project.entities[table.parentRow].attributes.removeIndexes(rows)
    }
}

extension AttributeVC: HGTableItemSelectable {
    
    func hgtable(table: HGTable, shouldSelect row: Int, tag: Int, type: CellItemType) -> Bool {
        if type == .Image && tag == 0 {
            // present a selection board to update current Attribute
            let context = SBD_Attributes(entityIndex: table.parentRow, attributeIndex: row)
            let boarddata = SelectionBoard.boardData(withContext: context)
            appDelegate.mainWindowController.boardHandler.start(withBoardData: boarddata)
        }
        return false
    }
    
    func hgtable(table: HGTable, didSelectRow row: Int, tag: Int, type: CellItemType) {
        // Do Nothing
    }
}

extension AttributeVC: HGTableFieldEditable {
    
    func hgtable(table: HGTable, shouldEditRow row: Int, field: Int) -> Bool {
        if field == 0 { return true }
        return false
    }
    
    func hgtable(table: HGTable, didEditRow row: Int, field: Int, withString string: String) {
        
        var attribute = appDelegate.store.project.entities[table.parentRow].attributes[row]
        
        attribute.varRep = string.changeToVarRep ?? string
        
        appDelegate.store.project.entities[table.parentRow].attributes[row] = attribute
        
        table.update()
    }
}