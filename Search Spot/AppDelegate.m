//
//  AppDelegate.m
//  Search Spot
//
//  Created by admin on 03/04/17.
//  Copyright © 2020 CoreBits Software Solutions Pvt Ltd. All rights reserved.
//

#import "AppDelegate.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>

@interface AppDelegate ()

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    [Fabric with:@[[Crashlytics class]]];
    // Insert code here to initialize your application
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

-(BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender{
    return YES;
}

@end
