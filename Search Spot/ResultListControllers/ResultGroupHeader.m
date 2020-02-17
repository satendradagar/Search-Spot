//
//  ResultGroupHeader.m
//  Search Spot
//
//  Created by admin on 04/04/17.
//  Copyright © 2020 CoreBits Software Solutions Pvt Ltd. All rights reserved.
//

#import "ResultGroupHeader.h"

@interface ResultGroupHeader ()
{
     NSMetadataQueryResultGroup *groupObject;
}

@end

@implementation ResultGroupHeader

-(void)awakeFromNib{
    [super awakeFromNib];
    _groupTitle.textColor = [NSColor whiteColor];

}
-(void)configureWithGroup:(NSMetadataQueryResultGroup *)group{
    groupObject = group;
    _groupTitle.stringValue = [groupObject.value description];
    
}

- (void)drawRect:(NSRect)dirtyRect {
    // set any NSColor for filling, say white:
    [[NSColor headerColor] setFill];
    NSRectFill(dirtyRect);
    [super drawRect:dirtyRect];
}

@end
