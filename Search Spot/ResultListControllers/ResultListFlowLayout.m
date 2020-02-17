//
//  ResultListFlowLayout.m
//  Search Spot
//
//  Created by admin on 04/04/17.
//  Copyright © 2020 CoreBits Software Solutions Pvt Ltd. All rights reserved.
//

#import "ResultListFlowLayout.h"

@implementation ResultListFlowLayout

- (BOOL)shouldInvalidateLayoutForBoundsChange:(NSRect)newBounds; // return YES to cause the collection view to requery the layout for geometry information
{
    return YES;
}

@end
