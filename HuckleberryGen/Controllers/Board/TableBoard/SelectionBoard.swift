//
//  TableSelectionBoard.swift
//  HuckleberryGen
//
//  Created by David Vallas on 9/3/15.
//  Copyright © 2015 Phoenix Labs. All rights reserved.
//

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
    
    /// reference to the HGTable
    private var hgtable: HGTable!
    
    /// This object is the context that whandle delegation of the Selection Board and HGTable
    private var context: SelectionBoardDelegate! {
        didSet {
            context.selectionBoard = self
        }
    }
    
    /// the default progression is to finish.  If we want to implement a Next progression, we would need a boardData for the next controller (need to implement this logic later if needed *** nextData for selectionBoard, handled by delegate.
    private var progressionType: ProgressionType = .Finished
    
    @IBOutlet weak var boardtitle: NSTextField!
    
    @IBOutlet weak var tableview: HGTableView!
    
    /// NavControllerReferable
    weak var nav: NavController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hgtable = HGTable(tableview: tableview, delegate: context)
        hgtable.selectionDelegate = self
        nav?.disableProgression()
    }
    
    private func updateProgression() {
        if hgtable.selectedLocations.count > 0 { nav?.enableProgression() }
        else { nav?.disableProgression() }
    }
    
}

extension SelectionBoard: BoardInstantiable {
    
    static var storyboard: String { return "Board" }
    static var nib: String { return "SelectionBoard" }
}

extension SelectionBoard: BoardRetrievable {
    
    
    func contextForBoard() -> AnyObject {
        return context
    }
    
    
    func set(context context: AnyObject) {
        // assign context if it is of type SelectionBoardDelegate
        if let context = context as? SelectionBoardDelegate {
            self.context = context;
            return
        }
        HGReportHandler.report("SelectionBoard Context \(context) not valid", response: .Error)
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



