//
//  ResizeView.swift
//  Heart
//
//  Created by josh on 4/02/2018.
//  Copyright (c) 2018 Joshua Webb. All rights reserved.
//

import Foundation
import Cocoa

class ResizeView : NSImageView {
    let cursor = NSCursor.resizeNorthWestSouthEastCursor()

    /* I can't figure out a better way to do this
     * the default cursor stuff seems to want to
     * apply to the entire rectangle by default,
     * even though only half of it has grippable
     * pixels.
     *
     * Overlap the visible pixels using rectangles.
     * Note that there are also visible pixels in the
     * gaps using 5% alpha white pixels.
     *
     * This makes the whole triangluar region grippable
     * (at least until Apple changes that behaviour)
     *
     *           [ ]
     *         [   ]
     *       [     ]
     *     [       ]
     */
    let rects = [
        NSRect(x: 0, y: 0, width: 13, height: 4),
        NSRect(x: 3, y: 4, width: 10, height: 3),
        NSRect(x: 6, y: 7,  width: 7, height: 3),
        NSRect(x: 9, y: 10, width: 4, height: 3)
    ]

    override func resetCursorRects() {
        for rect in rects {
            addCursorRect(rect, cursor: cursor)
        }
    }
}
