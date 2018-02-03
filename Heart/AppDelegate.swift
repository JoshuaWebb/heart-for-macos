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

    var window: TransparentWindow!

    var statusItem: NSStatusItem!
    var hideMenuItem: NSMenuItem!

    func applicationDidFinishLaunching(aNotification: NSNotification) {
        // TODO: I don't know if there's a less shifty way to do this
        //       I also have no idea if this actually belongs here.
        window = NSApplication.sharedApplication().windows[0] as! TransparentWindow

        // TODO: can we use the named literal/value here instead of -1??s
        // I kept getting compile errors, and I couldn't be bothered
        // looking into them at the time.
        statusItem = NSStatusBar.systemStatusBar().statusItemWithLength(-1)
        statusItem.image = NSImage(named: "icon_menu")

        let menu = NSMenu()
        menu.autoenablesItems = false
        menu.addItemWithTitle("Bring to Front", action: Selector("bringToFront:"), keyEquivalent: "f")
        hideMenuItem = menu.addItemWithTitle("Hide", action: Selector("hideWindow:"), keyEquivalent: "h")
        menu.addItemWithTitle("Always On Top", action: Selector("toggleAlwaysOnTop:"), keyEquivalent: "t")
        menu.addItemWithTitle("Quit", action: Selector("terminate:"), keyEquivalent: "q")

        statusItem.menu = menu
        // TODO:
        // - Reset position (button)
        // - Reset size (button)
        // - Open on Login (check box)

        // TODO: save menu settings
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }

    func toggleAlwaysOnTop(sender: NSMenuItem) {
        NSLog("toggleAlwaysOnTop")

        let newState = sender.state == NSOnState
            ? NSOffState
            : NSOnState

        sender.state = newState
        let newLevelKey = newState == NSOnState
            ? kCGFloatingWindowLevelKey
            : kCGNormalWindowLevelKey

        NSLog("\(newLevelKey)")
        window.level = Int(CGWindowLevelForKey(Int32(newLevelKey)))
    }

    func bringToFront(sender: NSMenuItem) {
        NSLog("bringToFront")
        hideMenuItem.enabled = true
        NSApp.activateIgnoringOtherApps(true)
        window.makeKeyAndOrderFront(sender)
    }

    func hideWindow(sender: NSMenuItem) {
        NSLog("hideWindow")
        sender.enabled = false
        window.orderOut(sender)
    }
}

