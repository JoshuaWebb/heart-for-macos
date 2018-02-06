//
//  WindowController.swift
//  Heart
//
//  Created by josh on 6/02/2018.
//  Copyright (c) 2018 Joshua Webb. All rights reserved.
//

import Foundation
import Cocoa

class WindowController: NSWindowController {

    override func windowDidLoad() {
        super.windowDidLoad()
        window?.setFrameAutosaveName(Constants.savedFrameName)
        window?.setFrameUsingName(Constants.savedFrameName, force: true)
    }
}
