//
//  DBD_SaveCurrentProject.swift
//  HuckleberryGen
//
//  Created by David Vallas on 1/13/16.
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
    
    func decisionboardNavAction(_ db: DecisionBoard) -> NavAction {
        return .none
    }
}

extension DBD_SaveProject: DecisionBoardDelegateCancelable {

    func decisionboardCanCancel(_ db: DecisionBoard) -> Bool {
        return canCancel
    }
}

extension DBD_SaveProject: DecisionBoardDelegate {
    
    func decisionboardQuestion(_ db: DecisionBoard) -> String {
        return "Do you want to save \(project.name)?"
    }
    
    func decisionboard(_ db: DecisionBoard, didChoose: Bool) {
        
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
