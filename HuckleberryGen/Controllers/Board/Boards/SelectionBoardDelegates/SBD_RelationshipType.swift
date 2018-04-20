//
//  SBD_RelationshipType.swift
//  HuckleberryGen
//
//  Created by David Vallas on 1/12/16.
//  Copyright © 2016 Phoenix Labs.
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
//  along with HuckleberryGen.  If not, see <http://www.gnu.org/licenses/>.

import Cocoa

/// context for a Selection Board of unique attributes
class SBD_RelationshipType: SelectionBoardDelegate {
    
    /// reference to the selection board
    weak var selectionBoard: SelectionBoard?
    
    /// index of Entity to be updated
    let entityIndex: Int!
    
    /// index of Relationship to be updated
    let relationshipIndex: Int!
    
    /// reference to the cell type used
    let celltype = CellType.image3Cell
    
    /// a list of strings of all attributes that can be assigned (AttributeTypes and Enums)
    let relationshipTypes: [RelationshipType] = RelationshipType.set
    
    /// initializes object with relationship and entity indexes
    init(entityIndex: Int, relationshipIndex: Int) {
        self.entityIndex = entityIndex
        self.relationshipIndex = relationshipIndex
    }
    
    /// creates an array of HGImageData for an array indexes in attribute
    func cellImageDatas(forAttributeIndexes indexes: [Int]) -> [HGImageData] {
        var imagedatas: [HGImageData] = []
        for index in indexes {
            let type = relationshipTypes[index]
            let image = type.image
            let imagedata = HGImageData(title: "", image: image)
            imagedatas.append(imagedata)
        }
        return imagedatas
    }
    
    func selectionboard(_ sb: SelectionBoard, didChooseLocations locations: [HGCellLocation]) {
        let index = celltype.index(forlocation: locations[0])
        let relationshiptype = RelationshipType.create(int: index)
        appDelegate.store.project.entities[entityIndex].relationships[relationshipIndex].relType = relationshiptype
        appDelegate.store.post(forNotifType: .relationshipUpdated) // post notification so other classes are in the know
    }
}

// MARK: HGTableDisplayable
extension SBD_RelationshipType: HGTableDisplayable {
    
    func numberOfRows(fortable table: HGTable) -> Int {
        let numImages = relationshipTypes.count
        let numRows = celltype.rows(forImagesWithCount: numImages)
        return numRows
    }
    
    func hgtable(_ table: HGTable, heightForRow row: Int) -> CGFloat {
        return celltype.rowHeightForTable(selectionBoard?.tableview)
    }
    
    func hgtable(_ table: HGTable, cellForRow row: Int) -> CellType {
        return celltype
    }
    
    func hgtable(_ table: HGTable, dataForRow row: Int) -> HGCellData {
        let imageIndexes = celltype.imageIndexes(forRow: row, imageCount: relationshipTypes.count)
        let imagedatas = cellImageDatas(forAttributeIndexes: imageIndexes)
        return HGCellData.onlyImages(imagedatas)
    }
}

extension SBD_RelationshipType: HGTableItemSelectable {
    
    func hgtable(_ table: HGTable, shouldSelect row: Int, tag: Int, type: CellItemType) -> Bool {
        return true
    }
    
    func hgtable(_ table: HGTable, didSelectRow row: Int, tag: Int, type: CellItemType) {
        // Do Nothing
    }
}
