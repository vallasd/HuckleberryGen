////
////  SavedBoard.swift
////  HuckleberryGen
////
////  Created by David Vallas on 01/08/16.
////  Copyright © 2015 Phoenix Labs. All rights reserved.
////
//
//import Cocoa
//
///// A board that opens saved projects.
//class LoadBoard: NSViewController, NavControllerReferable {
//    
//    /// reference to the nav controller
//    var nav: NavController?
//    
//    /// reference to the selection board
//    private var selectionboard: SelectionBoard!
//    
//    // reference to saved files
//    
//    
//    
//    // MARK: View Lifecycle
//    override func viewDidLoad() {
//        
//        // displays the selection board on top of this view and sets self as delegate
//        selectionboard = SelectionBoard.present(onViewController: self)
//        selectionboard.nav = nav
//        selectionboard.boardDelegate = self
//        selectionboard.rowSource = self
//        
//        // selection board title is blanks until we get callback from folder creation
//        selectionboard.boardtitle.stringValue = "Choose Project To Load"
//    }
//}
//
//// MARK: SelectionBoardDelegate
//extension LoadBoard: SelectionBoardDelegate {
//    
//    func hgcellType(forSelectionBoard sb: SelectionBoard) -> HGCellType {
//        return HGCellType.FieldCell2
//    }
//    
//    func selectionboard(sb: SelectionBoard, didChoose items: [Int]) {
//        let item = items[0] // we should only be selecting one item at a time
//        appDelegate.store.openProject(atIndex: item)
//    }
//}
//
//// MARK: SelectionBoardDataSource
//extension LoadBoard: SelectionBoardRowSource {
//    
//    func numberOfItems(forSelectionBoard sb: SelectionBoard) -> Int {
//        let count = appDelegate.store.savedProjects.count ?? 0
//        return count
//    }
//    
//    func selectionboard(sb: SelectionBoard, dataForRow row: Int) -> HGCellData {
//        let name = appDelegate.store.savedProjects[row]
//        return HGCellData.fieldCell1(
//            field0: HGFieldData(title: name))
//    }
//}
