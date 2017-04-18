//
//  SearchWindowController.h
//  Search Spot
//
//  Created by admin on 15/04/17.
//  Copyright © 2017 Reboot Computer Services. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ResultListCollectionController.h"

@interface SearchWindowController : NSWindowController
{
    NSUInteger selectedArrange;
}

@property (nonatomic, weak) IBOutlet ResultListCollectionController *listController;

@property (nonatomic, assign) NSUInteger selectedArrangeIndex;

@end
