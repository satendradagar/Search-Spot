//
//  SearchScopeController.m
//  Search Spot
//
//  Created by admin on 18/04/17.
//  Copyright © 2017 Reboot Computer Services. All rights reserved.
//

#import "SearchScopeController.h"
#import "NSFileManager+UnhiddenDirectories.h"

@interface CustomURLs : NSObject

@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSURL *path;

@end

@implementation CustomURLs

-(instancetype)initWithUrl:(NSURL *)url{
    self = [super init];
    if (self) {
        self.title = [url lastPathComponent];
        self.path = url;
    }
    return self;
}

@end

@interface SearchScopeController ()
{
    NSButton *lastSelected;
    NSMutableArray *cutomUrls;
    
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
    cutomUrls = [NSMutableArray new];
    NSArray *volumes = [[NSFileManager defaultManager] mountedVolumeURLsIncludingResourceValuesForKeys:nil options:NSVolumeEnumerationSkipHiddenVolumes];
    for (NSURL *vol in volumes) {
        
        [self addButtonWithUrl:vol];
        
    }
    NSLog(@"%@",volumes);
    // Do view setup here.
}

-(void)addButtonWithUrl:(NSURL *)vol{
    
    CustomURLs *url = [[CustomURLs alloc] initWithUrl:vol];
    if ([url.title isEqualToString:@"/"]) {
        return;
    }

    for (CustomURLs *itr in cutomUrls) {
        if ([itr.path.path isEqualToString:vol.path]) {
            return;//Find existing match
        }
    }
    
    NSButton *newBtn = [[NSButton alloc] initWithFrame:_application.bounds];
    
    [newBtn setTitle:url.title];
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
    [cutomUrls addObject:url];
    [newBtn setTag:4+cutomUrls.count];
  
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
    NSFileManager *fileManager = [NSFileManager defaultManager];

    switch (sender.tag) {
        case 1:
        {
            location = NSMetadataQueryLocalComputerScope;
            
            locations = [fileManager directoriesAtPath:NSOpenStepRootDirectory()];
            // theArray at this point contains all the filenames
            NSLog(@"%@",locations);

        }
            break;

        case 2:
        {
            location = NSMetadataQueryUserHomeScope;

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
 
        default:{
            NSLog(@"sender.tag: %ld",(long)sender.tag);
            if (cutomUrls.count >= sender.tag - 4) {
                CustomURLs *url = [cutomUrls objectAtIndex:sender.tag - 5];
                locations = @[url.path];
                
            }

        }
            break;
    }
    [_listController searchScopeForLocation:locations];
}

-(IBAction)didClickChooseFile:(id)sender{
    
    NSOpenPanel* openDlg = [NSOpenPanel openPanel];
    
    [openDlg setPrompt:@"Add to Search List"];
    [openDlg setCanChooseFiles:NO];
    [openDlg setCanChooseDirectories:YES];
    [openDlg setDirectoryURL:[NSURL fileURLWithPath:@"/Volumes/"]];
    [openDlg beginWithCompletionHandler:^(NSInteger result){
        
        if (result == NSModalResponseOK) {
            [self addButtonWithUrl:openDlg.URL];
        }
    }];
}

@end
