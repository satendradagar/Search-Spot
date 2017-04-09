//
//  MetaLookObject.m
//  Search Spot
//
//  Created by admin on 07/04/17.
//  Copyright © 2017 Satendra Singh. All rights reserved.
//

#import "MetaLookObject.h"

@interface MetaLookObject()
{
    
}
@property (nonatomic, retain) NSMetadataItem *metaItem;

@end

@implementation MetaLookObject
{
    
}

+(instancetype) lookObjectWithMeta:(NSMetadataItem *)item{
    MetaLookObject *obj = [[MetaLookObject alloc] init];
    obj.metaItem = item;
    return obj;
}


/*!
 * @abstract The URL of the item to preview.
 * @discussion The URL must be a file URL. Return nil if the item is not available for preview (The Preview Panel or View will then display the Loading view).
 */
-(NSURL *) previewItemURL{
    
    NSString *filepath = [_metaItem valueForAttribute:(NSString *)kMDItemPath];
    if (nil == filepath) {
        return [NSURL URLWithString:@"/"];
    }
    return [NSURL fileURLWithPath:filepath];
}


/*!
 * @abstract The item's title this will be used as apparent item title.
 * @discussion The title replaces the default item display name. This property is optional.
 */
-(NSString *) previewItemTitle{
    
    NSString *name = [_metaItem valueForAttribute:(NSString *)kMDItemDisplayName];
    return name;
}

/*!
 * @abstract The preview display state (e.g.: visible page).
 * @discussion The display state is an opaque object used by the Preview Panel and Preview Views. This property is optional.
 */
//@property(readonly) id previewItemDisplayState;

@end
