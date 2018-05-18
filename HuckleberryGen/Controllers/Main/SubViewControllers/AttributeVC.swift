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
    
    var primitiveAttributes: [PrimitiveAttribute] = []
    var enumAttributes: [EnumAttribute] = []
    var entityAttributes: [EntityAttribute] = []
    var firstEnumIndex: Int { return primitiveAttributes.count }
    var firstEntityIndex: Int { return primitiveAttributes.count + enumAttributes.count }
    
    fileprivate func name(givenIndex index: Int) -> String {
        if index < firstEnumIndex { return primitiveAttributes[index].name }
        if index < firstEntityIndex { return enumAttributes[index - primitiveAttributes.count].name }
        return entityAttributes[index - primitiveAttributes.count - enumAttributes.count].name
    }
    
    // MARK: View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        hgtable = HGTable(tableview: tableview, delegate: self)
    }
}

extension AttributeVC: HGTableDisplayable {
    
    func numberOfItems(fortable table: HGTable) -> Int {
        if table.parentName != "" {
            primitiveAttributes = project.primitiveAttributes.filter { $0.holderName == table.parentName }.sorted { $0.name < $1.name }
            enumAttributes = project.enumAttributes.filter { $0.holderName == table.parentName }.sorted { $0.name < $1.name }
            entityAttributes = project.entityAttributes.filter { $0.holderName == table.parentName }.sorted { $0.name < $1.name }
            return primitiveAttributes.count + enumAttributes.count + entityAttributes.count
        }
        
        return 0
    }
    
    func cellType(fortable table: HGTable) -> CellType {
        return CellType.defaultCell
    }
    
    func hgtable(_ table: HGTable, dataForIndex index: Int) -> HGCellData {
        
        // create primitive attribute data cell
        if index < firstEnumIndex {
            let attribute = attributes[index]
            let image = attribute.image
            return HGCellData.defaultCell(
                field0: HGFieldData(title: attribute.name),
                field1: HGFieldData(title: ""),
                image0: HGImageData(image: image)
            )
        }
        
        // create enumAttribute data cell
        if index < firstEntityIndex {
            let enumAttribute = enumAttributes[index - firstEnumIndex]
            let image = enumAttribute.image
            return HGCellData.defaultCell(
                field0: HGFieldData(title: enumAttribute.name),
                field1: HGFieldData(title: ""),
                image0: HGImageData(image: image)
            )
        }
        
        // create entityAttribute data cell
        let entityAttribute = entityAttributes[index - firstEntityIndex]
        let image = entityAttribute.image
        return HGCellData.defaultCell(
            field0: HGFieldData(title: entityAttribute.name),
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
        return table.parentIndex != notSelected
    }
    
    func hgtable(willAddRowToTable table: HGTable) {
        let attribute = project.createIteratedAttribute(entityName: table.parentName) ?? Attribute.encodeError
        attributes.append(attribute)
    }
    
    func hgtable(_ table: HGTable, shouldDeleteRows rows: [Int]) -> Option {
        return .yes
    }
    
    func hgtable(_ table: HGTable, willDeleteRows rows: [Int]) {
        
        for row in rows {
            let n = name(givenIndex: row)
            if row < firstEnumIndex {
                let success = project.deleteAttribute(name: n, entityName: table.parentName)
                if success {
                    attributes.remove(at: row)
                }
            } else if row < firstEntityIndex {
                let success = project.deleteEnumAttribute(name: n, holderName: table.parentName)
                if success {
                    enumAttributes.remove(at: row - firstEnumIndex)
                }
            } else {
                let success = project.deleteEntityAttribute(name: n, holderName: table.parentName)
                if success {
                    enumAttributes.remove(at: row - firstEntityIndex)
                }
            }
        }
    }
}

extension AttributeVC: HGTableLocationSelectable {
    
    func hgtable(_ table: HGTable, shouldSelectLocation loc: HGTableLocation) -> Bool {
        
        if loc.type == .row {
            return true
        }
        
        // present a selection board to update current Attribute
        if loc.type == .image && loc.typeIndex == 0 {
            let n = name(givenIndex: loc.index)
            let context = SBD_Attributes(holderName: table.parentName, name: n)
            context.delegate = self
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
        
        // create attribute data cell
        if row < firstEnumIndex {
            let n = name(givenIndex: row)
            let keyDict: AttributeKeyDict = [.name: string]
            let attribute = project.updateAttribute(keyDict: keyDict, name: n, entityName: table.parentName)
            if attribute != nil {
                attributes[row] = attribute!
            }
            return
        }
        
        // create enumAttribute data cell
        if row < firstEnumIndex {
            let n = name(givenIndex: row)
            let keyDict: EnumAttributeKeyDict = [.name: string]
            let enumAttribute = project.updateEnumAttribute(keyDict: keyDict, name: n, holderName: table.parentName)
            if enumAttribute != nil {
                enumAttributes[row - firstEnumIndex] = enumAttribute!
            }
            return
        }
        
        // create entityAttribute data cell
        let n = name(givenIndex: row)
        let keyDict: EntityAttributeKeyDict = [.name: string]
        let entityAttribute = project.updateEntityAttribute(keyDict: keyDict, name: n, holderName: table.parentName)
        if entityAttribute != nil {
            entityAttributes[row - firstEntityIndex] = entityAttribute!
        }
        return
    }
}

extension AttributeVC: SBD_AttributeDelegate {
    
    func sbd_attribute(_: SBD_Attributes, didUpdateType: HGType) {
        hgtable.update()
    }
    
}
