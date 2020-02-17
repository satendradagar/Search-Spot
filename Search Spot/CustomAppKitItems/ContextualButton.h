//
//  ContextualButton.h
//  Search Spot
//
//  Created by Satendra Singh on 02/05/17.
//  Copyright © 2020 CoreBits Software Solutions Pvt Ltd. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SearchScopeController.h"

@interface ContextualButton : NSButton

@property (nonatomic,retain) CustomURLs *urlObj;

@property (nonatomic,weak) NSMutableArray *containerArr;

@end
