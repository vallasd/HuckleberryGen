//
//  SplitVCVertical.swift
//  HuckleberryGen
//
//  Created by David Vallas on 8/10/15.
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

class HGSplit: NSObject, NSSplitViewDelegate {
    
    enum SplitProportion {
        case Half
        case Third
        case Fourth
        case Fifth
        
        func cgfloat() -> CGFloat {
            switch self {
                
            case .Half:     return 0.50
            case .Third:    return 1.0 / 3.0
            case .Fourth:   return 0.25
            case .Fifth:    return 0.20
            }
        }
    }
    
    func add(splitview: NSSplitView, proportion: SplitProportion, reverse: Bool) {
        let num = splitview.numDividers()
        if num > 2 || num <= 0 { assert(true, "HGSplitVC only handles split views with at most 3 views, at least 2 views") }
        let splitData = SplitData(split: splitview, proporation: proportion, reverse: reverse)
        splitview.delegate = self
        splitview.dividerStyle = .Thin
        splitDataArray.append(splitData)
    }
    
    func toggle(splitview: NSSplitView, divider: Int, animated: Bool) {
        let data = splitData(forSplitView: splitview)
        data?.toggle(divider, animated: animated)
    }
    
    func openall(animated: Bool) {
        for data in splitDataArray { data.open(animated) }
    }
    
    
    private var splitDataArray: [SplitData] = []
    
    private struct SplitData {
        weak var split: NSSplitView!
        let proporation: SplitProportion
        let reverse: Bool
        
        var lThick: CGFloat { return split.dividerThickness + 1 }
        var rThick: CGFloat { return split.dividerThickness + 2 }
        
        func bounds(divider: Int) -> (min: CGFloat, max: CGFloat) {
            let percentage = proporation.cgfloat()
            let length = split.length()
            
            if reverse {
                let numDividers = split.numDividers()
                if numDividers == 1 { return rightout(length, percentage: percentage) }
                if divider == 0 { return leftMiddle(length, percentage: percentage) }
                if divider == 1 { return rightMiddle(length, percentage: percentage) }
            }
            
            if divider == 0 { return leftout(length, percentage: percentage) }
            return rightout(length, percentage: percentage)
        }
        
        func toggle(divider: Int, animated: Bool) {
            let bounds = self.bounds(divider)
            let status = self.status(divider, bounds: bounds)
            let currentPosition = split.position(ofDividerIndex: divider)
            let sv = split
            if currentPosition == status.closed { sv.setPosition(status.open, ofDividerAtIndex: divider, animated: animated) }
            else { split.setPosition(status.closed, ofDividerAtIndex: divider, animated: animated) }
        }
        
        func open(animated: Bool) {
            let dividers = split.numDividers()
            for divider in 0...dividers {
                let bounds = self.bounds(divider)
                let status = self.status(divider, bounds: bounds)
                split.setPosition(status.open, ofDividerAtIndex: divider, animated: animated)
            }
        }
        
        // divider will close open to left side
        private func leftout(length: CGFloat, percentage: CGFloat) -> (min: CGFloat, max: CGFloat) {
            return (min: 0 + lThick, max: percentage * length)
        }
        
        // divider will close open to right side
        private func rightout(length: CGFloat, percentage: CGFloat) -> (min: CGFloat, max: CGFloat) {
            return (min: (1.0 - percentage) * length, max: length - rThick)
        }
        
        // divider will close open from left to middle
        private func leftMiddle(length: CGFloat, percentage: CGFloat) -> (min: CGFloat, max: CGFloat) {
            return (min: ((0.5 - percentage) * length) + lThick, max: (0.5 * length) - lThick)
        }
        
        // divider will close open from right to middle
        private func rightMiddle(length: CGFloat, percentage: CGFloat) -> (min: CGFloat, max: CGFloat) {
            return (min: (0.5 * length) + rThick, max: ((0.5 + percentage) * length) - rThick)
        }
        
        // gives the open close positions of the bounds
        private func status(divider: Int, bounds: (min: CGFloat, max: CGFloat)) -> (closed: CGFloat, open: CGFloat) {
            if reverse {
                if divider == 0 { return (bounds.max, bounds.min)  }
                if divider == 1 { return (bounds.min, bounds.max)  }
            }
            if divider == 0 { return (bounds.min, bounds.max) }
            return (bounds.max, bounds.min)
        }
    }
    
    private func splitData(forSplitView splitview: NSSplitView) -> SplitData? {
        for data in splitDataArray { if data.split == splitview { return data } }
        print("HGSplitVC Error: SplitData not found for SplitView: \(splitview)")
        return nil
    }
    
    // MARK: NSSplitViewDelegate
    
    func splitView(splitView: NSSplitView, constrainMaxCoordinate proposedMaximumPosition: CGFloat, ofSubviewAt dividerIndex: Int) -> CGFloat {
        let data = splitData(forSplitView: splitView)
        return data?.bounds(dividerIndex).max ?? 0
    }
    
    func splitView(splitView: NSSplitView, constrainMinCoordinate proposedMinimumPosition: CGFloat, ofSubviewAt dividerIndex: Int) -> CGFloat {
        let data = splitData(forSplitView: splitView)
        return data?.bounds(dividerIndex).min ?? 0
    }
    
    func splitView(splitView: NSSplitView, shouldAdjustSizeOfSubview view: NSView) -> Bool {
        return true
    }
}

extension NSSplitView {
    
    func numDividers() -> Int {
        let numDividers = self.subviews.count - 1
        return numDividers
    }
    
    func length() -> CGFloat {
        if self.vertical { return self.frame.size.width }
        else { return self.frame.size.height }
    }
    
    func position(ofDividerIndex dividerIndex: Int) -> CGFloat {
        var finalIndex = dividerIndex
        while finalIndex >= 0 && isSubviewCollapsed(subviews[finalIndex]) { finalIndex -= 1 }
        if finalIndex < 0 { return 0.0 }
        let priorViewFrame = self.subviews[finalIndex].frame
        return self.vertical ? NSMaxX(priorViewFrame) : NSMaxY(priorViewFrame)
    }
    
    func setPositions(positions: [CGFloat], ofDividersAtIndexes indexes: [Int]) -> Bool {
        
        if indexes.count != positions.count { return false }
        if indexes.count >= subviews.count { return false }

        var newRect: [NSRect] = []
        
        for i in 0...subviews.count - 1 { newRect.append(self.subviews[i].frame) }
        
        var indexOfParameters = 0
        for index in indexes {
            let position = positions[indexOfParameters]
            
            if self.vertical {
                let oldMaxXOfRightView = NSMaxX(newRect[index + 1])
                newRect[index].size.width = position - NSMinX(newRect[index])
                newRect[index + 1].origin.x = position + dividerThickness
                newRect[index + 1].size.width = oldMaxXOfRightView - position - dividerThickness
                
            } else {
                let oldMaxYOfBottomView = NSMaxY(newRect[index + 1])
                newRect[index].size.height = position - NSMinY(newRect[index])
                newRect[index + 1].origin.y = position + dividerThickness
                newRect[index + 1].size.height = oldMaxYOfBottomView - position - dividerThickness
                
            }
            
            indexOfParameters += 1
        }
        
        CATransaction.begin()
        CATransaction.setAnimationDuration(0.33)
        CATransaction.setAnimationTimingFunction(CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut))
        for i in 0...subviews.count-1 { subviews[i].animator().frame = newRect[i] }
        CATransaction.commit()

        return true
    }
    
    
    private func lastDivider(divider: Int) -> Bool {
        if divider == subviews.count - 2 { return true }
        return false
    }
    
    func setPosition(position: CGFloat, ofDividerAtIndex dividerIndex: Int, animated: Bool) -> Bool {
        if animated {
            if dividerIndex >= subviews.count { return false }
            setPositions([position], ofDividersAtIndexes: [dividerIndex])
        } else {
            setPosition(position, ofDividerAtIndex: dividerIndex)
        }
        
        return true
    }
}

