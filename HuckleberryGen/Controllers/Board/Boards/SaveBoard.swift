//
//  SaveBoard.swift
//  HuckleberryGen
//
//  Created by David Vallas on 1/26/16.
//  Copyright © 2016 Phoenix Labs. All rights reserved.
//

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
    
    func navcontrollerProgressionType(nav: NavController) -> ProgressionType {
        return .Finished
    }
    
    func navcontroller(nav: NavController, hitProgressWithType progressionType: ProgressionType) {
        if progressionType == .Finished {
            updateProjectName()
        }
    }
    
}

extension SaveBoard: BoardInstantiable {
    
    static var storyboard: String { return "Board" }
    static var nib: String { return "SaveBoard" }
}

extension SaveBoard: NSTextFieldDelegate {
    
    override func controlTextDidChange(obj: NSNotification) {
        updateProgression()
    }
    
}
