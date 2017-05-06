//
//  PreferencesWindowController.m
//  Search Spot
//
//  Created by Satendra Singh on 03/05/17.
//  Copyright © 2017 Reboot Computer Services. All rights reserved.
//

#import "PreferencesWindowController.h"
#import "PreferencesController.h"

@interface PreferencesWindowController ()


@end

@implementation PreferencesWindowController

- (void)windowDidLoad {
    
    [super windowDidLoad];
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

-(void)setContent:(NSMutableArray *)content{
    
    PreferencesController *prefController = (PreferencesController *)[self contentViewController];
    prefController.contentArray = content;

}

@end
