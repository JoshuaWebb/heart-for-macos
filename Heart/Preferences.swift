//
//  Preferences.swift
//  Heart
//
//  Created by josh on 6/02/2018.
//  Copyright (c) 2018 Joshua Webb. All rights reserved.
//

import Foundation

class Preferences {
    static var userDefaults: NSUserDefaults {
        get {
            return NSUserDefaults.standardUserDefaults()
        }
    }

    static var savedWindowHidden: Bool {
        set {
            userDefaults.setBool(newValue, forKey: Constants.PreferenceKey.windowWasHiddenWhenAppWasTerminated)
            userDefaults.synchronize()
        }
        get {
            return userDefaults.boolForKey(Constants.PreferenceKey.windowWasHiddenWhenAppWasTerminated)
        }
    }

    static var alwaysOnTop: Bool {
        set {
            userDefaults.setBool(newValue, forKey: Constants.PreferenceKey.alwaysOnTop)
            userDefaults.synchronize()
        }
        get {
            return userDefaults.boolForKey(Constants.PreferenceKey.alwaysOnTop)
        }
    }

    static var openOnLoginMenuState: Int? {
        set {
            userDefaults.setInteger(newValue!, forKey: Constants.PreferenceKey.openOnLoginMenuState)
            userDefaults.synchronize()
        }
        get {
            return userDefaults.objectForKey(Constants.PreferenceKey.openOnLoginMenuState) as! Int?
        }
    }
}
