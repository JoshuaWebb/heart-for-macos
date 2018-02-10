//
//  LauncherAppDelegate.m
//  HeartLauncher
//
//  Created by josh on 10/02/2018.
//  Copyright (c) 2018 Joshua Webb. All rights reserved.
//

#import "LauncherAppDelegate.h"

@interface LauncherAppDelegate ()
@end

// based on https://github.com/theswiftdev/macos-launch-at-login-app
// and https://blog.timschroeder.net/2012/07/03/the-launch-at-login-sandbox-project/
@implementation LauncherAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    NSString *suffix = @"Launcher";
    NSString *launcherBundleIdentifier = [[NSBundle mainBundle] bundleIdentifier];
    NSRange suffixIndex = [launcherBundleIdentifier rangeOfString:suffix
                                                          options:NSBackwardsSearch];
    NSString *mainAppIdentifier = [launcherBundleIdentifier substringToIndex:suffixIndex.location];
    NSString *mainAppName = [mainAppIdentifier componentsSeparatedByString:@"."].lastObject;

    NSArray *runningApps = [[NSWorkspace sharedWorkspace] runningApplications];

    NSPredicate *isMatch = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        return [[evaluatedObject bundleIdentifier] isEqualToString:mainAppIdentifier];
    }];
    BOOL alreadyRunning = ![runningApps filteredArrayUsingPredicate:isMatch];

    if (!alreadyRunning) {
        NSString *path = [[NSBundle mainBundle] bundlePath];
        NSMutableArray *components = [NSMutableArray arrayWithArray:[path pathComponents]];
        [components removeLastObject]; // <this app name>
        [components removeLastObject]; // LoginItems
        [components removeLastObject]; // Library
        [components addObject:@"MacOS"];
        [components addObject:mainAppName];

        NSString * newPath = [NSString pathWithComponents:components];
        [[NSWorkspace sharedWorkspace] launchApplication:newPath];
    } else {
        NSLog(@"Already running");
    }

    [NSApp terminate: self];
}

@end
