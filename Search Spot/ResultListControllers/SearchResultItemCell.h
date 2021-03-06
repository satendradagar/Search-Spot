//
//  SearchResultItemCell.h
//  Search Spot
//
//  Created by admin on 04/04/17.
//  Copyright © 2020 CoreBits Software Solutions Pvt Ltd. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface SearchResultItemCell : NSCollectionViewItem

-(void)configureWithMeta:(NSMetadataItem *)item;

@property (nonatomic,strong)  NSMetadataItem *itemObject;

@property (assign) BOOL customSelection;

@end
