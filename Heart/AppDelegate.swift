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
    var windowController: WindowController!
    weak var viewController: ViewController!

    var statusItem: NSStatusItem!
    var hideMenuItem: NSMenuItem!
    var openOnLoginMenuItem: NSMenuItem!
    var alwaysOnTopMenuItem: NSMenuItem!

    func applicationDidFinishLaunching(aNotification: NSNotification) {
        let storyboard = NSStoryboard(name: "Main", bundle: nil)
        self.windowController = storyboard?.instantiateControllerWithIdentifier("mainWindowController") as! WindowController
        self.window = self.windowController.window as! TransparentWindow
        self.viewController = self.window.contentViewController as! ViewController

        // TODO: once we move to a higher version of swift/XCode
        //       use `NSVariableStatusItemLength`
        statusItem = NSStatusBar.systemStatusBar().statusItemWithLength(-1)
        statusItem.image = NSImage(named: Constants.ImageName.statusItemIcon)

        let menu = NSMenu()
        menu.autoenablesItems = false
        menu.addItemWithTitle("Bring to Front", action: Selector("bringToFront:"), keyEquivalent: "f")
        hideMenuItem = menu.addItemWithTitle("Hide", action: Selector("hideWindow:"), keyEquivalent: "h")
        if Preferences.savedWindowHidden {
            hideWindow(hideMenuItem)
        }

        var lockMenuItem = menu.addItemWithTitle("Lock", action: Selector("toggleLock:"), keyEquivalent: "l")
        if Preferences.locked {
            toggleLock(lockMenuItem!)
        }

        alwaysOnTopMenuItem = menu.addItemWithTitle("Always On Top", action: Selector("toggleAlwaysOnTop:"), keyEquivalent: "t")
        // The default is off, if it was saved as on, then toggle it on
        if Preferences.alwaysOnTop {
            toggleAlwaysOnTop(alwaysOnTopMenuItem)
        }

        // Unfortunately due to the way this information is stored by Apple
        // Reliably retrieving the current value of this flag is iffy,
        // so we store the last value we set it to, we don't want to call toggle
        // because we don't want to change the value. Instead we just store the
        // menu state and hope that shenanigans don't ensue.
        openOnLoginMenuItem = menu.addItemWithTitle("Open on Login", action: Selector("toggleOpenOnLogin:"), keyEquivalent: "")
        openOnLoginMenuItem.state = Preferences.openOnLoginMenuState ?? NSOffState

        menu.addItemWithTitle("Quit", action: Selector("terminate:"), keyEquivalent: "q")

        statusItem.menu = menu
        // TODO:
        // - Reset position (button)
        // - Reset size (button)
    }

    func toggleLock(sender: NSMenuItem) {
        let newIsLocked = !self.viewController.isLocked

        self.viewController.isLocked = newIsLocked;
        let newState = newIsLocked
            ? NSOnState
            : NSOffState

        sender.state = newState;
        Preferences.locked = newIsLocked;
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        let isVisible = window?.visible ?? false
        Preferences.savedWindowHidden = !isVisible
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

            Preferences.openOnLoginMenuState = newState
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

        Preferences.alwaysOnTop = newState == NSOnState
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

