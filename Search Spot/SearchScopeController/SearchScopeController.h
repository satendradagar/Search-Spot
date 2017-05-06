//
//  SearchScopeController.h
//  Search Spot
//
//  Created by admin on 18/04/17.
//  Copyright © 2017 Reboot Computer Services. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ResultListCollectionController.h"

@interface SearchScopeController : NSViewController

@property (weak) IBOutlet NSButton *thisMac;

@property (weak) IBOutlet NSButton *home;

@property (weak) IBOutlet NSButton *shared;

@property (weak) IBOutlet NSButton *application;

@property (weak) IBOutlet NSStackView *containerView;

@property (nonatomic,retain) NSMutableArray *cutomUrls;


@property (weak) IBOutlet ResultListCollectionController *listController;

@end

@interface CustomURLs : NSObject

@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSURL *path;

-(instancetype)initWithUrl:(NSURL *)url;

@end
