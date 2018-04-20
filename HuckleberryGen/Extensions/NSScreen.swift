//
//  NSScreen.swift
//  HuckleberryGen
//
//  Created by David Vallas on 2/21/16.
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

extension NSScreen {
    
    /// returns an array of screen sizes for the current mac with main screen size at index 0
    static func screenRects() -> [CGRect] {
        
        // create mainScreen rect and get all screens
        var rects: [CGRect] = []
        let screenArray = self.screens() ?? []
        let mainScreenFrame = self.main()?.visibleFrame ?? CGRect(x: 0, y: 0, width: 0, height: 0)
        
        // convert screens to rects and store in sizes array
        for screen in screenArray {
            let rect = screen.visibleFrame
            if rect == mainScreenFrame { rects.insert(rect, at: 0) }
            else { rects.append(rect) }
        }
        
        // returns rects
        return rects
    }
}
