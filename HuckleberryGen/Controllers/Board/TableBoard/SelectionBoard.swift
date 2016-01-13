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
    
    /// reference to the HGTable
    let hgtable: HGTable = HGTable()
    
    /// function that updates the selection board
    func update() { hgtable.update() }
    
    /// This object is the context that whandle delegation of the Selection Board and HGTable
    private var context: SelectionBoardDelegate! {
        didSet {
            hgtable.selectionDelegate = self
            hgtable.delegate = context // context will also handle hgtable protocol
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
    
    
    func contextForBoard() -> AnyObject { return context }
    
    
    func set(context context: AnyObject) {
        // assign context if it is of type SelectionBoardDelegate
        if let c = context as? SelectionBoardDelegate { self.context = c; return }
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



