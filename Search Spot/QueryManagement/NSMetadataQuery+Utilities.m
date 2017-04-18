//
//  NSMetadataQuery+Utilities.m
//  Search Spot
//
//  Created by admin on 03/04/17.
//  Copyright © 2017 Reboot Computer Services. All rights reserved.
//

#import "NSMetadataQuery+Utilities.h"

@implementation NSMetadataQuery (Utilities)


@dynamic isRunning;

//  A query is running when it started and isn't stopped.
// Initially, a query has not ever started. Once startQuery has been called, isStarted will be YES. If it is ever stopped, the results may still be valid, but isStopped will be YES. A query is considered "alive" when it is in this state, and will automatically update the results when files that meet the query's predicate are added, removed or changed in the file system.
- (BOOL)isRunning {
    return [self isStarted] && ![self isStopped];
}

+ (NSSet *)keyPathsForValuesAffectingIsRunning {
    // Cause isRunning to be updated whenever isStarted or isStopped is updated.
    return [NSSet setWithObjects:@"isStarted", @"isStopped", nil];
}


@end
