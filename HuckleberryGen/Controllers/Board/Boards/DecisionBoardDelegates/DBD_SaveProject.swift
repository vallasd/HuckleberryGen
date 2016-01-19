//
//  DBD_SaveCurrentProject.swift
//  HuckleberryGen
//
//  Created by David Vallas on 1/13/16.
//  Copyright © 2016 Phoenix Labs. All rights reserved.
//

import Foundation

class DBD_SaveProject {
    
    let project: Project
    let nextBoard: BoardData?
    let canCancel: Bool
    
    init(project: Project, nextBoard: BoardData?, canCancel: Bool) {
        self.project = project
        self.nextBoard = nextBoard
        self.canCancel = canCancel
    }
}

extension DBD_SaveProject: DecisionBoardDelegateProgressable {
    
    func decisionboardNavAction(db: DecisionBoard) -> NavAction {
        return .None
    }
}

extension DBD_SaveProject: DecisionBoardDelegateCancelable {

    func decisionboardCanCancel(db: DecisionBoard) -> Bool {
        return canCancel
    }
}

extension DBD_SaveProject: DecisionBoardDelegate {
    
    func decisionboardQuestion(db: DecisionBoard) -> String {
        return "Do you want to save \(project.name)?"
    }
    
    func decisionboard(db: DecisionBoard, didChoose: Bool) {
        
        /// save project if yes was pressed
        if didChoose {
            appDelegate.store.saveProject(project)
        }
        
        /// pushes to next board if next board was set
        if let nb = nextBoard {
            db.nav?.push(nb)
        }
    }
}