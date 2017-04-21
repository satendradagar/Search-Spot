//
//  SearchWindowController.m
//  Search Spot
//
//  Created by admin on 15/04/17.
//  Copyright © 2017 Reboot Computer Services. All rights reserved.
//

#import "SearchWindowController.h"

@interface SearchWindowController ()<NSSearchFieldDelegate>
{
    NSMenuItem *lastSelectedItem;
    NSMenuItem *lastSelectedSearchByItem;
}
@property (nonatomic,assign) IBOutlet NSMenu *arrangeBy;

@property (nonatomic,assign) IBOutlet NSSearchField *searchFiled;

@property (nonatomic,assign) IBOutlet NSPopUpButton *arrangeButton;

@property (nonatomic,assign) IBOutlet NSPopUpButton *searchBYButton;

@end

@implementation SearchWindowController

- (void)windowDidLoad {
    [super windowDidLoad];
    self.listController = (ResultListCollectionController *)[self.window contentViewController];
    _searchFiled.delegate = self;
    [self.window performSelector:@selector(makeFirstResponder:) withObject:_searchFiled afterDelay:0.2];
    NSMenuItem *item = [_arrangeBy itemAtIndex:2];
    [_arrangeButton selectItem: item];
    [self seectionDidChanged:_arrangeButton];
    //kMDItemFSName kMDItemDisplayName  kMDItemKind kMDItemCreator kMDItemTextContent kMDItemPublishers kMDItemOrganizations
    NSArray<NSString *> *searchByOptions = @[@"SearchBy:File Name",@"SearchBy:Display Name",@"SearchBy:Type",@"SearchBy:Application Type",@"SearchBy:Text Content",@"SearchBy:Publisher",@"SearchBy:Organization"];
    [_searchBYButton removeAllItems];
    [_searchBYButton addItemsWithTitles:searchByOptions];
    [_searchBYButton selectItemAtIndex:0];
    [self searchByDidChanged:_searchBYButton];
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
    NSMenuItem *selected = sender.selectedItem;
    [selected setState:NSOnState];
    [lastSelectedItem setState:NSOffState];
    lastSelectedItem = selected;
    [_listController rearrangeWithGroupBy:(__bridge NSString *)groupString];
//    [sender.menu selectItemAtIndex:selectedArrange];
}

-(IBAction)searchByDidChanged:(NSPopUpButton *)sender{
    //kMDItemFSName kMDItemDisplayName  kMDItemKind kMDItemCreator kMDItemTextContent kMDItemPublishers kMDItemOrganizations
    CFStringRef groupString = kMDItemFSName;
    NSLog(@"SELECTED:%ld",(long)sender.indexOfSelectedItem);
    
    switch (sender.indexOfSelectedItem) {
        case 0:
        {
            groupString = kMDItemFSName;
        }
            break;
        case 1:
        {
            groupString = kMDItemDisplayName;
            
        }
            break;
        case 2:
        {
            groupString = kMDItemKind;
            
        }
            break;
        case 3:
        {
            groupString = kMDItemCreator;
            
        }
            break;
        case 4:
        {
            groupString = kMDItemTextContent;
        }
            break;
        case 5:
        {
            groupString = kMDItemRights;
            
        }
            break;
        case 6:
        {
            groupString = kMDItemOrganizations;
            
        }
            break;
        default:
            break;
    }
    NSMenuItem *selected = sender.selectedItem;
    [selected setState:NSOnState];
    [lastSelectedSearchByItem setState:NSOffState];
    lastSelectedSearchByItem = selected;
    [_listController setSearchByKey:(__bridge NSString *)(groupString)];
    
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
