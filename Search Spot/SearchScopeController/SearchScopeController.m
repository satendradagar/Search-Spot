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
     NSButton *lastSelected;
    
}
@end

@implementation SearchScopeController
/*
 <buttonCell key="cell" type="recessed" title="Recessed" bezelStyle="recessed" alignment="center" controlSize="small" borderStyle="border" imageScaling="proportionallyDown" inset="2" id="ZbB-0U-x5N">
 <behavior key="behavior" pushIn="YES" lightByBackground="YES" lightByGray="YES" changeBackground="YES" changeGray="YES"/>
 <font key="font" metaFont="systemBold" size="12"/>
 </buttonCell>

 */
- (void)viewDidLoad {
    [super viewDidLoad];
    NSArray *volumes = [[NSFileManager defaultManager] mountedVolumeURLsIncludingResourceValuesForKeys:nil options:NSVolumeEnumerationSkipHiddenVolumes];
    for (NSURL *vol in volumes) {
        
        NSString *pathName = [vol lastPathComponent];
        if ([pathName isEqualToString:@"/"]) {
            continue;
        }
        
        NSButton *newBtn = [[NSButton alloc] initWithFrame:_application.bounds];

        [newBtn setTitle:[vol lastPathComponent]];
        [newBtn sizeToFit];
        [newBtn setAction:@selector(seectionDidChanged:)];
        [newBtn setTarget:self];
        [newBtn setFont:[NSFont boldSystemFontOfSize:12.0]];
        [_containerView addArrangedSubview:newBtn];
        newBtn.bezelStyle = 13;
        [newBtn setButtonType:NSButtonTypePushOnPushOff];
        [newBtn setAllowsMixedState:NO];
        [newBtn setBordered:YES];
        [newBtn setState:NSOffState];
        [newBtn setShowsBorderOnlyWhileMouseInside:YES];
    }
    NSLog(@"%@",volumes);
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
 
        default:{
//            NSFileManager *fileManager = [NSFileManager defaultManager];
            location = [NSString stringWithFormat:@"/Volumes/%@",sender.title];
            locations = @[location];

        }
            break;
    }
    [_listController searchScopeForLocation:locations];
}
@end
