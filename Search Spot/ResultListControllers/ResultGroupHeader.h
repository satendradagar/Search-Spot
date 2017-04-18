//
//  ResultGroupHeader.h
//  Search Spot
//
//  Created by admin on 04/04/17.
//  Copyright © 2017 Reboot Computer Services. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ResultGroupHeader : NSView<NSCollectionViewElement>

@property (nonatomic,assign) IBOutlet NSTextField *groupTitle;

-(void)configureWithGroup:(NSMetadataQueryResultGroup *)group;

@end
