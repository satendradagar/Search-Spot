//
//  SearchScopeController.m
//  Search Spot
//
//  Created by admin on 18/04/17.
//  Copyright © 2017 Reboot Computer Services. All rights reserved.
//

#import "SearchScopeController.h"
#import "NSFileManager+UnhiddenDirectories.h"

@interface SearchScopeController ()
{
    __weak NSButton *lastSelected;
    
}
@end

@implementation SearchScopeController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
}

-(void)viewDidAppear{
    [super viewDidAppear];
    [self seectionDidChanged:_home];

}
















-(IBAction)seectionDidChanged:(NSButton *)sender{
    
    [lastSelected setState:NSOffState];
    [sender setState:NSOnState];
    lastSelected = sender;
    NSArray *locations = nil;
    NSString *location = NSMetadataQueryUserHomeScope;
    switch (sender.tag) {
        case 1:
        {
            location = NSMetadataQueryLocalComputerScope;
            
            NSFileManager *fileManager = [NSFileManager defaultManager];
            
            locations = [fileManager directoriesAtPath:NSOpenStepRootDirectory()];
            // theArray at this point contains all the filenames
            NSLog(@"%@",locations);

        }
            break;

        case 2:
        {
            location = NSMetadataQueryUserHomeScope;

            NSFileManager *fileManager = [NSFileManager defaultManager];
            
            locations = [fileManager directoriesAtPath:NSHomeDirectory()];
            // theArray at this point contains all the filenames
            NSLog(@"%@",locations);
   
        }
            break;

        case 3:
        {
            location = [NSString stringWithFormat:@"%@",@"/Users/Shared/"];
            locations = @[location];

        }
            break;

        case 4:
        {
            location = [NSString stringWithFormat:@"%@",@"/Applications"];
            locations = @[location];
        }
            break;

        case 5:
        {
            
        }
            break;
 
        default:
            break;
    }
    [_listController searchScopeForLocation:locations];
}
@end
