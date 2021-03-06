//
//  Constants.swift
//  Heart
//
//  Created by josh on 6/02/2018.
//  Copyright (c) 2018 Joshua Webb. All rights reserved.
//

import Cocoa

struct Constants {
    static let savedFrameName = "MainWindow"

    struct ImageName {
        static let windowResizeNorthWestSouthEastCursor = "_windowResizeNorthWestSouthEastCursor"
        static let statusItemIcon = "statusItemIcon"
    }

    struct PreferenceKey {
        static let alwaysOnTop = "AlwaysOnTop"
        static let locked = "Locked"
        static let windowWasHiddenWhenAppWasTerminated = "WindowWasHiddenWhenAppWasTerminated"
        static let openOnLoginMenuState = "OpenOnLoginMenuState"
    }

    struct Defaults {
        static let frameSize = NSSize(width: 130, height: 130)
    }
}
