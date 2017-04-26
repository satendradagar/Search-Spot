//
//  SearchResultItemCell.m
//  Search Spot
//
//  Created by admin on 04/04/17.
//  Copyright © 2017 Reboot Computer Services. All rights reserved.
//

#import "SearchResultItemCell.h"

@interface SearchResultItemCell ()
{
}

@property (weak) IBOutlet NSImageView *iconView;

@property (nonatomic,assign) IBOutlet NSTextField *itemTitle;
@property (nonatomic,assign) IBOutlet NSTextField *sizeLabel;
@property (nonatomic,assign) IBOutlet NSTextField *pathLabel;

@end

@implementation SearchResultItemCell

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
}

- (void) setHighlightState:(NSCollectionViewItemHighlightState)highlightState{
    switch (highlightState) {
            
        case NSCollectionViewItemHighlightForSelection:
        {
            
        }
            break;
            
        case NSCollectionViewItemHighlightNone:
        {
            
        }
            break;
     
        default:
            break;
    }
}

-(void)configureWithMeta:(NSMetadataItem *)item{
    self.itemObject = item;
//    _itemTitle.stringValue = [self.itemObject valueForAttribute:(NSString *)kMDItemFSName];
    NSLog(@"Support%@",[item valueForAttribute:kMDItemContentType]);
}

-(void)prepareForReuse{
    self.customSelection = NO;
    [super prepareForReuse];
}


- (void)mouseDown:(NSEvent *)theEvent {
    NSLog(@"entered mouseDown, %ld",(long)theEvent.clickCount);
    [super mouseDown:theEvent];
    if (2 == theEvent.clickCount) {
        [self openFile:nil];
    }
 
}
//
- (void)rightMouseDown:(NSEvent *)theEvent {
    NSLog(@"entered rightMouseDown");
    NSMenu *theMenu = [[NSMenu alloc] initWithTitle:@"Menu"];
    [theMenu insertItemWithTitle:@"Open File" action:@selector(openFile:) keyEquivalent:@"" atIndex:0];
    [theMenu insertItemWithTitle:@"Reveal In Finder" action:@selector(revealInFinder:) keyEquivalent:@"" atIndex:1];

    [NSMenu popUpContextMenu:theMenu withEvent:theEvent forView:self.view];
}

-(void)openFile:(id)sender{
    
    NSString *filepath = [_itemObject valueForAttribute:(NSString *)kMDItemPath];
    if (nil != filepath) {
        [[NSWorkspace sharedWorkspace] openFile:filepath];
        
    }

}
-(void)revealInFinder:(id)sender{
    
    NSString *filepath = [_itemObject valueForAttribute:(NSString *)kMDItemPath];
    if (nil != filepath) {
//        [[NSWorkspace sharedWorkspace] openFile:filepath];
        [[NSWorkspace sharedWorkspace] activateFileViewerSelectingURLs:@[[NSURL fileURLWithPath:filepath]]];
        
    }
    
}

@end
