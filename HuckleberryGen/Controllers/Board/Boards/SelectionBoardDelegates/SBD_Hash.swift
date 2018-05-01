////
////  SBD_Hash.swift
////  HuckleberryGen
////
////  Created by David Vallas on 1/31/16.
////  Copyright © 2016 Phoenix Labs.
////
////  All Rights Reserved.
//
//import Foundation
//
//
//class SBD_Hash: SelectionBoardDelegate {
//    
//    var index: Int
//    var hashes: [Attribute]
//    
//    init(entityIndex ei: Int, hashes h: [Attribute]) {
//        index = ei
//        hashes = h
//    }
//    
//    /// reference to the selection board
//    weak var selectionBoard: SelectionBoard? {
//        didSet {
//            selectionBoard?.automaticNext = true
//        }
//    }
//    
//    /// SelectionBoardDelegate function
//    func selectionboard(_ sb: SelectionBoard, didChooseLocation loc: HGTableLocation) {
//        // add selected hash
//        let hash = hashes[loc.index]
//        appDelegate.store.add(hash: hash, atEntityIndex: index)
//        appDelegate.store.post(forNotifType: .entityUpdated) // post notification so other classes are in the know
//    }
//    
//    func cellImageDatas(forAttributeIndexes indexes: [Int]) -> [HGImageData] {
//        var imagedatas: [HGImageData] = []
//        for index in indexes {
//            let hash = hashes[index]
//            let imagedata = HGImageData(title: hash.name, image: hash.image)
//            imagedatas.append(imagedata)
//        }
//        return imagedatas
//    }
//}
//
//extension SBD_Hash: SelectionBoardNoSelectionDelegate {
//    
//    func selectionBoardDidNotChooseLocation(_ sb: SelectionBoard) {
//        // remove all hashes from entity
//        // appDelegate.store.removeHashes(atEntityIndex: index)
//        appDelegate.store.post(forNotifType: .entityUpdated) // post notification so other classes are in the know
//    }
//}
//
//extension SBD_Hash: HGTableDisplayable {
//    
//    func numberOfItems(fortable table: HGTable) -> Int {
//        return hashes.count
//    }
//    
//    func cellType(fortable table: HGTable) -> CellType {
//        return CellType.imageCell
//    }
//    
//    func hgtable(_ table: HGTable, dataForIndex index: Int) -> HGCellData {
//        let hash = hashes[index]
//        let imagedata = HGImageData(title: hash.name, image: hash.image)
//        let celldata = HGCellData.imageCell(image: imagedata)
//        return celldata
//    }
//}
//
//extension SBD_Hash: HGTableLocationSelectable {
//    
//    func hgtable(_ table: HGTable, shouldSelectLocation loc: HGTableLocation) -> Bool {
//        
//        if loc.type == .image {
//            return true
//        }
//        
//        return false
//    }
//    
//    func hgtable(_ table: HGTable, didSelectLocation loc: HGTableLocation) {
//        // do nothing
//    }
//}
//
