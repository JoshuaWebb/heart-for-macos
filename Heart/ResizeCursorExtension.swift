//
//  ResizeCursor.swift
//  Heart
//
//  Created by josh on 4/02/2018.
//  Copyright (c) 2018 Joshua Webb. All rights reserved.
//

import Foundation
import Cocoa

extension NSCursor {
    static func resizeNorthWestSouthEastCursor() -> NSCursor {
        // why for the love of god is the real version of this cursor not exposed?!
        return NSCursor(image: NSImage(named: Constants.ImageName.windowResizeNorthWestSouthEastCursor)!, hotSpot: NSPoint(x: 7, y: 7))
    }
}
