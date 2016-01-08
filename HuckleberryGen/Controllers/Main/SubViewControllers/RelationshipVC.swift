////
////  RelationshipVC.swift
////  HuckleberryGen
////
////  Created by David Vallas on 8/17/15.
////  Copyright © 2015 Phoenix Labs. All rights reserved.
////
//
import Cocoa

class RelationshipVC: NSViewController {
    
    @IBOutlet weak var tableview: HGTableView!
    
    let hgtable: HGTable = HGTable()
    
    let cell: HGCellType = HGCellType.MixedCell1
    let typeCell = HGCellType.Image6Cell
    let entityCell = HGCellType.DefaultCell
    let deletionCell = HGCellType.DefaultCell
    
    weak var typeSelection: SelectionBoard?
    weak var entitySelection: SelectionBoard?
    weak var deletionSelection: SelectionBoard?
    
    // MARK: HGTableDisplayable
    
    let noentity: Int = notSelected
    private var editingLocation: HGCellLocation?
    
     // MARK: View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        hgtable.delegate = self
    }
}

// MARK: HGTableDisplayable
extension RelationshipVC: HGTableDisplayable {
    
    func tableview(fortable table: HGTable) -> HGTableView! {
        return tableview
    }
    
    func numberOfRows(fortable table: HGTable) -> Int {
        return table.parentRow == notSelected ? 0 : appDelegate.store.project.entities[table.parentRow].relationships.count
    }
    
    func hgtable(table: HGTable, heightForRow row: Int) -> CGFloat {
        return 65.0
    }
    
    func hgtable(table: HGTable, cellForRow row: Int) -> HGCellType {
        return cell
    }
    
    func hgtable(table: HGTable, dataForRow row: Int) -> HGCellData {
        
        let relationship = appDelegate.store.project.entities[table.parentRow].relationships[row]
        
        return HGCellData.mixedCell1(
            field0: HGFieldData(title: relationship.name),
            field1: HGFieldData(title: "Entity:"),
            field2: HGFieldData(title: relationship.entity),
            field3: HGFieldData(title: "Deletion Rule:"),
            field4: HGFieldData(title: relationship.deletionRule.string),
            image0: HGImageData(title: "", image: relationship.type.image)
        )
    }
}

// MARK: HGTableObservable
extension RelationshipVC: HGTableObservable {
    
    func observeNotification(fortable table: HGTable) -> String {
        return appDelegate.store.notificationName(forNotifType: .EntitySelected)
    }
}

// MARK: HGTableRowSelectable
extension RelationshipVC: HGTableRowSelectable {
    
    func hgtable(table: HGTable, shouldSelectRow row: Int) -> Bool {
        return true
    }
}

// MARK: HGTableRowAppendable
extension RelationshipVC: HGTableRowAppendable {
    
    func hgtable(shouldAddRowToTable table: HGTable) -> Bool  {
        return table.parentRow != notSelected
    }
    
    func hgtable(willAddRowToTable table: HGTable) {
        appDelegate.store.project.entities[table.parentRow].relationships.append(Relationship.new)
    }
    
    func hgtable(table: HGTable, shouldDeleteRows rows: [Int]) -> HGOption {
        return .Yes
    }
    
    func hgtable(table: HGTable, willDeleteRows rows: [Int]) {
        appDelegate.store.project.entities[table.parentRow].relationships.removeIndexes(rows)
    }
}

// MARK: HGTableItemEditable
extension RelationshipVC: HGTableItemEditable {
    
    func hgtable(table: HGTable, shouldEditRow row: Int, tag: Int, type: HGCellItemType) -> HGOption {
        if type == .Field && tag == 0 { return .Yes } // Relationship Name
        if type == .Field && (tag == 2 || tag == 4) { return .AskUser } // Entity or DeletionRule
        if type == .Image && tag == 0 { return .AskUser } // Relationship Type
        return .No
    }
    
    func hgtable(table: HGTable, didEditRow row: Int, tag: Int, withData data: HGCellItemData) {
        if tag == 0 && data is HGFieldData {
            var relationship = appDelegate.store.project.entities[table.parentRow].relationships[row]
            relationship.name = data.title
            appDelegate.store.project.entities[table.parentRow].relationships[row] = relationship
        }
    }
}

// MARK: HGTableItemOptionable
extension RelationshipVC: HGTableItemOptionable {
    
    func hgtable(table: HGTable, didSelectRowForOption row: Int, tag: Int, type: HGCellItemType) {
        
        // Relationship Type
        if type == .Image && tag == 0 {
            typeSelection = SelectionBoard.present(withParentTable: table)
            typeSelection?.boardDelegate = self
            typeSelection?.imageSource = self
        }
            
            // Relationship Entity
        else if type == .Field && tag == 2 {
            entitySelection = SelectionBoard.present(withParentTable: table)
            entitySelection?.boardDelegate = self
            entitySelection?.rowSource = self
        }
            
            // Relationship Deletion Rule
        else if type == .Field && tag == 4 {
            deletionSelection = SelectionBoard.present(withParentTable: table)
            deletionSelection?.boardDelegate = self
            deletionSelection?.imageSource = self
        }
        
        let identifier = HGCellItemIdentifier(tag: tag, type: type)
        editingLocation = HGCellLocation(row: row, identifier: identifier)
    }
}

// MARK: SelectionBoardDelegate
extension RelationshipVC: SelectionBoardDelegate {
    
    func hgcellType(forSelectionBoard sb: SelectionBoard) -> HGCellType {
        
        // Relationship Type
        if sb == typeSelection {
            return HGCellType.Image5Cell
        }
        
        // Relationship Enity / Deletion Rule
        return HGCellType.FieldCell1
    }
    
    func selectionboard(sb: SelectionBoard, didChoose items: [Int]) {
        
        guard let el = editingLocation else { return }
        
        let item = items[0]
        var relationship = appDelegate.store.project.entities[hgtable.parentRow].relationships[el.row]
        
        if sb == typeSelection {
            relationship.type = RelationshipType.create(int: item)
        }
        
        if sb == entitySelection {
            relationship.entity = appDelegate.store.project.entities[item].name
        }
        
        if sb == deletionSelection {
            relationship.deletionRule = DeletionRule.create(int: item)
        }
        
        appDelegate.store.project.entities[hgtable.parentRow].relationships[el.row] = relationship
        editingLocation = nil
    }
    
    func numberOfItems(forSelectionBoard sb: SelectionBoard) -> Int {
        
        if sb === entitySelection {
            return appDelegate.store.project.entities.count
        }
        
        if sb === deletionSelection {
            return DeletionRule.set.count
        }
        
        if sb == typeSelection {
            return RelationshipType.imageStringSet.count
        }
        
        return 0
    }
}

// MARK: SelectionBoardDataSource
extension RelationshipVC: SelectionBoardRowSource {
    
    func selectionboard(sb: SelectionBoard, dataForRow row: Int) -> HGCellData {
        
        if sb == entitySelection {
            return HGCellData.fieldCell1(
                field0: HGFieldData(title: appDelegate.store.project.entities[row].name)
            )
        }
        
        if sb == deletionSelection {
            return HGCellData.fieldCell1(
                field0: HGFieldData(title: DeletionRule.create(int: row).string)
            )
        }
        
        return HGCellData.empty
    }
}

// MARK: SelectionBoardImageSource
extension RelationshipVC: SelectionBoardImageSource {
    
    func selectionboard(sb: SelectionBoard, imageDataForIndex index: Int) -> HGImageData {
        
        // Relation Type
        if sb == typeSelection {
            return HGImageData(title: "", image: RelationshipType.create(int: index).image)
        }
        
        // Relationship Entity / Deletion Rule will use DataSource Protocol
        return HGImageData(title: "", image: nil)
    }
}