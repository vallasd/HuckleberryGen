//
//  FolderVC.swift
//  HuckleberryGen
//
//  Created by David Vallas on 7/16/15.
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

class FolderBoardContext {
    
    let type: FolderBoardType
    
    init(boardtype: FolderBoardType) {
        type = boardtype
    }
}

enum FolderBoardType {
    case `import`
    case export
}

class FolderBoard: NSViewController, NavControllerReferable {
    
    @IBOutlet weak var titleTextField: NSTextField!
    
    @IBOutlet weak var folderButton: NSButton!
    
    @IBAction func folderPressed(_ sender: AnyObject) {
        self.openFileChooser()
    }
    
    /// context that will allow user to define which type of board to use, default is Import
    fileprivate var context: FolderBoardType = .import
    
    /// reference to the NavController that may be holding this board
    weak var nav: NavController?
    
    fileprivate func openFileChooser() {
        
        nav?.disableProgression()
        
        let panel = NSOpenPanel()
        
        panel.canChooseDirectories = true
        panel.canChooseFiles = false
        panel.allowsMultipleSelection = false
        panel.prompt = folderTitle
        
        if panel.runModal() == NSApplication.ModalResponse.OK {
            
            let directory = panel.url!
            let path = directory.path
        
            setPath(path)
            updateFolderBoard(withPath: path)
        }
    }
    
    fileprivate func updateFolderBoard(withPath path: String) {
        
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
    
    func setPath(_ path: String) {
        switch context {
        case .import: appDelegate.store.importPath = path
        case .export: appDelegate.store.exportPath = path
        }
    }
    
    var folderTitle: String {
        switch context {
        case .import: return "Choose Import Folder"
        case .export: return "Choose Export Folder"
        }
    }
    
    var path: String {
        switch context {
        case .import: return appDelegate.store.importPath
        case .export: return appDelegate.store.exportPath
        }
    }
    
    var progression: ProgressionType {
        switch context {
        case .import: return .next
        case .export: return .finished
        }
    }
    
    func executeProgression() {
        switch context {
        case .import:
            let context = SBD_Import()
            let boarddata = SelectionBoard.boardData(withContext: context)
            nav?.push(boarddata)
        case .export:
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
    
    
    func set(context: AnyObject) {
        // assign context if it is of type SelectionBoardDelegate
        if let fbc = context as? FolderBoardContext {
            self.context = fbc.type;
            return
        }
        HGReportHandler.shared.report("FolderBoard Context \(context) not valid", type: .error)
    }
}



extension FolderBoard: NavControllerProgessable {
    
    func navcontrollerProgressionType(_ nav: NavController) -> ProgressionType {
        return progression
    }
    
    func navcontroller(_ nav: NavController, hitProgressWithType progressionType: ProgressionType) {
        executeProgression()
    }
}
