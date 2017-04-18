//
//  ResultListCollectionController.h
//  Search Spot
//
//  Created by admin on 04/04/17.
//  Copyright © 2017 Reboot Computer Services. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ResultListCollectionController : NSViewController

- (void)rearrangeWithGroupBy:(NSString *) key;

-(void)searchStartForKeyword:(NSString *)keyword;

@end
