//
//  SaveBoard.swift
//  HuckleberryGen
//
//  Created by David Vallas on 1/26/16.
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

class SaveBoard: NSViewController, NavControllerReferable {
    
    
    @IBOutlet weak var projectName: NSTextField!
    
    // reference to name of current project
    var currentProjectName = appDelegate.store.project.isNew ? "" : appDelegate.store.project.name
    
    // reference to the Nav Controller
    weak var nav: NavController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        projectName.delegate = self
        projectName.stringValue = currentProjectName
        updateProgression()
    }
    
    var projectNameAcceptable: Bool {
        
        // check requested name
        let requestedName = projectName.stringValue
        
        // name length too short
        if requestedName.characters.count < 4 { return false }
        
        // project was previously saved and we just want to save it without changing new
        if requestedName == currentProjectName { return true }
        
        // new name is already a saved name
        if appDelegate.store.savedProjects.contains(requestedName) { return false }
        
        return true
    }
    
    func updateProgression() {
        if projectNameAcceptable {
            nav?.enableProgression()
        } else {
            nav?.disableProgression()
        }
    }
    
    func updateProjectName() {
        
        if projectName.stringValue != currentProjectName {
            appDelegate.store.changeCurrentProject(toName: projectName.stringValue)
            currentProjectName = projectName.stringValue
        } else {
            appDelegate.store.saveCurrentProject()
        }
        
        appDelegate.store.save()
    }
    
}

extension SaveBoard: NavControllerProgessable {
    
    func navcontrollerProgressionType(_ nav: NavController) -> ProgressionType {
        return .finished
    }
    
    func navcontroller(_ nav: NavController, hitProgressWithType progressionType: ProgressionType) {
        if progressionType == .finished {
            updateProjectName()
        }
    }
    
}

extension SaveBoard: BoardInstantiable {
    
    static var storyboard: String { return "Board" }
    static var nib: String { return "SaveBoard" }
}

extension SaveBoard: NSTextFieldDelegate {
    
    override func controlTextDidChange(_ obj: Notification) {
        updateProgression()
    }
    
}
