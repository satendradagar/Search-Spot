//
//  MetaLookObject.h
//  Search Spot
//
//  Created by admin on 07/04/17.
//  Copyright © 2017 Reboot Computer Services. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Quartz/Quartz.h>

@interface MetaLookObject : NSObject<QLPreviewItem>

+(instancetype) lookObjectWithMeta:(NSMetadataItem *)item;

@end
