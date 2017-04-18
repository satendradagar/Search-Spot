//
//  SearchResultItemCell.h
//  Search Spot
//
//  Created by admin on 04/04/17.
//  Copyright © 2017 Reboot Computer Services. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface SearchResultItemCell : NSCollectionViewItem

-(void)configureWithMeta:(NSMetadataItem *)item;

@property (nonatomic,strong)  NSMetadataItem *itemObject;

@property (assign) BOOL customSelection;

@end
