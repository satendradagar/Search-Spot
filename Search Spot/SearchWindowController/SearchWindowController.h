//
//  SearchWindowController.h
//  Search Spot
//
//  Created by admin on 15/04/17.
//  Copyright © 2020 CoreBits Software Solutions Pvt Ltd. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ResultListCollectionController.h"
#import "SearchScopeController.h"

@interface SearchWindowController : NSWindowController
{
    NSUInteger selectedArrange;
}

@property (nonatomic, weak) IBOutlet ResultListCollectionController *listController;

@property (nonatomic, assign) NSUInteger selectedArrangeIndex;

@end
