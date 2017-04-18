//
//  SearchWindowController.m
//  Search Spot
//
//  Created by admin on 15/04/17.
//  Copyright © 2017 Reboot Computer Services. All rights reserved.
//

#import "SearchWindowController.h"

@interface SearchWindowController ()<NSSearchFieldDelegate>

@property (nonatomic,assign) IBOutlet NSMenu *arrangeBy;

@property (nonatomic,assign) IBOutlet NSSearchField *searchFiled;

@end

@implementation SearchWindowController

- (void)windowDidLoad {
    [super windowDidLoad];
    self.listController = (ResultListCollectionController *)[self.window contentViewController];
    _searchFiled.delegate = self;
    [self.window performSelector:@selector(makeFirstResponder:) withObject:_searchFiled afterDelay:0.2];

    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

//-(void)prepareForSegue:(NSStoryboardSegue *)segue sender:(id)sender{
//    
//    if ([segue.identifier isEqualToString:@""]) {
//
//    }
//}

-(void)setSelectedArrangeIndex:(NSUInteger)selectedArrangeIndex{
    
    if (selectedArrange != selectedArrangeIndex) {
        selectedArrange = selectedArrangeIndex;
    }
}

-(NSUInteger)selectedArrangeIndex{
    
    return selectedArrange;
    
}

-(IBAction)seectionDidChanged:(NSPopUpButton *)sender{

     CFStringRef groupString = kMDItemKind;
    NSLog(@"SELECTED:%ld",(long)sender.indexOfSelectedItem);

    switch (sender.indexOfSelectedItem) {
        case 1:
        {
             groupString = kMDItemKind;
        }
            break;
        case 2:
        {
            groupString = kMDItemContentType;

        }
            break;
        case 3:
        {
            groupString = kMDItemFSCreationDate;

        }
            break;
        case 4:
        {
            groupString = kMDItemContentModificationDate;

        }
            break;
        case 5:
        {
            groupString = kMDItemLastUsedDate;
        }
            break;
        case 6:
        {
            groupString = kMDItemFSSize;

        }
            break;
            
        default:
            break;
    }
    [_listController rearrangeWithGroupBy:(__bridge NSString *)groupString];
//    [sender.menu selectItemAtIndex:selectedArrange];
}



- (void)searchFieldDidStartSearching:(NSSearchField *)sender {
    
    NSLog(@"searchFieldDidStartSearching: %@",_searchFiled.stringValue);
}

- (void)searchFieldDidEndSearching:(NSSearchField *)sender {
    
    NSLog(@"searchFieldDidEndSearching: %@",_searchFiled.stringValue);
    
}

- (void)controlTextDidChange:(NSNotification *)obj{
    NSLog(@"controlTextDidChange: %@",_searchFiled.stringValue);
    [self.listController searchStartForKeyword:_searchFiled.stringValue];

}


@end
