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
    var resetSizeMenuItem: NSMenuItem!
    var resetPositionMenuItem: NSMenuItem!
    var openOnLoginMenuItem: NSMenuItem!
    var alwaysOnTopMenuItem: NSMenuItem!

    var isLocked: Bool {
        set {
            self.viewController.isLocked = newValue
        }
        get {
            return self.viewController.isLocked
        }
    }

    func applicationDidFinishLaunching(aNotification: NSNotification) {
        let storyboard = NSStoryboard(name: "Main", bundle: nil)
        self.windowController = storyboard?.instantiateControllerWithIdentifier("mainWindowController") as! WindowController
        self.window = self.windowController.window as! TransparentWindow
        self.viewController = self.window.contentViewController as! ViewController

        // TODO: once we move to a higher version of swift/XCode
        //       use `NSVariableStatusItemLength`
        statusItem = NSStatusBar.systemStatusBar().statusItemWithLength(-1)
        statusItem.image = NSImage(named: Constants.ImageName.statusItemIcon)

        let displayName = NSBundle.mainBundle().displayName
        let menu = NSMenu()
        menu.autoenablesItems = false

        menu.addItemWithTitle("About \(displayName)", action: Selector("orderFrontStandardAboutPanel:"), keyEquivalent: "")

        menu.addItem(NSMenuItem.separatorItem())

        menu.addItemWithTitle("Bring to Front", action: Selector("bringToFront:"), keyEquivalent: "")

        hideMenuItem = menu.addItemWithTitle("Hide \(displayName)", action: Selector("hide:"), keyEquivalent: "")
        hideMenuItem.bind("enabled", toObject: self.window, withKeyPath: "visible", options: nil)
        if !Preferences.savedWindowHidden {
            self.windowController.showWindow(self)
        }

        menu.addItem(NSMenuItem.separatorItem())

        resetSizeMenuItem = menu.addItemWithTitle("Reset Size", action: Selector("resetSize:"), keyEquivalent: "")
        resetPositionMenuItem = menu.addItemWithTitle("Reset Position", action: Selector("resetPosition:"), keyEquivalent: "")

        menu.addItem(NSMenuItem.separatorItem())

        var lockMenuItem = menu.addItemWithTitle("Lock \(displayName)", action: Selector("toggleLock:"), keyEquivalent: "")
        if Preferences.locked {
            toggleLock(lockMenuItem!)
        }

        alwaysOnTopMenuItem = menu.addItemWithTitle("Always On Top", action: Selector("toggleAlwaysOnTop:"), keyEquivalent: "")
        if Preferences.alwaysOnTop {
            toggleAlwaysOnTop(alwaysOnTopMenuItem)
        }

        // Unfortunately due to the way this information is stored by Apple
        // Reliably retrieving the actual current state of the auto launch mechanism
        // is iffy, so we store the last value we set it to, we don't want to call
        // toggle because we don't want to change the value. Instead we just store the
        // menu state and hope that shenanigans don't ensue.
        openOnLoginMenuItem = menu.addItemWithTitle("Open on Login", action: Selector("toggleOpenOnLogin:"), keyEquivalent: "")
        openOnLoginMenuItem.state = Preferences.openOnLoginMenuState ?? NSOffState

        menu.addItem(NSMenuItem.separatorItem())

        menu.addItemWithTitle("Quit \(displayName)", action: Selector("terminate:"), keyEquivalent: "")

        statusItem.menu = menu
    }

    func resetSize(sender: NSMenuItem) {
        let originalFrame = self.window.frame
        var newFrame = self.window.frame

        newFrame.size = Constants.Defaults.frameSize

        // Offset the origin so that it doesn't move
        let heightDifference = originalFrame.size.height - newFrame.size.height
        newFrame.origin.y += heightDifference

        // Ensure the window doesn't end up completely outside the bounds
        if newFrame.origin.x < 0 {
            newFrame.origin.x = 0
        }

        self.window.setFrame(newFrame, display: true, animate: true)
    }

    func resetPosition(sender: NSMenuItem) {
        let screenFrame = self.window.screen!.frame
        let windowHeight = self.window.frame.height
        var newFrame = self.window.frame

        // Set back to the top left corner
        newFrame.origin.y = screenFrame.height - windowHeight
        newFrame.origin.x = 0

        self.window.setFrame(newFrame, display: true, animate: true)
    }

    func toggleLock(sender: NSMenuItem) {
        let newIsLocked = !self.isLocked

        self.isLocked = newIsLocked;
        let newState = newIsLocked
            ? NSOnState
            : NSOffState

        // TODO: bind these directly to isLocked
        resetSizeMenuItem.enabled = !newIsLocked
        resetPositionMenuItem.enabled = !newIsLocked

        sender.state = newState;
        Preferences.locked = newIsLocked;
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        let isVisible = window?.visible ?? false
        Preferences.savedWindowHidden = !isVisible
        NSStatusBar.systemStatusBar().removeStatusItem(statusItem)
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
        NSApp.activateIgnoringOtherApps(true)
        window.makeKeyAndOrderFront(sender)
    }
}

