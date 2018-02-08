//
//  BundleExtension.swift
//  Heart
//
//  Created by josh on 8/02/2018.
//  Copyright (c) 2018 Joshua Webb. All rights reserved.
//

import Cocoa

extension NSBundle {
    var displayName: String! {
        return
            objectForInfoDictionaryKey("CFBundleDisplayName") as? String ??
            objectForInfoDictionaryKey("CFBundleName") as? String
    }
}
