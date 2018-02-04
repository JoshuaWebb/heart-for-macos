//
//  AppDelegate.swift
//  Heart
//
//  Created by josh on 31/01/2018.
//  Copyright (c) 2018 Joshua Webb. All rights reserved.
//

import Cocoa
import Foundation
import ServiceManagement

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    var window: TransparentWindow!

    var statusItem: NSStatusItem!
    var hideMenuItem: NSMenuItem!
    var openOnLoginMenuItem: NSMenuItem!
    var alwaysOnTopMenuItem: NSMenuItem!

    let userDefaults = NSUserDefaults.standardUserDefaults()

    let kOpenOnLoginMenuState = "OpenOnLoginMenuState"
    let kAlwaysOnTop = "AlwaysOnTop"
    let kWindowWasHiddenWhenAppWasTerminated = "WindowWasHiddenWhenAppWasTerminated"

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
        let savedWindowHidden = userDefaults.boolForKey(kWindowWasHiddenWhenAppWasTerminated)
        if savedWindowHidden {
            hideWindow(hideMenuItem)
        }

        alwaysOnTopMenuItem = menu.addItemWithTitle("Always On Top", action: Selector("toggleAlwaysOnTop:"), keyEquivalent: "t")
        let savedAlwaysOnTopMenuState = userDefaults.boolForKey(kAlwaysOnTop)
        // The default is off, if it was saved as on, then toggle it on
        if savedAlwaysOnTopMenuState {
            toggleAlwaysOnTop(alwaysOnTopMenuItem)
        }

        // Unfortunately due to the way this information is stored by Apple
        // Reliably retrieving the current value of this flag is iffy,
        // so we store the last value we set it to, we don't want to call toggle
        // because we don't want to change the value. Instead we just store the
        // menu state and hope that shenanigans don't ensue.
        openOnLoginMenuItem = menu.addItemWithTitle("Open on Login", action: Selector("toggleOpenOnLogin:"), keyEquivalent: "")
        if let savedOpenOnLoginMenuState = userDefaults.objectForKey(kOpenOnLoginMenuState) as! Int? {
            openOnLoginMenuItem.state = savedOpenOnLoginMenuState
        }

        menu.addItemWithTitle("Quit", action: Selector("terminate:"), keyEquivalent: "q")

        statusItem.menu = menu
        // TODO:
        // - Reset position (button)
        // - Reset size (button)
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        let isVisible = window?.visible ?? false
        userDefaults.setBool(!isVisible, forKey: kWindowWasHiddenWhenAppWasTerminated)
    }

    func toggleOpenOnLogin(sender: NSMenuItem) {
        let launcherIdentifier = NSBundle.mainBundle().bundleIdentifier! + "Launcher" as CFString
        let newState = sender.state == NSOnState
            ? NSOffState
            : NSOnState

        let autoLaunch:Boolean = (newState == NSOnState) ? 1 : 0
        if SMLoginItemSetEnabled(launcherIdentifier, autoLaunch) == 1 {
            NSLog("Successfuly toggled auto launch")
            sender.state = newState

            userDefaults.setInteger(newState, forKey: kOpenOnLoginMenuState)
            userDefaults.synchronize()
        } else {
            NSLog("Failed to toggle auto launch")
        }
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

        userDefaults.setBool(newState == NSOnState, forKey: kAlwaysOnTop)
        userDefaults.synchronize()

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

