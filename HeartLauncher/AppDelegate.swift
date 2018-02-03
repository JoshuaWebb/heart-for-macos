//
//  AppDelegate.swift
//  HeartLauncher
//
//  Created by josh on 3/02/2018.
//  Copyright (c) 2018 Joshua Webb. All rights reserved.
//

import Cocoa

// based on https://github.com/theswiftdev/macos-launch-at-login-app
@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    func applicationDidFinishLaunching(aNotification: NSNotification) {
        let suffix = "Launcher"
        let launcherBundleIdentifier = NSBundle.mainBundle().bundleIdentifier!
        let suffixIndex = launcherBundleIdentifier.rangeOfString(suffix, options: NSStringCompareOptions.BackwardsSearch)
        let mainAppIdentifier = launcherBundleIdentifier.substringToIndex(suffixIndex!.startIndex)
        let mainAppName = mainAppIdentifier.componentsSeparatedByString(".").last!

        let runningApps = NSWorkspace.sharedWorkspace().runningApplications
        let isRunning = !runningApps.filter { $0.bundleIdentifier == mainAppIdentifier }.isEmpty

        if !isRunning {
            let path = NSBundle.mainBundle().bundlePath as NSString
            var components = path.pathComponents
            components.removeLast()
            components.removeLast()
            components.removeLast()
            components.append("MacOS")
            components.append(mainAppName)

            let newPath = NSString.pathWithComponents(components)
            NSWorkspace.sharedWorkspace().launchApplication(newPath)
        } else {
            NSLog("Already running")
        }

        NSApplication.sharedApplication().terminate(self)
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }


}

