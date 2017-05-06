//
//  ContextualButton.m
//  Search Spot
//
//  Created by Satendra Singh on 02/05/17.
//  Copyright © 2017 Reboot Computer Services. All rights reserved.
//

#import "ContextualButton.h"

@implementation ContextualButton

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

- (void)rightMouseDown:(NSEvent *)theEvent {
    NSLog(@"entered rightMouseDown");
    NSMenu *theMenu = [[NSMenu alloc] initWithTitle:@"Menu"];
    [theMenu insertItemWithTitle:@"Remove" action:@selector(delete:) keyEquivalent:@"" atIndex:0];
    [theMenu insertItemWithTitle:@"Reveal In Finder" action:@selector(revealInFinder:) keyEquivalent:@"" atIndex:1];
    
    [NSMenu popUpContextMenu:theMenu withEvent:theEvent forView:self];
}

-(void)delete:(id)sender{
    [self.containerArr removeObject:_urlObj];
    [self removeFromSuperview];
//    NSString *filepath = [_itemObject valueForAttribute:(NSString *)kMDItemPath];
//    if (nil != filepath) {
//        [[NSWorkspace sharedWorkspace] openFile:filepath];
//        
//    }
    
}
-(void)revealInFinder:(id)sender{
    
    NSURL *filepath = [_urlObj path];
    if (nil != filepath) {
        [[NSWorkspace sharedWorkspace] activateFileViewerSelectingURLs:@[filepath]];
        
    }
    
}

@end
