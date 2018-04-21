//
//  TableSelectionBoard.swift
//  HuckleberryGen
//
//  Created by David Vallas on 9/3/15.
//  Copyright © 2015 Phoenix Labs.
//
//  All Rights Reserved.

import Cocoa

protocol SelectionBoardDelegate: HGTableDisplayable {
    var selectionBoard: SelectionBoard? { get set }
    func selectionboard(_ sb: SelectionBoard, didChooseLocations locations: [HGCellLocation])
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
    fileprivate var hgtable: HGTable!
    
    /// This object is the context that whandle delegation of the Selection Board and HGTable
    fileprivate var context: SelectionBoardDelegate? { didSet { loadSelectionBoardIfReady() } }
    
    /// the default progression is to finish.  If we want to implement a Next progression, we would need a boardData for the next controller (need to implement this logic later if needed *** nextData for selectionBoard, handled by delegate.
    fileprivate var progressionType: ProgressionType = .finished
    
    @IBOutlet weak var boardtitle: NSTextField!
    
    @IBOutlet weak var tableview: HGTableView?
    
    /// NavControllerReferable
    weak var nav: NavController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadSelectionBoardIfReady()
        updateProgression()
    }
    
    fileprivate func updateProgression() {
        if automaticNext { nav?.enableProgression() }
        else if hgtable.selectedLocations.count > 0 { nav?.enableProgression() }
        else { nav?.disableProgression() }
    }
    
    fileprivate func loadSelectionBoardIfReady() {
    
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
    
    
    func set(context: AnyObject) {
        // assign context if it is of type SelectionBoardDelegate
        if let context = context as? SelectionBoardDelegate {
            self.context = context;
            return
        }
        HGReportHandler.shared.report("SelectionBoard Context \(context) not valid", type: .error)
    }
}

extension SelectionBoard: NavControllerProgessable {
    
    func navcontrollerProgressionType(_ nav: NavController) -> ProgressionType {
        return progressionType
    }
    
    func navcontroller(_ nav: NavController, hitProgressWithType: ProgressionType) {
        context?.selectionboard(self, didChooseLocations: hgtable.selectedLocations)
    }
}

extension SelectionBoard: HGTableSelectionTrackable {
    
    func hgtableSelectedLocationsChanged(_ table: HGTable) {
        updateProgression()
    }
}



