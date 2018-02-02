//
//  AppDelegate.swift
//  Heart
//
//  Created by josh on 31/01/2018.
//  Copyright (c) 2018 joshuawebb. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: TransparentWindow!

    var statusItem: NSStatusItem!

    func applicationDidFinishLaunching(aNotification: NSNotification) {
        // TODO: can we use the named literal/value here instead of -1??s
        // I kept getting compile errors, and I couldn't be bothered
        // looking into them at the time.
        statusItem = NSStatusBar.systemStatusBar().statusItemWithLength(-1)
        statusItem.image = NSImage(named: "icon_menu")

        // TODO: add a menu
        // - Bring to front (button)
        // - Reset position (button)
        // - Reset size (button)
        // - Start automatically (check box)
        // - Always on top (check box) `window.level = Int(CGWindowLevelForKey(Int32(kCGFloatingWindowLevelKey)))`
        // - Quit
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }

    func showWindow(sender: AnyObject) {
        NSLog("showWindow")
        NSApp.activateIgnoringOtherApps(true)
        window.makeKeyAndOrderFront(sender)
    }
}

