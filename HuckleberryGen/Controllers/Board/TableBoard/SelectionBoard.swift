//
//  TableSelectionBoard.swift
//  HuckleberryGen
//
//  Created by David Vallas on 9/3/15.
//  Copyright © 2015 Phoenix Labs.
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

protocol SelectionBoardDelegate: HGTableDisplayable {
    weak var selectionBoard: SelectionBoard? { get set }
    func selectionboard(sb: SelectionBoard, didChooseLocations locations: [HGCellLocation])
}

/// Board that allows class to select
class SelectionBoard: NSViewController, NavControllerReferable {
    
    /// function that updates the selection board
    func update() {
        hgtable.update()
    }
    
    /// will make SelectionBoard finish or move to next without a field selected.
    var automaticNext = false {
        didSet {
            updateProgression()
        }
    }
    
//    /// function currently broken
//    var allowMultipleSelect = false {
//        didSet {
//            tableview?.allowsMultipleRowSelection = allowMultipleSelect
//        }
//    }
    
    /// reference to the HGTable
    private var hgtable: HGTable!
    
    /// This object is the context that whandle delegation of the Selection Board and HGTable
    private var context: SelectionBoardDelegate? { didSet { loadSelectionBoardIfReady() } }
    
    /// the default progression is to finish.  If we want to implement a Next progression, we would need a boardData for the next controller (need to implement this logic later if needed *** nextData for selectionBoard, handled by delegate.
    private var progressionType: ProgressionType = .Finished
    
    @IBOutlet weak var boardtitle: NSTextField!
    
    @IBOutlet weak var tableview: HGTableView?
    
    /// NavControllerReferable
    weak var nav: NavController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadSelectionBoardIfReady()
        updateProgression()
    }
    
    private func updateProgression() {
        if automaticNext { nav?.enableProgression() }
        else if hgtable.selectedLocations.count > 0 { nav?.enableProgression() }
        else { nav?.disableProgression() }
    }
    
    private func loadSelectionBoardIfReady() {
    
        // check if not ready and return if so
        if context == nil || tableview == nil {
            return
        }
        
        // load context and init hgtable
        context!.selectionBoard = self
        hgtable = HGTable(tableview: tableview!, delegate: context!, selectionDelegate: self)
    }
    
}

extension SelectionBoard: BoardInstantiable {
    
    static var storyboard: String { return "Board" }
    static var nib: String { return "SelectionBoard" }
}

extension SelectionBoard: BoardRetrievable {
    
    
    func contextForBoard() -> AnyObject {
        return context!
    }
    
    
    func set(context context: AnyObject) {
        // assign context if it is of type SelectionBoardDelegate
        if let context = context as? SelectionBoardDelegate {
            self.context = context;
            return
        }
        HGReportHandler.shared.report("SelectionBoard Context \(context) not valid", type: .Error)
    }
}

extension SelectionBoard: NavControllerProgessable {
    
    func navcontrollerProgressionType(nav: NavController) -> ProgressionType {
        return progressionType
    }
    
    func navcontroller(nav: NavController, hitProgressWithType: ProgressionType) {
        context?.selectionboard(self, didChooseLocations: hgtable.selectedLocations)
    }
}

extension SelectionBoard: HGTableSelectionTrackable {
    
    func hgtableSelectedLocationsChanged(table: HGTable) {
        updateProgression()
    }
}



