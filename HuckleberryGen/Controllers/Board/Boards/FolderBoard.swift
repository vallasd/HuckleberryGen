//
//  FolderVC.swift
//  HuckleberryGen
//
//  Created by David Vallas on 7/16/15.
//  Copyright © 2015 Phoenix Labs. All rights reserved.
//

import Cocoa

class FolderBoardContext {
    
    let type: FolderBoardType
    
    init(boardtype: FolderBoardType) {
        type = boardtype
    }
}

enum FolderBoardType {
    case Import
    case Export
}

class FolderBoard: NSViewController, NavControllerReferable {
    
    @IBOutlet weak var titleTextField: NSTextField!
    
    @IBOutlet weak var folderButton: NSButton!
    
    @IBAction func folderPressed(sender: AnyObject) {
        self.openFileChooser()
    }
    
    /// context that will allow user to define which type of board to use, default is Import
    private var context: FolderBoardType = .Import
    
    /// reference to the NavController that may be holding this board
    weak var nav: NavController?
    
    private func openFileChooser() {
        
        nav?.disableProgression()
        
        let panel = NSOpenPanel()
        
        panel.canChooseDirectories = true
        panel.canChooseFiles = false
        panel.allowsMultipleSelection = false
        panel.prompt = folderTitle
        
        if panel.runModal() == NSModalResponseOK {
            
            let directory = panel.URL!
            let path = directory.path!
        
            setPath(path)
            updateFolderBoard(withPath: path)
        }
    }
    
    private func updateFolderBoard(withPath path: String) {
        
        if path.isEmpty {
            folderButton.title = "Choose Folder"
            nav?.disableProgression()
        } else {
            folderButton.title = path.lastPathComponent
            nav?.enableProgression()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let startingPath = path
        titleTextField.stringValue = folderTitle
        updateFolderBoard(withPath: startingPath)
    }
    
    func setPath(path: String) {
        switch context {
        case .Import: appDelegate.store.importPath = path
        case .Export: appDelegate.store.exportPath = path
        }
    }
    
    var folderTitle: String {
        switch context {
        case .Import: return "Choose Import Folder"
        case .Export: return "Choose Export Folder"
        }
    }
    
    var path: String {
        switch context {
        case .Import: return appDelegate.store.importPath
        case .Export: return appDelegate.store.exportPath
        }
    }
    
    var progression: ProgressionType {
        switch context {
        case .Import: return .Next
        case .Export: return .Finished
        }
    }
    
    func executeProgression() {
        switch context {
        case .Import:
            let context = SBD_Import()
            let boarddata = SelectionBoard.boardData(withContext: context)
            nav?.push(boarddata)
        case .Export:
            appDelegate.store.exportProject()
        }
    }
    
}

extension FolderBoard: BoardInstantiable {
    
    static var storyboard: String { return "Board" }
    static var nib: String { return "FolderBoard" }
}

extension FolderBoard: BoardRetrievable {
    
    
    func contextForBoard() -> AnyObject {
        return FolderBoardContext(boardtype: context)
    }
    
    
    func set(context context: AnyObject) {
        // assign context if it is of type SelectionBoardDelegate
        if let fbc = context as? FolderBoardContext {
            self.context = fbc.type;
            return
        }
        HGReportHandler.shared.report("FolderBoard Context \(context) not valid", type: .Error)
    }
}



extension FolderBoard: NavControllerProgessable {
    
    func navcontrollerProgressionType(nav: NavController) -> ProgressionType {
        return progression
    }
    
    func navcontroller(nav: NavController, hitProgressWithType progressionType: ProgressionType) {
        executeProgression()
    }
}
