//
//  SearchScopeController.m
//  Search Spot
//
//  Created by admin on 18/04/17.
//  Copyright © 2017 Reboot Computer Services. All rights reserved.
//

#import "SearchScopeController.h"
#import "NSFileManager+UnhiddenDirectories.h"
#import "ContextualButton.h"
#import "Constants.h"

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
    [self registerForDiskChange];
    _cutomUrls = [NSMutableArray new];
    NSArray *volumes = [[NSFileManager defaultManager] mountedVolumeURLsIncludingResourceValuesForKeys:nil options:NSVolumeEnumerationSkipHiddenVolumes];
    for (NSURL *vol in volumes) {
        
        [self addButtonWithUrl:vol];
        
    }
    
    NSLog(@"%@",volumes);
    // Do view setup here.
}

-(void)dealloc{
    
    [self unRegisterForDiskChange];
    
}

-(void)registerForDiskChange{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleAddChange:) name:ScopeChangeAddedNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleRemveChange:) name:ScopeChangeRemovedNotification object:nil];

}

-(void)unRegisterForDiskChange{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)handleAddChange:(NSNotification *)not{
    
    CustomURLs *url = [not object];
    if ([url.title isEqualToString:@"/"]) {
        return;
    }
    
    for (CustomURLs *itr in _cutomUrls) {
        if ([itr.path.path isEqualToString:url.path.path]) {
            return;//Find existing match
        }
    }
    
    ContextualButton *newBtn = [[ContextualButton alloc] initWithFrame:_application.bounds];
    newBtn.urlObj = url;
    newBtn.containerArr = _cutomUrls;
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
    [_cutomUrls addObject:url];
    [newBtn setTag:4+_cutomUrls.count];
    [[NSNotificationCenter defaultCenter] postNotificationName:ScopeChangeRefreshNotification object:url];

}

-(void)handleRemveChange:(NSNotification *)not{

    CustomURLs *url = [not object];
    if (nil != url) {
        NSUInteger selectedIndex =[_cutomUrls indexOfObject:url];
        if (selectedIndex != NSNotFound) {
            ContextualButton *removing = [_containerView.arrangedSubviews objectAtIndex:selectedIndex + 5];
            if (removing.urlObj == url) {
                [_containerView removeView:removing];
                [_cutomUrls removeObject:url];
                [[NSNotificationCenter defaultCenter] postNotificationName:ScopeChangeRefreshNotification object:url];

            }
        }
    }
}

-(void)addButtonWithUrl:(NSURL *)vol{
    
    CustomURLs *url = [[CustomURLs alloc] initWithUrl:vol];
    [self handleAddChange:[NSNotification notificationWithName:ScopeChangeAddedNotification object:url]];
//    [[NSNotificationCenter defaultCenter] postNotificationName:ScopeChangeAddedNotification object:url];
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
            if (_cutomUrls.count >= sender.tag - 4) {
                CustomURLs *url = [_cutomUrls objectAtIndex:sender.tag - 5];
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
