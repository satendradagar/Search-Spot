//
//  PreferencesController.m
//  Search Spot
//
//  Created by Satendra Singh on 02/05/17.
//  Copyright © 2017 Reboot Computer Services. All rights reserved.
//

#import "PreferencesController.h"
#import "Constants.h"

@interface PreferencesController ()

@property (nonatomic, weak) IBOutlet NSTableView *table;

@property (nonatomic, weak) IBOutlet NSButton *autoMountCheck;

@property (nonatomic, weak) IBOutlet NSArrayController *arrayController;

@property (nonatomic, assign) BOOL isAutoEnableMounting;

@end

@implementation PreferencesController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isAutoEnableMounting = [[NSUserDefaults standardUserDefaults] boolForKey:@"isAutoMountEnabled"];
    NSLog(@"isAutoEnableMounting:%d",self.isAutoEnableMounting);

    [self registerForDiskChange];
    // Do view setup here.ee
}


-(void)registerForDiskChange{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshView:) name:ScopeChangeRefreshNotification object:nil];

    [[[NSWorkspace sharedWorkspace] notificationCenter] addObserver: self selector:@selector(didMountDisk:) name: NSWorkspaceDidMountNotification object: nil];
    
    [[[NSWorkspace sharedWorkspace] notificationCenter]addObserver: self selector: @selector(didUNMountDisk:) name:NSWorkspaceDidUnmountNotification object: nil];
    
}

-(void)unRegisterForDiskChange{
    
    [[[NSWorkspace sharedWorkspace] notificationCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)dealloc{
    [self unRegisterForDiskChange];
}

-(void)setContentArray:(NSMutableArray *)array{

    _contentArray = array;

}

-(void)refreshView:(NSNotification *)not{
    
    NSLog(@"refreshView::::%lu",(unsigned long)_contentArray.count);
    dispatch_async(dispatch_get_main_queue(), ^{

        [self.arrayController rearrangeObjects];

    });

}

-(void)addButtonWithUrl:(NSURL *)vol{
    
    CustomURLs *url = [[CustomURLs alloc] initWithUrl:vol];
    [[NSNotificationCenter defaultCenter] postNotificationName:ScopeChangeAddedNotification object:url];
    
}

-(IBAction)addNewLocation:(id)sender{
    
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

-(IBAction)removeLocation:(id)sender{
    
    if (_table.selectedRow != NSNotFound) {
        
        CustomURLs *url = [[_arrayController arrangedObjects] objectAtIndex:_table.selectedRow];
        [[NSNotificationCenter defaultCenter] postNotificationName:ScopeChangeRemovedNotification object:url];

    }
}

-(IBAction)autoMountButtonPressed:(NSButton *)sender{
    
    self.isAutoEnableMounting = [[NSUserDefaults standardUserDefaults] boolForKey:@"isAutoMountEnabled"];
    NSLog(@"isAutoEnableMounting:%d",self.isAutoEnableMounting);
//    self.isAutoEnableMounting = [sender state];
}

-(void)didMountDisk:(NSNotification *)not{
    if (NO == self.isAutoEnableMounting) {
        return;
    }
    NSURL *url = [[not userInfo] valueForKey:NSWorkspaceVolumeURLKey];
    NSLog(@"not: %@",not);
    [self addButtonWithUrl:url];
    
}

-(void)didUNMountDisk:(NSNotification *)not{
    
    if (NO == self.isAutoEnableMounting) {
        return;
    }
    
    NSURL *url = [[not userInfo] valueForKey:NSWorkspaceVolumeURLKey];
    
    for (CustomURLs *itr in _contentArray) {
        if ([itr.path.path isEqualToString:url.path]) {
            
            [[NSNotificationCenter defaultCenter] postNotificationName:ScopeChangeRemovedNotification object:itr];

            break;
            
        }
    }
    
    NSLog(@"not: %@",not);
    
    
}


@end
