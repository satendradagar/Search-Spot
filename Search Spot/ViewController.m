//
//  ViewController.m
//  Search Spot
//
//  Created by admin on 03/04/17.
//  Copyright © 2017 Satendra Singh. All rights reserved.
//

#import "ViewController.h"

@interface ViewController()<NSSearchFieldDelegate>

@property (nonatomic,assign) IBOutlet NSSearchField *searchFiled;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _searchFiled.delegate = self;
    // Do any additional setup after loading the view.
}


- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}

- (void)searchFieldDidStartSearching:(NSSearchField *)sender NS_AVAILABLE_MAC(10_11){
    NSLog(@"searchFieldDidStartSearching: %@",_searchFiled.stringValue);

    
}

- (void)searchFieldDidEndSearching:(NSSearchField *)sender NS_AVAILABLE_MAC(10_11){
    NSLog(@"searchFieldDidEndSearching: %@",_searchFiled.stringValue);

}

- (void)controlTextDidChange:(NSNotification *)obj{
    NSLog(@"controlTextDidChange: %@",_searchFiled.stringValue);
//    NSUInteger resultCode=[[NSWorkspace sharedWorkspace] showSearchResultsForQueryString:_searchFiled.stringValue];
    
//    if (resultCode == NO) {
//        // failed to open the panel
//        // present an error to the user
//    }
}

@end
